//
//  MainView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject var currency = CurrencyService()
    var body: some View {
        NavigationView {
            VStack {
                Text("환율")
                Text("프랑스")
                Button("업데이트") {
                    currency.fetchCurrencyData()
                }
                Text(currency.currencyData)
                    .font(.title2) // 스타일
                    .padding()
                NavigationLink(destination: ScanView()) {
                    Text("스캔하러 가기")
                }
            }
        }
    }
}

#Preview {
    MainView()
}
