import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var shoppingViewModel = ShoppingManager()
    @StateObject private var listViewModel = ListManager()
    
    var body: some View {
        MainView(mainViewModel: MainViewModel(shoppingManager: shoppingViewModel, listManager: listViewModel))
    }
}
#Preview {
    ContentView()
}
