//
//  MainView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    @ObservedObject var currencyService = CurrencyService()
    @State private var selectedCurrencyType: CurrencyType = .usd  // 기본 선택 통화 설정

    var body: some View {
        VStack {
            Picker("Select Currency", selection: $selectedCurrencyType) {
                ForEach(CurrencyType.allCases) { currencyType in
                    Text(currencyType.rawValue).tag(currencyType)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedCurrencyType) { newCurrencyType in
                currencyService.getRate(for: newCurrencyType.cur_unit)
            }

            if let rate = currencyService.selectedRate {
                Text("Exchange Rate for \(selectedCurrencyType.rawValue): \(String(format: "%.0f", rate))")
                    .padding()
            } else {
                Text("Select a currency to see the rate")
                    .padding()
            }
        }
        .onAppear {
            currencyService.fetchCurrencies()
            currencyService.getRate(for: selectedCurrencyType.cur_unit)
        }
    }
}

#Preview {
    MainView()
}
