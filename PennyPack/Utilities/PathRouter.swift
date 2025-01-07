import SwiftUI

enum NavigationRoute: Hashable {
    case cart
    case result
}

final class PathRouter: ObservableObject {
    @Published var path = [NavigationRoute]()
    
    func push(_ route: NavigationRoute) {
        path.append(route)
    }
    
    func removeAll() {
        path.removeAll()
    }
}


final class PathViewModel: ObservableObject {
    @Published var path = NavigationPath()
}
