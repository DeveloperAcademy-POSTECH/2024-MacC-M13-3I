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
    
    var body: some View {
        
        VStack {
            NavigationStack{
                VStack {
                    NavigationLink( destination: MainView(shoppingViewModel: shoppingViewModel), label: { Text("MainView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: CalendarView(), label: { Text("CalendarView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: ScanView(shoppingViewModel: shoppingViewModel), label: { Text("ScanView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: ResultView(shoppingViewModel: shoppingViewModel), label: { Text("ResultView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: CartView(shoppingViewModel: shoppingViewModel), label: { Text("CartView").font(.RTitle) } )
                        .padding(.bottom)
                    NavigationLink( destination: ReceiptView(shoppingViewModel: shoppingViewModel), label: { Text("ReceiptView").font(.RTitle) } )
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
