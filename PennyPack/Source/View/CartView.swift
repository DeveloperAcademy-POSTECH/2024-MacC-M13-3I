//
//  CartView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

struct CartView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @State var recognizedText = ["씨씨", "윈터", "이지"]
    @State private var multiSelection = Set<UUID>()
    
    var body: some View {
        VStack{
            List{
                ForEach(shoppingViewModel.testModel, id: \.id){ item in
                    VStack{
                        Text("\(item.testText)")
                    }
                }
            }
            
            NavigationView {
                List(selection: $multiSelection) {
                    ForEach(recognizedText, id: \.self) { recognizedText in Text(recognizedText)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .navigationBarItems(trailing: EditButton())
            }
        }

    }
    
    func move(from source: IndexSet, to destination: Int) {
        let reversedSource = source.sorted()
        
        for index in reversedSource.reversed() {
            recognizedText.insert(recognizedText.remove(at: index), at: destination)
        }
    }
    func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            recognizedText.remove(at: first)
        }
    }
}

#Preview {
    CartView(shoppingViewModel: ShoppingViewModel())
}
