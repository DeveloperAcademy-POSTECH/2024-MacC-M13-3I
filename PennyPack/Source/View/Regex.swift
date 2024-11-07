//
//  Regex.swift
//  PennyPack
//
//  Created by 장유진 on 11/7/24.
//

import SwiftUI
import Foundation

struct RegexView: View {
//    @Binding var recognizedText = String
//    @ObservedObject var viewModel: ScanViewModel
    var validPrices: [Double]


    var body: some View {
        VStack {
//            print(isValidPhoneNumber("1234567890"))
//            isValidPhoneNumber(price: "1234567890")
//            DocumentScannerView(recognizedText: $viewModel.recognizedText)
//            let validPrices = extractValidNumbers(viewModel.recognizedText.components(separatedBy: .newlines))
            Text("가격: \(validPrices.map { String($0)}.joined(separator: ", "))")
            
//            Text(viewModel.recognizedText)
            Text("Valid Prices: \(valid.map { String($0) }.joined(separator: ", "))")
        }
        .padding()
    }
}

let testPrices = ["12.34", "1.20", "123.45", "5.6", "4.33€", "7.89€/Kg", "4.33€/Kg"]
//let testItems = ["^[\\W]*$"]
let valid = extractValidNumbers(testPrices)

func extractValidNumbers(_ strings: [String]) -> [Double] {
    let pattern = #"^\d{1,}\.\d{1,2}€?$"#
    let regex = try! NSRegularExpression(pattern: pattern)
    
    return strings.compactMap { string in
        let range = NSRange(location: 0, length: string.utf16.count)
        guard regex.firstMatch(in: string, options: [], range: range) != nil else {
            return nil
        }
        let numberString = string.replacingOccurrences(of: "€", with: "")
        return Double(numberString)
    }
}

#Preview {
    RegexView(validPrices: [0.81])
}

//스캔된 ocr -> 정규표현식으로 걸러내 -> ml 돌리기





// regularExpression
func Lo() {
    let price = "4.33"
    let regularExpression = #"^\d{1,2}\.\d{1,2}(?!\s*\€\/Kg)$"#
    
    if let targetIndex = price.range(of: regularExpression, options: .regularExpression) {
        print("정규식과 일치")
        print("휴대폰번호 - \(price[targetIndex])")
    } else {
        print("정규식과 불일치")
    }
}

// 3. NSRegularExpression을 사용한 커스텀 함수 -> Bool
func matchesPattern(_ string: String, pattern: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    } catch {
        print("Invalid regex pattern: \(error.localizedDescription)")
        return false
    }
}

//
func Number(_ number: String) -> Bool {
    let pattern = "^[0-9]{1,2}\\.[0-9]{2}$"
    return matchesPattern(number, pattern: pattern)
}

// range
func pickout(_ text: String) -> String? {
    let pattern = #"^\d{1,2}\.\d{1,2}$"#
    let string = "12.34"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: text.utf16.count)
    
    if let match = regex.firstMatch(in: text, options: [], range: range) {
        return (text as NSString).substring(with: match.range)
    } else {
        return nil
    }
    
    
    let prices = ["4.33", "4€ .33", "14.33"]
    
    // 2. NSPredicate
    let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
    if predicate.evaluate(with: string) {
        print("패턴과 일치합니다.")
    } else {
        print("패턴과 일치하지 않습니다.")
    }
}
    
    
    
    
    
//
//// 데이터 정제 및 토큰화
//func tokenizeAndLabel(_ text: String) -> [(String, String)] {
//    let priced = pickout(text)
//    let tokens = priced!.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
//    
//    // 토큰에 라벨 붙이기
//    return tokens.map { token in
//        if let _ = Double(token) {
//            return (token, "NUMBER")
//        } else if token.lowercased() == "€" {
//            return (token, "CURRENCY")
//        } else {
//            return (token, "TEXT")
//        }
//    }
//}
//
//// JSON 생성
//func createJSONForCreateML(_ labeledTokens: [(String, String)]) -> String {
//    let jsonObject: [String: Any] = [
//        "tokens": labeledTokens.map { $0.0 },
//        "labels": labeledTokens.map { $0.1 }
//    ]
//    
//    let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
//    return String(data: jsonData, encoding: .utf8)!
//}
//
//// 4. 전체 프로세스
//func processTextForCreateML(_ text: String) -> String {
//    let labeledTokens = tokenizeAndLabel(text)
//    return createJSONForCreateML(labeledTokens)
//}
//
//// 사용 예시
//let inputText = "The price is 14.99 € for this item"
//let jsonOutput = processTextForCreateML(inputText)
//
//func printjson() {
//    print(jsonOutput)
//}
//
////struct RegexView: View {
////    var body: some View {
////        Text("Hello, World!")
////            .onAppear {
////                let inputText = "The price is 14.99 € for this item"
////                let jsonOutput = processTextForCreateML(inputText)
////                print(jsonOutput)
////                saveJsonToFile()
////            }
////    }
////}
////
////#Preview {
////    RegexView()
////}
//
//func saveJsonToFile() {
//    do {
//        let fileURL = URL(fileURLWithPath: "path/to/your/output.json")
//        try jsonOutput.write(to: fileURL, atomically: true, encoding: .utf8)
//    } catch {
//        print("Error writing to file: \(error)")
//    }
//}
