//
//  Regex.swift
//  PennyPack
//
//  Created by 장유진 on 11/7/24.
//

import SwiftUI
import Foundation

struct RegexView: View {
    @StateObject var translation : TranslationSerivce
    @Binding var recognizedText: String
//    @State private var translatedText11: String = ""
    @State private var validItemsK: [String] = []

//    var validPrices: [Double]
//    var validItems: String
    
    var body: some View {
        VStack {
            //            print(isValidPhoneNumber("1234567890"))
            //            isValidPhoneNumber(price: "1234567890")
            //            DocumentScannerView(recognizedText: $viewModel.recognizedText)

            Text(recognizedText)
                .foregroundColor(.white)
            Text(translation.translatedText)
                .foregroundColor(.white)
            
            let validPricesF = extractValidPrices(recognizedText.components(separatedBy: .newlines))
            //separator 기준으로 배열로 반환해준 것들을 정규표현식으로 골라냄
            let validItemsF = extractValidItems(recognizedText.components(separatedBy: .newlines))
//            Text("Valid TPrices: \(validT.map { String($0) }.joined(separator: ", "))")
//            Text("Valid TItems: \(validT2.map { String($0)}.joined(separator: ","))")
            VStack(spacing: 0){
                HStack{
                    Text("상품명 프랑스어 \(validItemsF)")
                    Spacer()
                    Text("원")
                    //.map -> 배열의 각 인자들을 string값으로 만들고["a", "b", "c"], .joined -> ,로 구분하며 하나의 배열로 묶기["a, b, c"]
                }.font(.PBody)
                HStack{
                    Text("상품명 한국어 \(validItemsK)")
                    Text(translation.translatedText)
                        .onChange(of: validItemsF) { newValues in
                            // 이전 번역 결과를 지우기 위해 validItemsK 초기화
                            self.validItemsK.removeAll()
                            
                            for item in newValues {
                                translation.translateText(text: item) { result in
                                    DispatchQueue.main.async {
                                        self.validItemsK.append(result)
                                    }
                                }
                            }
                        } // 이 방식은 각 항목을 개별적으로 번역하므로, 항목 수가 많으면 API 호출이 많아질 수 있음. 번역 요청을 일괄 처리로 변경 가능
                            // SwiftUI의 선언적 특성 때문에 뷰 내에서 직접 함수를 호출하는 것은 성능 문제를 일으킬 수 있음. 번역 결과를 저장할 상태 변수를 추가하면, 번역 로직이 뷰 업데이트 주기와 분리되어 더 효율적으로 동작하며, SwiftUI의 선언적 특성에 더 잘 부합함.
                    Spacer()
                    Text("\(validPricesF.map { String($0)}.joined(separator: ", "))€")
                }.font(.PTitle2)
                HStack{
                    Text("수량")
                        .font(.PTitle2)
                    Spacer()
                    Text("1")
                        .font(.PTitle3)
                }
                HStack {
                    Button {
//                        let data = ShoppingItem(korName: translatedText, frcName: "프랑스어", quantity: 1, korUnitPrice: 1, frcUnitPrice: 1, korPrice: 1, frcPrice: 1, time: Date())
                    } label: {
                        Text("저장")
                    }
                }
            }
            .padding(.top, 50)
            .background(
                Rectangle()
//                            .frame(width: 361, height: 158)
                    .foregroundColor(.white)
                    .clipShape(RoundedCorner(radius: 12))
            )
            .padding(.horizontal)
        }
        .padding()
    }
}

let testPrices = ["12.34", "€123.45", ".33€", ",88€", "7.89€/Kg", "4.33€/Kg"]
let testItems = ["soupe à l'oignon", "1.30€/Kg", "234729", "500015740722", "0.84", "43/-/A/ ----"]

let validT = extractValidPrices(testPrices)
let validT2 = extractValidItems(testItems)

func extractValidItems(_ strings: [String]) -> [String] {
    let itemPattern = "[a-zA-ZàâäæáãåāèéêëęėēîïīįíìôōøõóòöœùûüūúÿçćčńñÀÂÄÆÁÃÅĀÈÉÊËĘĖĒÎÏĪĮÍÌÔŌØÕÓÒÖŒÙÛÜŪÚŸÇĆČŃÑ]+"
    let regex = try! NSRegularExpression(pattern: itemPattern, options: .caseInsensitive) //정규 표현식을 생성할 때 대소문자 구분 여부와 같은 전역적인 옵션을 설정하고, 개별 매칭 호출에서는 기본 동작을 유지하는 것이 일반적인 패턴. 필요에 따라 특정 매칭 호출에 대해 다른 옵션을 지정할 수 있지만, 대부분의 경우에는 정규 표현식 생성 시 설정한 옵션이 그대로 적용됨.
    
    return strings.compactMap { string in
        let filteredString = string.filter {
            $0.isLetter
        }
        guard filteredString.count >= 4 else {
            return nil
        }
        let range = NSRange(location:0, length: string.utf16.count)
        guard regex .firstMatch(in: string, options: [], range: range) != nil else {
            return nil
        }
        return string
    }
}

func extractValidPrices(_ strings: [String]) -> [Double] {
    let pricePattern = #"^€?\d*[.,]\d{1,2}€?$"#
    let regex = try! NSRegularExpression(pattern: pricePattern)
    
    return strings.compactMap { string in
        let range = NSRange(location: 0, length: string.utf16.count)
        guard regex.firstMatch(in: string, options: [], range: range) != nil else {
            return nil
        }
        let numberString = string.replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(numberString)
    }
}

#Preview {
    RegexView(translation: TranslationSerivce(), recognizedText: .constant("Sample text"))
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
