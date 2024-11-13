import Foundation

// MARK: UserDefaults 데이터모델

struct DateItem: Codable, Hashable {
    var date: Date
    var items: [ShoppingItem]
    var korTotal: Int //총 금액
    var frcTotal: Double
    var place: String
}

struct ShoppingItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var korName: String
    var frcName: String
    var quantity: Int
    var korUnitPrice: Int //단가
    var frcUnitPrice: Double //단가
//    var frcUnitString: String {
//        return String(format: "%.2f", frcUnitPrice)
//    }
    var korPrice: Int //수량*단가
    var frcPrice: Double //수량*단가
    var time: Date
}

class ShoppingViewModel:ObservableObject {
    @Published var dateItem: [DateItem] = []
    @Published var shoppingItem: [ShoppingItem] = []
    @Published var selectedDateItem: DateItem?
    
    @Published var nowBudget: Int? // 예산
    @Published var nowPlace: String = ""
    
    init(){
        if shoppingItem.isEmpty {
            if let customDate = Calendar.current.date(byAdding: .day, value: -10, to: Date()) {
                self.shoppingItem = [
                    ShoppingItem(korName: "테1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
                    ShoppingItem(korName: "테스2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
                    ShoppingItem(korName: "테스트1테스트1테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date())
                ]
            }
        }

//        if shoppingItem.isEmpty {
//            if let customDate = Calendar.current.date(byAdding: .day, value: -10, to: Date()) {
//                self.shoppingItem = [
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date()),
//                    ShoppingItem(korName: "테스트1", frcName: "test1", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 1000, frcPrice: 100, time: customDate),
//                    ShoppingItem(korName: "테스트2", frcName: "test2", quantity: 2, korUnitPrice: 1000, frcUnitPrice: 100, korPrice: 2000, frcPrice: 200, time: Date())
//                ]
//            }
//        }
        
//        if dateItem.isEmpty {
//            self.dateItem = [
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소"),
//                DateItem(date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), items: shoppingItem, korTotal: 1, frcTotal: 1, place: "장소")
//
//            ]
//        }

        
        loadShoppingListFromUserDefaults()
    }
    // MARK: 리스트에 새 값 추가 함수
    func addNewShoppingItem(korName: String, frcName: String, quantity: Int, korUnitPrice: Int, frcUnitPrice: Double) -> ShoppingItem {
        let newShoppingItem: ShoppingItem = ShoppingItem(korName: korName, frcName: frcName, quantity: quantity, korUnitPrice: korUnitPrice, frcUnitPrice: frcUnitPrice, korPrice: quantity*korUnitPrice, frcPrice: Double(quantity*Int(frcUnitPrice)), time: Date())
        shoppingItem.append(newShoppingItem)
        return newShoppingItem
    }
    
    func removeList(at offsets: IndexSet) {
        shoppingItem.remove(atOffsets: offsets)
        print("Updated shoppingList: \(shoppingItem)")
    }
    
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dateItem) {
            UserDefaults.standard.set(encoded, forKey: "dateItem")
        }
        
        print("save 됨")
    }
    
    // MARK: UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "dateItem") {
            if let saveLists = try? JSONDecoder().decode([DateItem].self, from: savedData){
                dateItem = saveLists
            }
        }
        print("load 됨")
        print("*******************************")
        
        for item in dateItem {
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
    func korTotalPricing(from items: [ShoppingItem]) -> Int {
        var total = 0
        for index in items.indices {
            total += items[index].korPrice
        }
        return total
    }
    
    func frcTotalPricing(from items: [ShoppingItem]) -> Double {
        var total = 0
        for index in items.indices {
            total += Int(items[index].frcPrice)
        }
        return Double(total)
    }
    
}


