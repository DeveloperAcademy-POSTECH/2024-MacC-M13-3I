import SwiftUI

@main
struct PennyPackApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView(mainViewModel: MainViewModel(shoppingManager: ShoppingManager(), listManager: ListManager()))
        }
    }
}
