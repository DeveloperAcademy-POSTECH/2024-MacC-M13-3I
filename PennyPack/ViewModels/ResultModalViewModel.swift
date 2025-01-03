//
//  ResultModalViewModel.swift
//  PennyPack
//
//  Created by siye on 12/31/24.
//

import Foundation

final class ResultModalViewModel: ObservableObject{
    private let shoppingViewModel: ShoppingViewModel

     init(shoppingViewModel: ShoppingViewModel) {
         self.shoppingViewModel = shoppingViewModel
     }

}
