//
//  CurrencyService.swift
//  PennyPack
//
//  Created by 임이지 on 11/4/24.
//

import Foundation

struct Currency: Codable, Identifiable, Equatable {
    var id: String { cur_unit }  // `cur_unit`을 고유 ID로 사용
    let result: Int
    let cur_unit: String
    let deal_bas_r: String
    let cur_nm: String
}

enum CurrencyType: String, CaseIterable, Identifiable {
    case usd = "미국"
    case eur = "유로"
    case gbp = "영국"
    case jpy = "일본"
    
    var id: String { rawValue }
    
    var cur_unit: String {
        switch self {
        case .usd: return "USD"
        case .eur: return "EUR"
        case .gbp: return "GBP"
        case .jpy: return "JPY"
        }
    }
    
    // 환율 등의 추가 정보를 설정할 수 있습니다.
}


class CurrencyService: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var selectedRate: Double? = nil
    @Published var currencyData: String = "정보를 불러오는 중..." // 초기 상태 문자열
    
    func fetchCurrencies() {
        let apiKey = "Io8cUPkoj2z2gELlTeFzNW2uYfEyBTwm"
        
        let businessDate = getBusinessDate()  // 영업일 날짜 계산 함수 호출
            
        let urlString = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(apiKey)&searchdate=\(businessDate)&data=AP01"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([Currency].self, from: data)
                DispatchQueue.main.async {
                    self.currencies = decoded
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }
        task.resume()
    }
    
    func getRate(for name: String) {
        guard let currency = currencies.first(where: { $0.cur_unit == name }) else {
                DispatchQueue.main.async {
                    self.currencyData = "Currency not found"
                }
                return
        }

        // 콤마를 제거하여 순수한 숫자 형태의 문자열을 생성
        let numericString = currency.deal_bas_r.replacingOccurrences(of: ",", with: "")

        // Double로 변환 시도
        if let rate = Double(numericString) {
            DispatchQueue.main.async {
                self.selectedRate = rate
                print("Loaded rate: \(rate)")
            }
        } else {
            DispatchQueue.main.async {
                print("Failed to convert rate to double: \(numericString)")
                self.currencyData = "Conversion error with rate: \(numericString)"
            }
        }
    }
}

func getBusinessDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let calendar = Calendar.current
    
    var date = Date()  // 기본적으로 오늘 날짜
    
    // 현재 시간이 오전 11시 이전인지 확인
    let currentHour = calendar.component(.hour, from: date)
    if currentHour < 11 {
        date = calendar.date(byAdding: .day, value: -1, to: date) ?? date // 전날로 설정
    }
    
    // 주말(토요일, 일요일) 처리
    var weekday = calendar.component(.weekday, from: date)
    while weekday == 1 || weekday == 7 {  // 일요일(1) 또는 토요일(7)일 경우
        date = calendar.date(byAdding: .day, value: -1, to: date) ?? date
        weekday = calendar.component(.weekday, from: date)  // 수정된 날짜의 요일 다시 확인
    }
    
    return dateFormatter.string(from: date)
}


extension CurrencyService {
    func filterCurrency(for name: String) -> Currency? {
        return currencies.first { $0.cur_unit == name }
    }
}
