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
//struct aDocumentScannerView: UIViewControllerRepresentable {
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
//    func makeCoordinator() -> aCoordinator {
//        aCoordinator(self)
//    }
//}
//
//class aCoordinator: NSObject, VNDocumentCameraViewControllerDelegate {
//    var parent: aDocumentScannerView
//    
//    init(_ parent: aDocumentScannerView) {
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
//    private func recognizeText(in image: UIImage) {
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
//            DispatchQueue.main.async {
//                self.parent.recognizedText += recognizedStrings.joined(separator: "\n")
//            }
//        }
//        
//        request.recognitionLanguages = ["Ko"]
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
//struct aDocumentScannerView_Previews: PreviewProvider {
//    @State static var sampleText = "Sample Recognized Text"
//    
//    static var previews: some View {
//        aDocumentScannerView(recognizedText: $sampleText)
//    }
//}
