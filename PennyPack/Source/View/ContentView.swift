//
//  ContentView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var shoppingViewModel = ShoppingViewModel()
    @StateObject private var listViewModel = ListViewModel()
    var body: some View {
        NavigationStack{
            MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel)
//            VStack {
//                NavigationLink( destination: MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("MainView").font(.PTitle2) } )
//                    .padding(.bottom)
//                NavigationLink( destination: CalendarView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("CalendarView").font(.PTitle2) } )
//                    .padding(.bottom)
//                NavigationLink( destination: ScanView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel), label: { Text("ScanView").font(.PTitle2) } )
//                    .padding(.bottom)
//                NavigationLink( destination: ResultView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("ResultView").font(.PTitle2) } )
//                    .padding(.bottom)
//                NavigationLink( destination: CartView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("CartView").font(.PTitle2) } )
//                    .padding(.bottom)
//                NavigationLink( destination: ReceiptView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel, isButton: .constant(false)), label: { Text("ReceiptView").font(.PTitle2) } )
//                    .padding(.bottom)
//            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
