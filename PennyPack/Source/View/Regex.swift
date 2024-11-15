import SwiftUI
import Foundation

struct RegexView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var translation : TranslationSerivce
    @Binding var recognizedText: String
    @State private var validItemsK: [String] = []
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    @Binding var isEditing: Bool
    @Binding var recognizedText: String
    @Binding var validItemsK: [String]
    @Binding var validItemsF: [String]
    @Binding var validPricesF: [Double]
    @Binding var quantity: Int
    @Binding var validItemText: String
    @Binding var validPriceText: String
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                if isEditing {
                    // TextField("상품명 프랑스어", text: $validItemsF[0])
                    TextField("상품명 프랑스어", text: $validItemText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(recognizedText.isEmpty ? "상품명 프랑스어" : validItemsF.joined(separator: ", "))
                }
                Spacer()
                Text("\((Int((validPricesF.map { String($0)}.joined(separator: ", "))) ?? 1) * 1490) ")
                Text("원")
            }.font(.PBody)
                .padding(.top, 16)
            HStack{
                Text(translation.translatedText.isEmpty ? "상품명 한국어" : validItemsK.joined(separator: ", "))
                    .onChange(of: validItemsF) { newValues in
                        self.validItemsK.removeAll()
                        for item in newValues {
                            translation.translateText(text: item) { result in
                                DispatchQueue.main.async {
                                    self.validItemsK.append(result)
                                }
                            }
                        }
                    }
                Spacer()
                if isEditing {
                    TextField("", text: $validPriceText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 70)
                    
//                    TextField("", text: Binding(
//                        get: { String(format: "%.2f", self.validPricesF[0]) },
//                        set: { if let value = Double($0) { self.validPricesF[0] = value } }
//                    ))
                        
                } else {
                    Text(recognizedText.isEmpty ? "" : "\(validPricesF.map { String($0)}.joined(separator: ", "))")
                        .padding()
                }
                Text("€")
            }.font(.PTitle2)
                .padding(.top, 4)
            
            HStack{
                Text("수량")
                    .font(.PTitle2)
                Spacer()
                QuantitySelector(quantity: $quantity, minQuantity: 1, maxQuantity: 100)
                    .font(.PTitle3)
            }
            .padding(.top, 16)
            
            HStack(alignment: .bottom) {
                Spacer()
                Button {
                    isEditing.toggle()
                } label: {
                    Text("수정")
                        .font(.PCallout)
                        .foregroundColor(.pWhite)
                        .frame(width: 26, height: 18)
                        .padding(.horizontal, 23)
                        .padding(.vertical, 5)
                        .background(Color.pDarkGray)
                        .buttonStyle(.bordered)
                        .cornerRadius(24)
                }
                .disabled(validItemsF.isEmpty || validPricesF.isEmpty)
                .opacity(validItemsF.isEmpty || validPricesF.isEmpty ? 0.5 : 1.0)
                
                Button {
                    shoppingViewModel.addNewShoppingItem(korName: "\(validItemsK)", frcName: "\(validItemsF)", quantity: quantity, korUnitPrice: Int(validPricesF[0])*1490 , frcUnitPrice: validPricesF[0])
                    dismiss()
                } label: {
                    Text("저장")
                        .font(.PCallout)
                        .foregroundColor(.pWhite)
                        .frame(width: 26, height: 18)
                        .padding(.horizontal, 23)
                        .padding(.vertical, 5)
                        .background(Color.pBlack)
                        .buttonStyle(.bordered)
                        .cornerRadius(24)
                }
                .disabled(validItemsF.isEmpty || validPricesF.isEmpty)
                .opacity(validItemsF.isEmpty || validPricesF.isEmpty ? 0.5 : 1.0)
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
        .modifier(KeyboardAvoidanceModifier())
        .onAppear {
            validItemsF = extractValidItems(recognizedText.components(separatedBy: .newlines))
            validPricesF = extractValidPrices(recognizedText.components(separatedBy: .newlines))
        } .onChange(of: recognizedText) { newValue in
            validItemsF = extractValidItems(newValue.components(separatedBy: .newlines))
            validPricesF = extractValidPrices(recognizedText.components(separatedBy: .newlines))
        }
        .background(Color.pWhite)
    }
}

struct QuantitySelector: View {
    @Binding var quantity: Int
    let minQuantity: Int
    let maxQuantity: Int
    var body: some View {
        HStack(spacing: 20) {
            Button(action: decrementQuantity) {
                Circle()
                    .fill(.pGray)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "minus")
                            .foregroundColor(.pDarkGray)
                    )
            }
            .disabled(quantity <= minQuantity)
            
            Text("\(quantity)")
                .font(.PTitle3)
                .frame(minWidth: 36)
            
            Button(action: incrementQuantity) {
                Circle()
                    .fill(.pGray)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "plus")
                            .foregroundColor(.pDarkGray)
                    )
            }
            .disabled(quantity >= maxQuantity)
        }
    }
    private func incrementQuantity() {
        if quantity < maxQuantity {
            quantity += 1
        }
    }
    
    private func decrementQuantity() {
        if quantity > minQuantity {
            quantity -= 1
        }
    }
}


let testPrices = ["12.34", "€123.45", ".33€", ",88€", "7.89€/Kg", "4.33€/Kg"]
let testItems = ["soupe à l'oignon", "1.30€/Kg", "234729", "500015740722", "0.84", "43/-/A/ ----"]

let validT = extractValidPrices(testPrices)
let validT2 = extractValidItems(testItems)

func extractValidItems(_ strings: [String]) -> [String] {
    let itemPattern = "[a-zA-ZàâäæáãåāèéêëęėēîïīįíìôōøõóòöœùûüūúÿçćčńñÀÂÄÆÁÃÅĀÈÉÊËĘĖĒÎÏĪĮÍÌÔŌØÕÓÒÖŒÙÛÜŪÚŸÇĆČŃÑ]+"
    let regex = try! NSRegularExpression(pattern: itemPattern, options: .caseInsensitive)
    
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
    RegexView(translation: TranslationSerivce(), recognizedText: .constant("Sample text"), shoppingViewModel: ShoppingViewModel())
}
