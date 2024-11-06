//
//  ScanView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import SwiftUI


struct ScanView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @State private var recognizedText = ""
    @State private var recognizedTexts: [String] = []

    var body: some View {
        VStack {
            DocumentScannerView(recognizedText: $recognizedText)
                .frame(width: 353, height: 300)
            ScrollView {
                Text(recognizedText)
            }.frame(height: 100)
            CartView(recognizedText: $recognizedText)
        }
    }
}

#Preview {
    ScanView()
}


// UIViewControllerRepresentable
struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var recognizedText: String
    @StateObject var translation : TranslationSerivce
    
    init(shoppingViewModel: ShoppingViewModel) {
           self.shoppingViewModel = shoppingViewModel
           _translation = StateObject(wrappedValue: TranslationSerivce(shoppingViewModel: shoppingViewModel))
       }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// VNRecognizeTextRequest
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
    var body: some View {
        NavigationStack{
            VStack {
                NavigationLink(
                    destination: CartView(shoppingViewModel: shoppingViewModel),
                    label: {
                        Text("CartView로 ㄱㄱ").font(.RTitle)
                    })
                
                DocumentScannerView(recognizedText: $recognizedText)
                ScrollView {
                    Text(recognizedText)
                    Text(translation.translatedText)
                }
                
            }
            .onChange(of: recognizedText) { newText in
                // recognizedText의 값이 변경될 때마다 자동으로 번역 함수 호출
                if !newText.isEmpty {
                    translation.translateText(text: newText)
                }
            }
        }
        
//        request.regionOfInterest = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
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

#Preview {
    ScanView(shoppingViewModel: ShoppingViewModel())
}

//#Preview {
//    DocumentScannerView_Previews() as! any View
//}


import NaturalLanguage

let textstring = "Knowledge will give you power"
let tagger = NLTagger(tagSchemes: [.language, .lexicalClass])



//import Foundation
//func pricing(_ text: String) -> String {
//    let pattern = #"^\d{1,2}\.\d{1,2}$"#
//    let regex = try! NSRegularExpression(pattern: pattern, options: [])
//        let range = NSRange(location: 0, length: text.utf16.count)
//        let cleanedText = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
//        return cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
//}
//    let prices = ["4.33", "4€ .33", "14.33"]
////    let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
////    let validPrices = prices.filter { predicate.evaluate(with: $0) }
////    print(validPrices)
////}
//
////for string in validPrices {
////    guard let range = string.range(of: pattern, options: .regularExpression) else {
////        print("\(string)에는 숫자가 없습니다.")
////        continue
////    }
////    print("\(string)에서 숫자로 이루어 진 부분은 \(string[range]) 입니다.") // 가장 앞에 일치하는 부분만 확인 가능
////}
//
////func LO() {
////    let price = "4.33"
////    let regularExpression = #"^\d{1,2}\.\d{1,2}[^€/kg]$"#
////    
////    if let targetIndex = price.range(of: regularExpression, options: .regularExpression) {
////        print("정규식과 일치")
////        print("휴대폰번호 - \(price[targetIndex])")
////    } else {
////        print("정규식과 불일치")
////    }
////}
////print(LO("12.98"))
//
//
//
