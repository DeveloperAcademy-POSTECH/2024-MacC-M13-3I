import Foundation
import SwiftData

@Model
class ShoppingManager {
    var receiptDate: [ReceiptDate] = []
    var cartItem: [CartItem] = []
    var selectedReceiptDate: ReceiptDate?
    
    var nowBudget: Int?
    var nowPlace: String = ""
    
    init(){        
    }
    // MARK: 리스트에 새 값 추가 함수
    func addNewCartItem(korName: String, frcName: String, quantity: Int, korUnitPrice: Int, frcUnitPrice: Double) -> CartItem {
        let newCartItem: CartItem = CartItem(korName: korName, frcName: frcName, quantity: quantity, korUnitPrice: korUnitPrice, frcUnitPrice: frcUnitPrice, time: Date())
        cartItem.insert(newCartItem, at: 0)
        return newCartItem
    }
    
    func removeList(at offsets: IndexSet) {
        cartItem.remove(atOffsets: offsets)
        print("Updated shoppingList: \(cartItem)")
    }
    
    // MARK: UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        for item in receiptDate {
            print("날짜: \(item.date)")
            for index in item.items{
                print(index.korName)
            }
        }

    }
    
}


