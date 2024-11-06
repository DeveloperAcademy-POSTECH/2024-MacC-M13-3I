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
            CartView(shoppingViewModel: shoppingViewModel)
        }
    }
}

#Preview {
    ScanView(shoppingViewModel: ShoppingViewModel())
}
