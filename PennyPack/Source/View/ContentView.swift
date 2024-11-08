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
        
        VStack {
            NavigationStack{
                VStack {
                    NavigationLink( destination: MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("MainView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: CalendarView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("CalendarView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: ScanView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel), label: { Text("ScanView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: ResultView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("ResultView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: CartView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), label: { Text("CartView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: ReceiptView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel, isButton: .constant(false)), label: { Text("ReceiptView").font(.RTitle) } )
                        .padding(.bottom)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
