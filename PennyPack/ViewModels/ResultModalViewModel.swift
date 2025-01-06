//
//  ResultModalViewModel.swift
//  PennyPack
//
//  Created by siye on 12/31/24.
//

import Foundation

final class ResultModalViewModel: ObservableObject{
    private let shoppingViewModel: ShoppingManager

     init(shoppingViewModel: ShoppingManager) {
         self.shoppingViewModel = shoppingViewModel
     }

}
