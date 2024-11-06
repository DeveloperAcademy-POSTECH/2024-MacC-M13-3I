//
//  CartView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

//struct DateItem: Codable, Hashable {
//    var date: Date
//    var items: [ShoppingItem]
//    var total: Int //총 금액
//    var place: String
//}

struct ShoppingItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
//    var quantity: Int
//    var unitPrice: Int //단가
//    var price: Int //수량*단가
//    var time: Date
}

//    @Published var shoppingItem: [ShoppingItem] = []
    
struct CartView: View {
//    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @State var shoppingItems: [ShoppingItem] = []
    @Binding var recognizedText: String
    @State var items: [String] = []
    @State private var multiSelection = Set<UUID>()
    
    var body: some View {
//        NavigationView {
//            List(selection: $multiSelection) {
//                ForEach(recognizedText, id: \.self) { recognizedText in Text(recognizedText)
//                }
//                .onMove(perform: move)
//                .onDelete(perform: delete)
//            }
//            .navigationBarItems(trailing: EditButton())
//        }
//        Text(recognizedText)
    }
    
    func addList(_ text: String) {
        let newItem = ShoppingItem(name: text)
                shoppingItems.append(newItem)
        items.append(recognizedText)
    }
    
//    func move(from source: IndexSet, to destination: Int) {
//        let reversedSource = source.sorted()
//        
//        for index in reversedSource.reversed() {
//            recognizedText.insert(recognizedText.remove(at: index), at: destination)
//        }
//    }
//    func delete(at offsets: IndexSet) {
//        if let first = offsets.first {
//            recognizedText.remove(at: first)
//        }
//    }
}

//#Preview {
//      CartView(recognizedText: $recognizedText)
//}
