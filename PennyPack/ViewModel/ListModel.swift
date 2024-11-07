//
//  ListModel.swift
//  PennyPack
//
//  Created by siye on 11/6/24.
//

import Foundation

struct ShoppingList: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var isChoise: Bool
    
}

//extension ShoppingList {
//    static let testSingleMonth: ShoppingList = ShoppingList(title: "March")
//    static let testAllMonths: [ShoppingList] = [
//        ShoppingList(title: "January"),
//        ShoppingList(title: "February"),
//        ShoppingList(title: "March"),
//        ShoppingList(title: "April"),
//        ShoppingList(title: "May"),
//        ShoppingList(title: "June"),
//        ShoppingList(title: "July"),
//        ShoppingList(title: "August"),
//        ShoppingList(title: "September"),
//        ShoppingList(title: "October"),
//        ShoppingList(title: "November"),
//        ShoppingList(title: "December")
//    ]
//}


class ListViewModel: ObservableObject {
    @Published var shoppingList: [ShoppingList] = []
    
    init() {
        if shoppingList.isEmpty {
            self.shoppingList = [
                    ShoppingList(title: "January", isChoise: false),
                    ShoppingList(title: "February", isChoise: false),
                    ShoppingList(title: "March", isChoise: false),
                    ShoppingList(title: "April", isChoise: false),
                    ShoppingList(title: "May", isChoise: false)
            ]
        }
        loadShoppingListFromUserDefaults()
    }
    
    // MARK: 리스트에 새 값 추가 함수
    func addLinkList(title: String) {
        let linkList: ShoppingList = ShoppingList(title: title, isChoise: false)
        shoppingList.append(linkList)
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
                self.shoppingList = saveLists // 불러온 데이터를 shoppingList에 할당
            }
        }
    }
    
}
