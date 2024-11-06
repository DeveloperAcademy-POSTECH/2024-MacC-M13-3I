//
//  ContentView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var shoppingViewModel = ShoppingViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                NavigationLink( destination: MainView(), label: { Text("MainView").font(.RTitle) } )
                    .padding(.bottom)
                NavigationLink( destination: CalendarView(), label: { Text("CalendarView").font(.RTitle) } )
                    .padding(.bottom)
                NavigationLink( destination: ScanView(shoppingViewModel: shoppingViewModel), label: { Text("ScanView").font(.RTitle) } )
                    .padding(.bottom)
                NavigationLink( destination: ResultView(), label: { Text("ResultView").font(.RTitle) } )
                    .padding(.bottom)
                NavigationLink( destination: CartView(shoppingViewModel: shoppingViewModel), label: { Text("CartView").font(.RTitle) } )
                    .padding(.bottom)
                NavigationLink( destination: ReceiptView(), label: { Text("ReceiptView").font(.RTitle) } )
                    .padding(.bottom)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
