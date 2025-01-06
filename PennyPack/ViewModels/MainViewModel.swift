import Foundation
import SwiftUI

class MainViewModel: ObservableObject{
    @Published var shoppingManager: ShoppingManager
    @Published var listManager: ListManager
    
    init(shoppingManager: ShoppingManager, listManager: ListManager) {
        self.shoppingManager = shoppingManager
        self.listManager = listManager
    }
}
