//
//  APIKeyFetch.swift
//  PennyPack
//
//  Created by 임이지 on 11/4/24.
//

import SwiftUI

struct ApiView: View {
    @State private var apiKey: String = "API 키를 찾을 수 없습니다."
    
    var body: some View {
        VStack {
            Text(apiKey) // API 키를 출력하는 텍스트
                .padding()
            
            Button("API 키 확인하기") {
                fetchAPIKey() // 버튼 클릭 시 API 키 확인
            }
            .padding()
        }
        .onAppear {
            fetchAPIKey() // 뷰가 나타날 때 API 키 확인
        }
    }
    
    func fetchAPIKey() {
        if let key = Bundle.main.object(forInfoDictionaryKey: "currency_APIKey") as? String {
            apiKey = key // API 키가 성공적으로 가져와지면 상태 업데이트
        } else {
            apiKey = "API 키를 찾을 수 없습니다." // 실패 시 메시지 업데이트
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ApiView()
    }
}
