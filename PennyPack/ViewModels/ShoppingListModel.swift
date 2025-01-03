import Foundation

class ShoppingViewModel:ObservableObject {
    @Published var receiptDate: [ReceiptDate] = []
    @Published var cartItem: [CartItem] = []
    @Published var selectedReceiptDate: ReceiptDate?
    
    @Published var nowBudget: Int?
    @Published var nowPlace: String = ""
    
    init(){        
        loadShoppingListFromUserDefaults()
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
    
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(receiptDate) {
            UserDefaults.standard.set(encoded, forKey: "receiptDate")
        }
        
        print("save 됨")
    }
    
    // MARK: UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "receiptDate") {
            if let saveLists = try? JSONDecoder().decode([ReceiptDate].self, from: savedData){
                receiptDate = saveLists
            }
        }
        print("load 됨")
        print("*******************************")
        
        for item in receiptDate {
            print("날짜: \(item.date)")
            for index in item.items{
                print(index.korName)
            }
        }

    }

    // MARK: 현재 날짜 출력
    func formatDateToYYYYMDHHMM(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        return formatter.string(from: date)
    }
    // MARK: 현재 날짜 출력
    func formatDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    // MARK: 현재 시간 출력
    func formatDateToHHMM(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: date)
        return formattedTime
    }
    
    func formatDateToDate(from date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return calendar.date(from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day
        ))
    }

    // MARK: 총 금액 계산
    func korTotalPricing(from items: [CartItem]) -> Int {
        var total = 0
        for index in items.indices {
            total += items[index].korUnitPrice * items[index].quantity
        }
        return total
    }
    
    func frcTotalPricing(from items: [CartItem]) -> Double {
        var total: Double = 0.0
        for index in items.indices {
            total += items[index].frcUnitPrice * Double(items[index].quantity)
        }
        return total
    }
    
}


