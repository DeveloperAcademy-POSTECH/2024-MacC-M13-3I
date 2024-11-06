//
//  ReceiptView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

struct ReceiptView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    var body: some View {
        Text("ReceiptView")
    }
}

#Preview {
    ReceiptView(shoppingViewModel: ShoppingViewModel())
}
