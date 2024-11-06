//
//  TranslatorView.swift
//  PennyPack
//
//  Created by 임이지 on 11/4/24.
//

import Foundation

class TranslationSerivce: ObservableObject {
    @Published var translatedText: String = "번역 결과가 여기에 표시됩니다."
    var shoppingViewModel : ShoppingViewModel

        init(shoppingViewModel: ShoppingViewModel) {
            self.shoppingViewModel = shoppingViewModel
        }
    
    func translateText(text: String) {
        let apiKey = "d6e694c4-255d-49ba-b214-06d295fcdd29:fx"
        let urlString = "https://api-free.deepl.com/v2/translate?auth_key=\(apiKey)&text=\(text)&target_lang=KO&source_lang=FR"
        
        // URL 인코딩
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
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
                    // JSON 데이터 파싱
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let translations = json["translations"] as? [[String: Any]],
                       let translatedText = translations.first?["text"] as? String {
                        let testData = TestModel(testText: translatedText)
                        
                        self.shoppingViewModel.testModel.append(testData)
                        DispatchQueue.main.async {
                            self.translatedText = translatedText // 번역 결과 저장
                            
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
