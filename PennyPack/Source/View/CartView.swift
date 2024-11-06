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
    @State var shoppingItems: [ShoppingItem] = []
    
    var body: some View {
        VStack{
            List{
                ForEach(shoppingViewModel.testModel, id: \.id){ item in
                    VStack{
                        Text("\(item.testText)")
                    }
                }
            }
        }
    }
    
}

#Preview {
    CartView(shoppingViewModel: ShoppingViewModel())
}

