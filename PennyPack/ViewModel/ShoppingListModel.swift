import Foundation

struct TestModel: Identifiable, Codable, Hashable {
    var id = UUID()
    var testText: String
}

// MARK: UserDefaults 데이터모델

struct DateItem: Codable, Hashable {
    var date: Date
    var items: [ShoppingItem]
    var total: Int //총 금액
    var place: String
}

struct ShoppingItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var korName: String
    var frcName: String
    var quantity: Int
    var korUnitPrice: Int //단가
    var frcUnitPrice: Int //단가
    var korPrice: Int //수량*단가
    var frcPrice: Int //수량*단가
    var time: Date
}

class ShoppingViewModel:ObservableObject {
    @Published var dateItem: [DateItem] = []
    @Published var shoppingItem: [ShoppingItem] = []
    @Published var selectedDateItem: DateItem?
    @Published var testModel: [TestModel] = []
    
    @Published var nowBudget: Int? // 예산
    @Published var nowPlace: String = ""
    
    init(){
        loadShoppingListFromUserDefaults()
        if shoppingItem.isEmpty {
            shoppingItem = [
                ShoppingItem(korName: "예시리스트1", frcName: "example1", quantity: 1, korUnitPrice: 1200, frcUnitPrice: 1, korPrice: 1200, frcPrice: 1, time: Date()),
                ShoppingItem(korName: "예시리스트2", frcName: "example2", quantity: 2, korUnitPrice: 1200, frcUnitPrice: 1, korPrice: 2400, frcPrice: 2, time: Date())
            ]
            saveShoppingListToUserDefaults()
        }
        
        if testModel.isEmpty {
            testModel = [
                TestModel(testText: "테스트텍스트1"),
                TestModel(testText: "테스트텍스트2"),
                TestModel(testText: "테스트텍스트3")
            ]
        }
    }
    
    // MARK: 데이터를 인코딩하고 UserDefaults에 저장
    func saveShoppingListToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dateItem) {
            UserDefaults.standard.set(encoded, forKey: "shoppingLists")
        }
//        print("*******************************")
//            for item in dateItem {
//                print("\(item.date): \(item.items)")
//            }
        
        print("save 됨")
    }
    
    // MARK: UserDefaults에서 데이터를 불러오기
    func loadShoppingListFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "shoppingLists") {
            if let saveLists = try? JSONDecoder().decode([DateItem].self, from: savedData){
                dateItem = saveLists
            }
        }
        print("load 됨")
    }

    // MARK: 현재 날짜에서 초만 삭제 (초를 0으로 설정)
    func removeSeconds(from date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.second = 0
        return calendar.date(from: components) ?? date
    }
    // MARK: 현재 날짜 출력
    func formatDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    // MARK: 현재 시간 출력
    func formatDateToHHMM(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: date)
        return formattedTime
    }
    
    // MARK: 총 금액 계산
    func totalPricing(from items: [ShoppingItem]) -> Int {
        var total = 0
        for index in items.indices {
            total += items[index].korPrice
        }

        if var lastDateItem = dateItem.last {
            lastDateItem.total = total
            if let lastIndex = dateItem.indices.last {
                dateItem[lastIndex] = lastDateItem
            }
        }
        return total
    }

    // MARK: 전체 쇼핑 항목에 대한 가격 계산
    func pricing(from items: [ShoppingItem]) {
        for index in shoppingItem.indices {
            shoppingItem[index].korPrice = shoppingItem[index].korUnitPrice * shoppingItem[index].quantity
        }

        if var lastDateItem = dateItem.last {
            lastDateItem.items = shoppingItem
            lastDateItem.total = shoppingItem.reduce(0) { $0 + $1.korPrice }
            if let lastIndex = dateItem.indices.last {
                dateItem[lastIndex] = lastDateItem
            }
        }
    }

    // MARK: 개별 쇼핑 항목에 대한 가격 계산
    func pricingItem(for item: inout ShoppingItem) {
        item.korPrice = item.korUnitPrice * item.quantity

        if let index = shoppingItem.firstIndex(where: { $0.id == item.id }) {
            shoppingItem[index] = item

            if var lastDateItem = dateItem.last {
                lastDateItem.items = shoppingItem
                lastDateItem.total = shoppingItem.reduce(0) { $0 + $1.korPrice }
                if let lastIndex = dateItem.indices.last {
                    dateItem[lastIndex] = lastDateItem
                }
            }
        }
    }
}


