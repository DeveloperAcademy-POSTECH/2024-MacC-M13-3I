//
//  DataModel.swift
//  PennyPack
//
//  Created by siye on 1/3/25.
//

import Foundation

// MARK: UserDefaults 데이터모델

/// 영수증 날짜 [DateItem -> ReceiptDate 로 이름변경 완료]
struct ReceiptDate: Codable, Hashable {
    var date: Date
    var items: [CartItem]
    var korTotal: Int
    var frcTotal: Double
    var place: String
}

/// 카트아이템 [ShoppingItem -> CartItem 으로 이름변경 완료]
struct CartItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var korName: String
    var frcName: String
    var quantity: Int
    var korUnitPrice: Int
    var frcUnitPrice: Double
    var time: Date
}

//
/// 미리 적는 쇼핑리스트
struct ShoppingList: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var isChoise: Bool
    var isPurchase: Bool
}
