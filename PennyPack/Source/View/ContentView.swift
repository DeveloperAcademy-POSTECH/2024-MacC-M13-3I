import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var shoppingViewModel = ShoppingViewModel()
    @StateObject private var listViewModel = ListViewModel()
    
    var body: some View {
        MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel)
    }
}
#Preview {
    ContentView()
}
