//
//  CurrencyService.swift
//  PennyPack
//
//  Created by 임이지 on 11/4/24.
//

import Foundation

struct Currency: Codable {
    let result: Int
    let cur_unit: String
    let deal_bas_r: String
    let cur_nm: String
}

class CurrencyService: ObservableObject {
    @Published var currencyData: String = "정보를 불러오는 중..." // 초기 상태
    
    func fetchCurrencyData() {
        
        let apiKey = ""
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd" // "YYYYMMDD" 형식
        let todayDate = dateFormatter.string(from: Date()) // 오늘 날짜를 문자열로 변환
        
        let urlString = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(apiKey)&searchdate=20241104&data=AP01"
        guard let url = URL(string: urlString) else {
            print("잘못된 URL입니다.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("에러 발생: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let currencies = try JSONDecoder().decode([Currency].self, from: data)
                    if let franceCurrency = currencies.first(where: { $0.cur_nm == "유로"}) {
                        DispatchQueue.main.async {
                            self.currencyData = franceCurrency.deal_bas_r
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.currencyData = "프랑스 통화 정보를 찾을 수 없습니다"
                        }
                    }
                } catch {
                    print("JSON 파싱 에러: \(error)")
                }
                
            }
        }
        task.resume()
    }
}
