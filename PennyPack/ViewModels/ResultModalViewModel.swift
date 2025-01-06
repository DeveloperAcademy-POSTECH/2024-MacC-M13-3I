import Foundation
import SwiftUI

class ResultModalViewModel: ObservableObject{
    @Published var shoppingManager: ShoppingManager
    @Published var listManager: ListManager
    
    @Published var isMainViewActive = false
    @Published var isButton: Bool = false
    
    init(shoppingManager: ShoppingManager, listManager: ListManager) {
        self.shoppingManager = shoppingManager
        self.listManager = listManager
    }
      
}
