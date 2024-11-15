//import Foundation
//
//struct Currency: Codable, Identifiable, Equatable {
//    var id: String { cur_unit }
//    let result: Int
//    let cur_unit: String
//    let deal_bas_r: String
//    let cur_nm: String
//}
//
//enum CurrencyType: String, CaseIterable, Identifiable {
//    case usd = "미국"
//    case eur = "유로"
//    case gbp = "영국"
//    case jpy = "일본"
//    
//    var id: String { rawValue }
//    
//    var cur_unit: String {
//        switch self {
//        case .usd: return "USD"
//        case .eur: return "EUR"
//        case .gbp: return "GBP"
//        case .jpy: return "JPY"
//        }
//    }
//}
//
//
//class CurrencyService: ObservableObject {
//    @Published var currencies: [Currency] = []
//    @Published var selectedRate: Double? = nil
//    @Published var currencyData: String = "정보를 불러오는 중..."
//    
//    func fetchCurrencies() {
//        let apiKey = "Io8cUPkoj2z2gELlTeFzNW2uYfEyBTwm"
//        
//        let businessDate = getBusinessDate()
//        let urlString = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(apiKey)&searchdate=\(businessDate)&data=AP01"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error fetching data: \(error)")
//                return
//            }
//            
//            guard let data = data else {
//                print("No data")
//                return
//            }
//            
//            do {
//                let decoded = try JSONDecoder().decode([Currency].self, from: data)
//                DispatchQueue.main.async {
//                    self.currencies = decoded
//                }
//            } catch {
//                print("JSON decoding error: \(error)")
//            }
//        }
//        task.resume()
//    }
//    
//    func getRate(for name: String) {
//        guard let currency = currencies.first(where: { $0.cur_unit == name }) else {
//                DispatchQueue.main.async {
//                    self.currencyData = "Currency not found"
//                }
//                return
//        }
//
//        let numericString = currency.deal_bas_r.replacingOccurrences(of: ",", with: "")
//
//        if let rate = Double(numericString) {
//            DispatchQueue.main.async {
//                self.selectedRate = rate
//                print("Loaded rate: \(rate)")
//            }
//        } else {
//            DispatchQueue.main.async {
//                print("Failed to convert rate to double: \(numericString)")
//                self.currencyData = "Conversion error with rate: \(numericString)"
//            }
//        }
//    }
//}
//
//func getBusinessDate() -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyyMMdd"
//    let calendar = Calendar.current
//    
//    var date = Date()
//    let currentHour = calendar.component(.hour, from: date)
//    if currentHour < 11 {
//        date = calendar.date(byAdding: .day, value: -1, to: date) ?? date
//    }
//    var weekday = calendar.component(.weekday, from: date)
//    while weekday == 1 || weekday == 7 {
//        date = calendar.date(byAdding: .day, value: -1, to: date) ?? date
//        weekday = calendar.component(.weekday, from: date)
//    }
//    
//    return dateFormatter.string(from: date)
//}
//
//
//extension CurrencyService {
//    func filterCurrency(for name: String) -> Currency? {
//        return currencies.first { $0.cur_unit == name }
//    }
//}
