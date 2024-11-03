//
//  ScanView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import SwiftUI
import VisionKit
import Vision

struct ScanView: View {
    @State private var recognizedText = ""

    var body: some View {
        VStack {
            DocumentScannerView(recognizedText: $recognizedText)
            ScrollView {
                Text(recognizedText)
            }
        }
    }
}

#Preview {
    ScanView()
}

//struct ContentsView: View {
//    @State private var recognizedText = ""
//    @State private var isShowDocumentScanner = false
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                Text(recognizedText)
//            }
//
//            Button("Scan Documents") {
//                isShowDocumentScanner = true
//                recognizedText = ""
//            }
//            .sheet(isPresented: $isShowDocumentScanner) {
//                DocumentScannerView(recognizedText: $recognizedText)
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentsView()
//}



struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var recognizedText: String
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

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
    
    private func recognizeText(in image: UIImage) {
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

struct DocumentScannerView_Previews: PreviewProvider {
    @State static var sampleText = "Sample Recognized Text"
    
    static var previews: some View {
        DocumentScannerView(recognizedText: $sampleText)
    }
}

//#Preview {
//    DocumentScannerView_Previews() as! any View
//}
