import Foundation
import SwiftUI
import VisionKit
import Vision

class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
    var parent: ScannerRetakeView
    
    init(_ parent: ScannerRetakeView) {
        self.parent = parent
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)
            recognizeText(in: image)
        }
        controller.dismiss(animated: true)
    }
    
    /// 7. 이미지를 전달받아서 텍스트로 변화
    func recognizeText(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            print("Recognized text:")
            print(recognizedStrings.joined(separator: "\n"))
            
            DispatchQueue.main.async {
                /// 8. parent에 있는 recognizedText의 값을 이미지를 분석해서 얻은 텍스트로 변경
                self.parent.recognizedText = recognizedStrings.joined(separator: "\n")
            }
        }
        
        request.recognitionLanguages = ["fr"]
        request.usesLanguageCorrection = true
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("\(error).")
        }
    }
}

struct ScannerRetakeView: View {
    
    @StateObject private var cameraViewModel = CameraViewModel()
    @ObservedObject var translation: TranslationSerivce
    
    @State var recentImage: UIImage?
    @State var isPicture: Bool = false
    
    @Binding var isEditing: Bool
    @Binding var recognizedText: String
    @Binding var validItemsK: [String]
    @Binding var validItemsF: [String]
    @Binding var validPricesF: [Double]
    @Binding var quantity: Int
    @Binding var validItemText: String
    @Binding var validPriceText: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func reset() {
        isEditing = false
        recognizedText = ""
        validItemsK.removeAll()
        validItemsF.removeAll()
        validPricesF.removeAll()
        quantity = 1
        validItemText = ""
        validPriceText = ""
    }
    
    var body: some View {
        if isPicture {
            VStack {
                if let image = recentImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 360, height: 350)
                        .cornerRadius(11)
                        .padding(.top, 86)
                }
                Button(action: {
                    isPicture = false
                    reset()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.pGray)
                            .frame(width: 50, height: 50)
                        Image(systemName: "camera.rotate.fill")
                            .resizable()
                            .frame(width: 28, height: 22)
                            .foregroundColor(.white)
                    }
                })
            }
        } else {
            VStack {
                cameraViewModel.cameraPreview.ignoresSafeArea()
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.white.opacity(0.5), lineWidth: 3)
                    )
                    .onAppear {
                        cameraViewModel.configure()
                    }
                    .gesture(MagnificationGesture()
                        .onChanged { val in
                            cameraViewModel.zoom(factor: val)
                        }
                        .onEnded { _ in
                            cameraViewModel.zoomInitialize()
                        }
                    )
                    .frame(width: 360, height: 350)
                    .cornerRadius(11)
                    .padding(.top, 86)
                Button(action: {
                    /// 1. 카메라 버튼 클릭
                    cameraViewModel.capturePhoto { image in
                        /// 5. Camera Model에서 사진이 찍히면, completion을 호출하면서 image로 찍힌 사진을 전달해줌. recentImage 설정
                        DispatchQueue.main.async {
                            self.recentImage = image
                            print("Image captured and set to recentImage")
                            isPicture = true

                            let coordinator = makeCoordinator()
                            coordinator.recognizeText(in: image)
                        }
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.pBlue)
                            .frame(width: 50, height: 50)
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 28, height: 22)
                            .foregroundColor(.white)
                    }
                })
                .onChange(of: recentImage) { _, newImage in
                   /// 6. recentImage의 변화에 따라 아래 코드 실행. coordinator에 recognizeText로 이미지에 있는 텍스트 인식 기능 구현
                }
            }
        }
    }
}



