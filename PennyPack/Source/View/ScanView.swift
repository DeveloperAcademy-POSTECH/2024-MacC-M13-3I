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
        VStack {
            DocumentScannerView(recognizedText: $recognizedText)
                .frame(width: 353, height: 300)
            ScrollView {
                Text(recognizedText)
                Text("번역된 거 밑에 ~")
                Text(translation.translatedText)
            }.frame(height: 100)
            CartView(shoppingViewModel: shoppingViewModel)
        }
    }
}

#Preview {
    ScanView(shoppingViewModel: ShoppingViewModel())
}
