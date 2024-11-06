//
//  ListModel.swift
//  PennyPack
//
//  Created by siye on 11/6/24.
//

import Foundation

struct LinkList: Identifiable {
    var id: UUID = UUID()
    var title: String
    
}
class LinkListStore: ObservableObject {
    @Published var linkLists: [LinkList] = []
    
//    init() {
//        if linkLists.isEmpty {
//            self.linkLists = [
//                LinkList(title: "네이버"),
//                LinkList(title: "구글"),
//                LinkList(title: "유튜브")
//            ]
//        }
//    }
    
    // 리스트에 새 값 추가 함수
    func addLinkList(title: String) {
        let linkList: LinkList = LinkList(title: title)
        linkLists.append(linkList)
    }
}
