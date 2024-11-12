//
//  Scan2Service.swift
//  PennyPack
//
//  Created by 장유진 on 11/11/24.
//

import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    let model: CameraModel
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    
    let cameraPreview: AnyView
    
    var currentZoomFactor: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    
    @Published var recentImage: UIImage? // 캡쳐된 이미지
    @Published var isFlashOn = false
    @Published var isSilentModeOn = true
    @Published var shutterEffect = false
    @Published var showPreview = false
    @Published var isCameraActive = true
    @Published var isHapticEnabled = true
    
    var captureCompletion: ((UIImage) -> Void)?
    
    init() {
        model = CameraModel()
        session = model.session
        cameraPreview = AnyView(CameraPreview(session: session))
        
        setupBindings()
    }
    
    private func setupBindings() {
        model.$recentImage
            .assign(to: \.recentImage, on: self)
            .store(in: &subscriptions)
        
        model.$isCameraBusy
            .assign(to: \.isCameraActive, on: self)
            .store(in: &subscriptions)
        
        $showPreview
            .sink { [weak self] newValue in
                if newValue == false {
                    self?.recentImage = nil
                    print("showPreview 종료, recentImage nil 초기화 완료")
                    self?.model.setupSession()
                }
            }
            .store(in: &subscriptions)
    }
    
    func configure() {
        model.checkPermissionAndSetupSession()
        
    }
    
    func switchFlash() {
        isFlashOn.toggle()
        model.flashMode = isFlashOn == true ? .on : .off
    }
    
    func switchSilent() {
        isSilentModeOn.toggle()
        model.isSilentModeOn = isSilentModeOn
    }
    
    /// 2번 햅팁 기능 + CameraModel에 View에서 넘겨 받은 코드블럭(completion) 전달
    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        model.capturePhoto(completion: completion)
        print("[CameraViewModel]: Photo captured!")
        showPreview = true
        
        model.disableHaptic()
        isCameraActive = false
        
        withAnimation(.easeInOut(duration: 0.1)) {
            shutterEffect = true
        }
        captureCompletion = completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.shutterEffect = false
                // TODO: uiImage 넘겨주기
            }
        }
    }
//    func capturePhoto() {
//            model.capturePhoto { image in
//                DispatchQueue.main.async {
//                    self.recentImage = image
//                    print("[CameraViewModel]: Photo captured!")
//                    self.showPreview = true
//
//                    self.model.disableHaptic()
//                    self.isCameraActive = false
//                    
//                    withAnimation(.easeInOut(duration: 0.1)) {
//                        self.shutterEffect = true
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        withAnimation(.easeInOut(duration: 0.1)) {
//                            self.shutterEffect = false
//                        }
//                    }
//                }
//            }
//        }
    
    func zoom(factor: CGFloat) {
        let delta = factor / lastScale
        lastScale = factor
        
        let newScale = min(max(currentZoomFactor * delta, 1), 5)
        model.zoom(newScale)
        currentZoomFactor = newScale
    }
    
    func zoomInitialize() {
        lastScale = 1.0
    }
    
    func reset() {
        showPreview = false
        enableCameraAndHaptic()
        model.setupSession()
    }
    
    func enterChatView() {
        disableCameraAndHaptic()
        print("[CameraViewModel]: Entered chat view, camera and haptic disabled")
    }
    
    private func disableCameraAndHaptic() {
        isCameraActive = false
        isHapticEnabled = false
        model.disableHaptic()
    }
    
    private func enableCameraAndHaptic() {
        isCameraActive = true
        isHapticEnabled = true
        model.enableHaptic()
    }
}

struct CameraGuidePreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

