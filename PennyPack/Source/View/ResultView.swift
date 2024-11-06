//
//  ResultView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

struct ResultView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    var body: some View {
        Text("ResultView")
    }
}

#Preview {
    ResultView(shoppingViewModel: ShoppingViewModel())
}
