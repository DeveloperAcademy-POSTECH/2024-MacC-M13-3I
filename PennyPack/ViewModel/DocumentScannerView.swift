//
//  DocumentScannerView.swift
//  PennyPack
//
//  Created by siye on 11/6/24.
//

import Foundation
import SwiftUI
import VisionKit
import Vision

//struct DocumentScannerViewRepresentable: UIViewControllerRepresentable {
//    @Binding var recognizedText: String
//    
//    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
//        let viewController = VNDocumentCameraViewController()
//        viewController.delegate = context.coordinator
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//}

class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
    var parent: DocumentScannerView
    
    init(_ parent: DocumentScannerView) {
        self.parent = parent
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)
            recognizeText(in: image)
        }
        controller.dismiss(animated: true)
    }
    
    func recognizeText(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            DispatchQueue.main.async {
                self.parent.recognizedText += recognizedStrings.joined(separator: "\n")
            }
        }
        
        request.recognitionLanguages = ["Ko"]
        request.usesLanguageCorrection = true
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("\(error).")
        }
    }
}

//struct DocumentScannerView_Previews: PreviewProvider {
//    @State static var sampleText = "Sample Recognized Text"
//    
//    static var previews: some View {
//        DocumentScannerView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel(), recognizedText: $recognizedText)
//    }
//}

struct DocumentScannerView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    @Binding var recognizedText: String
    @StateObject var translation : TranslationSerivce
    
    init(shoppingViewModel: ShoppingViewModel, listViewModel: ListViewModel, recognizedText: Binding<String>) {
        _translation = StateObject(wrappedValue: TranslationSerivce(shoppingViewModel: shoppingViewModel))
        self._recognizedText = recognizedText
    }
    
    func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.pBlack
                
                VStack {
                    cameraViewModel.cameraPreview.ignoresSafeArea()
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
                        .padding(.top, 184)
                    
                    Button(action: {
                        cameraViewModel.capturePhoto { image in
                            // 이미지가 캡처되면 Coordinator의 recognizeText 호출
                            let coordinator = makeCoordinator()
                            coordinator.recognizeText(in: image)
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(.pBlue)
                                .frame(width: 70)
                            Image(systemName: "camera.fill")
                                .resizable()
                                .frame(width: 33, height: 26)
                                .foregroundColor(.white)
                        }
                    })
                      .padding(.top, 18)
                    Text("Recognized Text: \(recognizedText)")
                                        Text("Translated Text: \(translation.translatedText)")

                }
            }
        }.ignoresSafeArea()
    }
}

//#Preview {
//    DocumentScannerView1(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel)
//}

//#Preview {
//    DocumentScannerView_Previews() as! any View
//}


