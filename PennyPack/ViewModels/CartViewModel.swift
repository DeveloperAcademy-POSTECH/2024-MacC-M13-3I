import Foundation
import SwiftUI

class CartViewModel: ObservableObject{
    let shoppingManager: ShoppingManager
    
    @Published var recognizedText = ""
    @Published var isAlert: Bool = false
    @Published var isFinish: Bool = false
    @Published var isPlus = false
    @Published var isDropdownExpanded = false
    @Published var isScan: Bool = false
    @Published var totalPriceWon: Int = 0
    @Published var totalPriceEuro: Double = 0.0
    @Published var editingItemID: UUID? = nil
  
    
    init(shoppingManager: ShoppingManager) {
        self.shoppingManager = shoppingManager
    }

    func korTotalPricing(from items: [CartItem]) -> Int {
        var total = 0
        for index in items.indices {
            total += items[index].korUnitPrice * items[index].quantity
        }
        return total
    }
    
    func frcTotalPricing(from items: [CartItem]) -> Double {
        var total: Double = 0.0
        for index in items.indices {
            total += items[index].frcUnitPrice * Double(items[index].quantity)
        }
        return total
    }
    
    
    func pricing() {
        totalPriceWon = korTotalPricing(from: shoppingManager.cartItem)
        totalPriceEuro = frcTotalPricing(from: shoppingManager.cartItem)
    }
}
