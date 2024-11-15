//import Foundation
//import SwiftUI
//
//func pricing(_ text: String) -> String {
//    let pattern = #"^\d{1,2}\.\d{1,2}$"#
//    let regex = try! NSRegularExpression(pattern: pattern, options: [])
//        let range = NSRange(location: 0, length: text.utf16.count)
//        let cleanedText = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
//        return cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
//}
//    let prices = ["4.33", "4€ .33", "14.33"]
//
//func tokenizeAndLabel(_ text: String) -> [(String, String)] {
//    let priced = pricing(text)
//    let tokens = priced.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
//    
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
//struct LanguageSelectedView: View {
//    @ObservedObject var currencyService = CurrencyService()
//    @State private var selectedCurrencyType: CurrencyType = .usd
//
//    var body: some View {
//        VStack {
//            Picker("Select Currency", selection: $selectedCurrencyType) {
//                ForEach(CurrencyType.allCases) { currencyType in
//                    Text(currencyType.rawValue).tag(currencyType)
//                }
//            }
//            .pickerStyle(.menu)
//            .onChange(of: selectedCurrencyType) { newCurrencyType in
//                currencyService.getRate(for: newCurrencyType.cur_unit)
//            }
//
//            if let rate = currencyService.selectedRate {
//                Text("Exchange Rate for \(selectedCurrencyType.rawValue): \(String(format: "%.0f", rate))")
//                    .padding()
//            } else {
//                Text("Select a currency to see the rate")
//                    .padding()
//            }
//        }
//        .onAppear {
//            currencyService.fetchCurrencies()
//            currencyService.getRate(for: selectedCurrencyType.cur_unit)
//        }
//    }
//}
//
//#Preview {
//    LanguageSelectedView()
//}
