//
//  Const.swift
//  PennyPack
//
//  Created by 임이지 on 11/4/24.
//

import Foundation

struct Constants {
    static let apiKey: String = {
        let key = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String
        print("plist에서 가져온 API 키: \(String(describing: key))")
        guard let apiKey = key else {
            fatalError("API Key not found in xcconfig")
        }
        return apiKey
    }()
}
