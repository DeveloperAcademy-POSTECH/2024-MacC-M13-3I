import SwiftUI
import Foundation

struct RegexView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var scanViewModel: ScanViewModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                if scanViewModel.isEditing {
                    TextField("상품명 프랑스어", text: $scanViewModel.validItemText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            scanViewModel.validItemsF = [scanViewModel.validItemText]
                                scanViewModel.firstExecuteTranslation()
                            }
                } else {
                    Text(scanViewModel.recognizedText.isEmpty ? "상품명 프랑스어" : scanViewModel.validItemsF.joined(separator: ", "))
                }
                Spacer()
                if scanViewModel.isEditing {
                    Text("\(scanViewModel.korUnitPrice)")
                }
                else {
                    Text("\((scanViewModel.validPricesF.first.map { Int($0 * 1490) } ?? 0))")
                }
                
                Text("원")
            }.font(.PBody)
                .padding(.top, 16)
            HStack{
                Text(scanViewModel.translation.translatedText.isEmpty ? "상품명 한국어" : scanViewModel.validItemsK.joined(separator: ", "))
                    .onChange(of: scanViewModel.validItemsF) { newValues in
                            scanViewModel.firstExecuteTranslation()
                    }
                Spacer()
                if scanViewModel.isEditing {
                    TextField("", text: $scanViewModel.validPriceText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 70)
                        .onSubmit {
                            scanViewModel.frcUnitPrice = Double(scanViewModel.validPriceText) ?? 0
                            scanViewModel.korUnitPrice = Int(scanViewModel.frcUnitPrice) * 1490
                        }
                        .onChange(of: scanViewModel.validPriceText) { newValue in
                            scanViewModel.frcUnitPrice = Double(newValue) ?? 0
                            scanViewModel.korUnitPrice = Int(scanViewModel.frcUnitPrice) * 1490
                        }
                } else {
                    Text(scanViewModel.recognizedText.isEmpty ? "" : "\(scanViewModel.validPricesF.map { String($0)}.joined(separator: ", "))")
                        .padding()
                }
                Text("€")
            }.font(.PTitle2)
                .padding(.top, 4)
            
            HStack{
                Text("수량")
                    .font(.PTitle2)
                Spacer()
                QuantitySelectorView(scanViewModel: scanViewModel, minQuantity: 1, maxQuantity: 100)
                    .font(.PTitle3)
            }
            .padding(.top, 16)
            HStack(alignment: .bottom) {
                Spacer()
                Button {
                    scanViewModel.isEditing.toggle()
                    
                    print("validPriceText 얼마냐 :",scanViewModel.validPriceText)
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
                Button {
                    scanViewModel.validItemsF = [scanViewModel.validItemText]
                    scanViewModel.frcUnitPrice = Double(scanViewModel.validPriceText) ?? 0
                    scanViewModel.korUnitPrice = Int(scanViewModel.frcUnitPrice) * 1490
                        scanViewModel.executeTranslation {
                        scanViewModel.shoppingManager.addNewCartItem(
                            korName: "\(scanViewModel.validItemsK.joined(separator: ", "))",
                            frcName: "\(scanViewModel.validItemsF.joined(separator: ", "))",
                            quantity: scanViewModel.quantity,
                            korUnitPrice: scanViewModel.korUnitPrice,
                            frcUnitPrice: scanViewModel.frcUnitPrice
                           )
                           dismiss()
                       }
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
                .disabled(scanViewModel.validItemText.isEmpty || scanViewModel.validPriceText.isEmpty )
                .opacity(scanViewModel.validItemText.isEmpty || scanViewModel.validPriceText.isEmpty ? 0.5 : 1.0)
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
        .modifier(KeyboardAvoidanceModifier())
        .onAppear {
            scanViewModel.validItemsF = extractValidItems(scanViewModel.recognizedText.components(separatedBy: .newlines))
            scanViewModel.validPricesF = extractValidPrices(scanViewModel.recognizedText.components(separatedBy: .newlines))
                   }
        .onChange(of: scanViewModel.recognizedText) { newValue in
            let items = extractValidItems(newValue.components(separatedBy: .newlines))
            let itemString = items.joined(separator: ", ")
            scanViewModel.validItemText = itemString
            scanViewModel.validItemsF = items
            
            
            let prices = extractValidPrices(scanViewModel.recognizedText.components(separatedBy: .newlines))
            if !prices.isEmpty {
                scanViewModel.validPriceText = String(prices[0])
            }
            
            scanViewModel.validPricesF = prices
            
        }
        .background(Color.pWhite)
    }
}


