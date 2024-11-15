import Foundation

class TranslationSerivce: ObservableObject {
    @Published var translatedText: String = ""
    
    /// 10. 전달 받은 text를 번역해서 translatedText에 번역 정보 저장
    /// 가능하면 apiKey 숨기고, completion 부분 제거하기
    func translateText(text: String, completion: @escaping (String) -> Void) {
        let apiKey = "d6e694c4-255d-49ba-b214-06d295fcdd29:fx"
        let urlString = "https://api-free.deepl.com/v2/translate?auth_key=\(apiKey)&text=\(text)&target_lang=KO&source_lang=FR"
        
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("잘못된 URL입니다.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("에러 발생: \(error)")
                completion("")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let translations = json["translations"] as? [[String: Any]],
                       let translatedText = translations.first?["text"] as? String {
                        
                        DispatchQueue.main.async {
                            completion(translatedText)
                            self.translatedText = translatedText
                        }
                    }
                } catch {
                    print("JSON 파싱 에러: \(error)")
                    completion("")
                }
            }
        }
        task.resume()
    }
}
