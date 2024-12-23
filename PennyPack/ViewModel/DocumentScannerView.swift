////
////  DocumentScannerView.swift
////  PennyPack
////
////  Created by siye on 11/6/24.
////
//
//import Foundation
//import SwiftUI
//import VisionKit
//import Vision
//
////struct DocumentScannerViewRepresentable: UIViewControllerRepresentable {
////    @Binding var recognizedText: String
////
////    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
////        let viewController = VNDocumentCameraViewController()
////        viewController.delegate = context.coordinator
////        return viewController
////    }
////
////    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
////
////    func makeCoordinator() -> Coordinator {
////        Coordinator(self)
////    }
////}
//
//class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
//    var parent: DocumentScannerView
//    
//    init(_ parent: DocumentScannerView) {
//        self.parent = parent
//    }
//    
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//        for pageIndex in 0..<scan.pageCount {
//            let image = scan.imageOfPage(at: pageIndex)
//            recognizeText(in: image)
//        }
//        controller.dismiss(animated: true)
//    }
//    
//    /// 7. 이미지를 전달받아서 텍스트로 변화
//    func recognizeText(in image: UIImage) {
//        guard let cgImage = image.cgImage else { return }
//        
//        let request = VNRecognizeTextRequest { (request, error) in
//            guard let observations = request.results as? [VNRecognizedTextObservation],
//                  error == nil else { return }
//            
//            let recognizedStrings = observations.compactMap { observation in
//                observation.topCandidates(1).first?.string
//            }
//            
//            print("Recognized text:")
//            print(recognizedStrings.joined(separator: "\n"))
//            
//            DispatchQueue.main.async {
//                /// 8. parent에 있는 recognizedText의 값을 이미지를 분석해서 얻은 텍스트로 변경
//                self.parent.recognizedText = recognizedStrings.joined(separator: "\n")
//            }
//        }
//        
//        request.recognitionLanguages = ["fr"]
//        request.usesLanguageCorrection = true
//        
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("\(error).")
//        }
//    }
//}
//
//struct DocumentScannerView: View {
//    @StateObject private var cameraViewModel = CameraViewModel()
//    @Binding var recognizedText: String
//    @StateObject var translation : TranslationSerivce
//    @State var recentImage: UIImage?
//    @State var isRetake: Bool = false
//    
//    init(recognizedText: Binding<String>) {
//        _translation = StateObject(wrappedValue: TranslationSerivce())
//        self._recognizedText = recognizedText
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    var body: some View {
//        VStack {
//            if let image = recentImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 360, height: 350)
//                    .cornerRadius(11)
//                    .padding(.top, 86)
//            } else {
//                cameraViewModel.cameraPreview.ignoresSafeArea()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 11)
//                            .stroke(Color.white.opacity(0.5), lineWidth: 3)
//                    )
//                    .onAppear {
//                        cameraViewModel.configure()
//                    }
//                    .gesture(MagnificationGesture()
//                        .onChanged { val in
//                            cameraViewModel.zoom(factor: val)
//                        }
//                        .onEnded { _ in
//                            cameraViewModel.zoomInitialize()
//                        }
//                    )
//                    .frame(width: 360, height: 350)
//                    .cornerRadius(11)
//                    .padding(.top, 86)
//            }
//            
////            Button(action: {
//                // 1번 카메라 버튼 클릭
//                cameraViewModel.capturePhoto { image in
//                    /// 5. Camera Model에서 사진이 찍히면, completion을 호출하면서 image로 찍힌 사진을 전달해줌. recentImage 설정
//                    // 이미지가 캡처되면 Coordinator의 recognizeText 호출
//                    DispatchQueue.main.async {
//                        self.recentImage = image
//                        //캡쳐된 이미지 띄우기
//                        print("Image captured and set to recentImage")
//                    }
//                    
//                }
//            }, label: {
//                ZStack {
//                    Circle()
//                        .foregroundColor(.pBlue)
//                        .frame(width: 50, height: 50)
//                    Image(systemName: "camera.fill")
//                        .resizable()
//                        .frame(width: 28, height: 22)
//                        .foregroundColor(.white)
//                }
//            })
//            .onChange(of: recentImage) { _, newImage in
//                /// 6. recentImage의 변화에 따라 아래 코드 실행. coordinator에 recognizeText로 이미지에 있는 텍스트 인식 기능 구현
//                guard let newImage else { return }
//                let coordinator = makeCoordinator()
//                coordinator.recognizeText(in: newImage)
//            }
//            .padding(.top, 12)
//            //                    VStack {
//            //                        /// 11. 전달받은 recognizedText와 translation에 있는 translatedText를 화면에 보여준다.
//            //                        Text("Recognized Text: \(recognizedText)")
//            //                        Text("Translated Text: \(translation.translatedText)")
//            //                    }
//            //                    .foregroundStyle(.white)
//            //                    .padding(.vertical, 30)
//            //                    .onChange(of: recognizedText) { oldValue, newValue in
//            //                        /// 9. 이미지에서 텍스트 인식이 종료되고 받은 recognizedText를 받아서 번역을 실행. translation 객체의 translateText 함수에 전달받은 텍스트 전달
//            //                        if oldValue == newValue { return }
//            //                        translation.translateText(text: newValue) { _ in
//            //                        }
//            //                    }
//        }
//    }
//}
//
////#Preview {
////    DocumentScannerView_Previews() as! any View
////}
//
//
