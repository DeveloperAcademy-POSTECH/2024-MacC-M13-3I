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
    @StateObject var translation : TranslationSerivce
    
    init(shoppingViewModel: ShoppingViewModel) {
           self.shoppingViewModel = shoppingViewModel
           _translation = StateObject(wrappedValue: TranslationSerivce(shoppingViewModel: shoppingViewModel))
       }
    
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
    }
}

#Preview {
    ScanView(shoppingViewModel: ShoppingViewModel())
}
