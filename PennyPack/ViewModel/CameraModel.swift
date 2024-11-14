//
//  CameraModel.swift
//  PennyPack
//
//  Created by 장유진 on 11/11/24.
//

import SwiftUI
import AVFoundation
import UIKit
import Vision


class CameraModel: NSObject, ObservableObject,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureVideoDataOutput()
    
    var photoData = Data(count: 0)
    var flashMode: AVCaptureDevice.FlashMode = .off
    var isSilentModeOn = true
    var videoDeviceInput: AVCaptureDeviceInput!
    
    @Published var isCameraBusy = false
    @Published var recentImage: UIImage?
    @Published var session = AVCaptureSession()
    @Published var isSessionActive = false
    @Published var isHapticEnabled = true
    @Published private var showCapturedImage = false
    
    // Vision : 햅틱 관련 코드
    private var impactFeedback : UIImpactFeedbackGenerator?
    private var lastHapticTime: Date = Date.distantPast
    private let hapticInterval: TimeInterval = 1.0
    
    var completion: (UIImage) -> Void
    
    override init() {
        completion = { image in
            
        }
        super.init()
        setupHapticFeedback()
    }
    
    func checkPermissionAndSetupSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupSession()
                    }
                }
            }
        default:
            print("Permission declined")
        }
    }
    
    func setupSession() {
        if session.isRunning {
            session.stopRunning()
        }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
            }
            
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
                photoOutput.isHighResolutionCaptureEnabled = true
                photoOutput.maxPhotoQualityPrioritization = .quality
            }
            
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
                DispatchQueue.main.async {
                    self?.isSessionActive = true
                }
            }
        } catch {
            print(error)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isSessionActive, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        checkAlignment(in: pixelBuffer)
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
            DispatchQueue.main.async {
                self.isSessionActive = false
            }
        }
    }
    
    private func setupHapticFeedback() {
        if isHapticEnabled {
            impactFeedback = UIImpactFeedbackGenerator(style: .soft)
            impactFeedback?.prepare()
        } else {
            impactFeedback = nil
        }
    }
    
    func enableHaptic() {
            isHapticEnabled = true
            setupHapticFeedback()
        }

        // 햅틱 비활성화 함수
        func disableHaptic() {
            isHapticEnabled = false
            impactFeedback = nil
        }
    
    // Vision : 햅틱 관련 코드
    private func checkAlignment(in image: CVPixelBuffer) {
        guard isSessionActive else { return }
        
        let request = VNDetectRectanglesRequest { [weak self] request, error in
            guard let self = self, self.isSessionActive else { return }
            guard let results = request.results as? [VNRectangleObservation] else { return }
            
            if let rect = results.first {
                let boxCenter = CGPoint(x: rect.boundingBox.midX, y: rect.boundingBox.midY)
                let viewCenter = CGPoint(x: 0.5, y: 0.5)
                
                let distance = sqrt(pow(boxCenter.x - viewCenter.x, 2) + pow(boxCenter.y - viewCenter.y, 2))
                
                if distance < 0.1 { // 중심으로부터 10% 이내에 있으면 정렬된 것으로 간주
                    DispatchQueue.main.async {
                        self.alignmentOccurred(at: boxCenter)
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .up)
        try? handler.perform([request])
    }
    
    // Vision : 햅틱 관련 코드
    func alignmentOccurred(at point: CGPoint) {
        if isHapticEnabled {
            let currentTime = Date()
            if currentTime.timeIntervalSince(lastHapticTime) >= hapticInterval {
                impactFeedback?.impactOccurred()
                lastHapticTime = currentTime
                print("Alignment occurred at: \(point)")
            }
        }
    }
    
    /// 3. 받은 코드 블럭을 저장(completion 저장), 사진 캡쳐 기능 구현
    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        // 사진 옵션 세팅
        self.completion = completion
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = self.flashMode
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        print("[Camera]: Photo's taken")
    }
    
    func zoom(_ zoom: CGFloat) {
        let factor = zoom < 1 ? 1 : zoom
        let device = self.videoDeviceInput.device
        
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = factor
            device.unlockForConfiguration()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.isCameraBusy = true
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if isSilentModeOn {
            print("[Camera]: Silent sound activated")
            AudioServicesDisposeSystemSoundID(1108)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if isSilentModeOn {
            AudioServicesDisposeSystemSoundID(1108)
        }
    }
    
    /// 4. 정상적으로 사진이 찍힌 경우, 전달받은 코드블럭(completion)을 호출하면서 이미지 전달 `self.completion(recentImage)`
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.recentImage = UIImage(data: imageData)
        self.isCameraBusy = false
        showCapturedImage = true
        guard let recentImage else { return }
        self.completion(recentImage)
        print("[CameraModel]: Capture routine's done")
//        self.stopSession()
    }
}

