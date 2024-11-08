//
//  ResultView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

struct ResultView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    
    @State private var isMainViewActive: Bool = false
    
    @State var showSheet: Bool = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.pBlack
                    .ignoresSafeArea()
                VStack{
                    HStack(spacing: 0){
                        Text("새로운 여행지")
                            .foregroundColor(.pBlue)
                        Text("가")
                            .foregroundColor(.white)
                    }
                    .bold()
                    .font(.largeTitle)
                    Text("기다리고 있어요")
                        .foregroundColor(.white)
                        .bold()
                            .font(.largeTitle)
                    Text("다음 주는 조금 더 아껴볼까요?")
                        .foregroundColor(.white)
                    
                    Text("티끌 모아, 여행")
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showSheet) {
                ResultModalView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel, isButton: .constant(false))
                    .presentationDetents([.height(150.0), .height(700)])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isMainViewActive = true
                        
                        for index in listViewModel.shoppingList.indices {
                            listViewModel.shoppingList[index].isPurchase = listViewModel.shoppingList[index].isChoise
                        }
                        listViewModel.saveShoppingListToUserDefaults()
                    }) {
                        Text("닫기")
                            .foregroundColor(.pBlue)
                    }
                }
            }

            NavigationLink(destination: MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), isActive: $isMainViewActive) {
                EmptyView()
            }
            
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    ResultView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
}
