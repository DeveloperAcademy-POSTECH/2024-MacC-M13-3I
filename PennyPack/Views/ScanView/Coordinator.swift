import Foundation
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
                self.parent.scanViewModel.recognizedText = recognizedStrings.joined(separator: "\n")
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
