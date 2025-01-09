import Foundation
import SwiftUI
import SwiftData

class MainViewModel: ObservableObject {
    @Published var shoppingManager: [ShoppingManager]
    @Published var listManager: [ListManager]
    
    init(shoppingManager: [ShoppingManager], listManager: [ListManager]) {
        self.shoppingManager = shoppingManager
        self.listManager = listManager
    }
}
