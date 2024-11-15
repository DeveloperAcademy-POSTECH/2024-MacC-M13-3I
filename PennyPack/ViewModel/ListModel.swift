import Foundation

struct ShoppingList: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var isChoise: Bool
    var isPurchase: Bool
}

class ListViewModel: ObservableObject {
    @Published var shoppingList: [ShoppingList] = []
    
    init() {
        loadShoppingListFromUserDefaults()
    }
    
    // MARK: 리스트에 새 값 추가 함수
    func addLinkList(title: String) {
        let linkList: ShoppingList = ShoppingList(title: title, isChoise: false, isPurchase: false)
        shoppingList.append(linkList)
    }
    
    func removeList(at offsets: IndexSet) {
        shoppingList.remove(atOffsets: offsets)
        saveShoppingListToUserDefaults()

        print("Updated shoppingList: \(shoppingList)")
    }
                     
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(shoppingList) {
            UserDefaults.standard.set(encoded, forKey: "shoppingList")
        }
    }
    
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "shoppingList") {
            if let saveLists = try? JSONDecoder().decode([ShoppingList].self, from: savedData) {
                self.shoppingList = saveLists
            }
        }
    }
    
}
