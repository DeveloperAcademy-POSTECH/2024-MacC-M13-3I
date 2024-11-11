//
//  CartView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import Foundation
import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    @State var shoppingItems: [ShoppingItem] = []
    
    
    @State private var isAlert = false
    @State private var isFinish = false
    @State private var isPlus = false
    @State private var isDropdownExpanded = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.pBlack
                    .ignoresSafeArea()
                VStack(spacing: 0){
                    HStack(alignment: .bottom){
                        Text("장바구니 합계")
                            .font(.PTitle2)
                            .foregroundColor(.pWhite)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0){
                            Text("\(shoppingViewModel.dateItem.last?.korTotal ?? 61500) 원")
                                .font(.PTitle3)
                                .foregroundColor(.pGray)
                            Text("\(shoppingViewModel.dateItem.last?.frcTotal ?? 59) €")
                                .font(.PTitle1)
                                .foregroundColor(.pWhite)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom,12)
                    .padding(.top, 24)
                    
                    ZStack{
                        Color.pBackground
                            .ignoresSafeArea()
                        VStack(spacing: 0){
                            HStack(spacing: 0){
                                Spacer()
                                Text("€ 1 = ₩ 1499.62")
                                    .font(.PSubhead)
                                    .foregroundColor(.pDarkGray)
                                    .padding(.trailing,4)
                                Text("(EUR/KRW)")
                                    .font(.PFootnote)
                                    .foregroundColor(.pDarkGray)
                            }.padding(.horizontal)
                                .padding(.top)
                                .padding(.bottom, 12)
                            
                            // 드롭다운 토글 버튼
                            Button(action: {
                                isDropdownExpanded.toggle() // 드롭다운 열림/닫힘 제어
                            }) {
                                HStack{
                                    Text("오늘의 장보기 리스트")
                                        .font(.PTitle2)
                                        .foregroundColor(.pBlack)
                                    Spacer()
                                    Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down") // 커스텀 아이콘
                                }
                                .foregroundColor(.pBlack)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(
                                    Group {
                                        if isDropdownExpanded {
                                            Rectangle()
                                                .fill(Color.pWhite)
                                                .clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .topRight]))
                                        } else {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.pWhite)
                                                .stroke(Color.pGray, lineWidth: 2)
                                        }
                                    }
                                )
                            }
                            .padding(.horizontal)
                            
                            // 드롭다운 내용
                            if isDropdownExpanded {
                                ZStack{
                                    Color.pLightGray
                                        .clipShape(RoundedCorner(radius: 8, corners: [.bottomLeft, .bottomRight]))
                                        .padding(.horizontal)
                                    DropdownListView(listViewModel: listViewModel)
                                        .padding(.horizontal)
                                }
                                .frame(height: 156)
                            }
                            
                            HStack{
                                Text("장바구니에는 무엇이 있을까?")
                                    .font(.PTitle2)
                                    .foregroundColor(.pBlack)
                                Spacer()
                            }.padding(.horizontal)
                                .padding(.top, 24)
                                .padding(.bottom,4)
                            if shoppingViewModel.shoppingItem.isEmpty {
                                ZStack(alignment: .top){
                                    Color.pWhite
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                        .ignoresSafeArea()
                                    VStack{
                                        Text("버튼을 눌러")
                                        Text("카트에 담긴 물건을 입력해주세요.")
                                    }.font(.PTitle3)
                                        .foregroundColor(.pDarkGray)
                                    .padding(.top,80)
                                }
                                
                            }
                            else{
                                List{
                                    ForEach(Array(shoppingViewModel.shoppingItem.enumerated()), id: \.element.id) { index, item in
                                        VStack{
                                            HStack{
                                                Text("\(item.korName)")
                                                Spacer()
                                                Text("\(item.quantity)개")
                                                Spacer()
                                                Text("\(item.frcUnitPrice) €")
                                            }
                                            HStack{
                                                Text("\(item.frcName)")
                                                Spacer()
                                                Text("\(item.korUnitPrice) 원")
                                            }
                                        }
                                        .listRowBackground(
                                            index == 0 ?
                                            AnyView(
                                                Rectangle()
                                                    .foregroundColor(.white)
                                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                                            ) :
                                                AnyView(Color.clear) // 나머지 항목은 배경 없음 또는 기본 배경
                                        )
                                    }
                                    .onDelete(perform: shoppingViewModel.removeList)
                                }
                                .listStyle(PlainListStyle())
                                .background(
                                    Color.white
                                        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                                        .ignoresSafeArea()
                                )
                                .padding(.horizontal)
                                
                                
                            }
                        }
                    }
                }
                HStack{
                    Spacer()
                    VStack(spacing: 8){
                        Spacer()
                        if isPlus {
                            Button{
                                
                            } label: {
                                ZStack{
                                    Circle()
                                        .frame(width: 40)
                                        .foregroundColor(.pDarkGray)
                                    Text("Aa")
                                        .foregroundColor(.white)
                                }
                            }.background()
                            NavigationLink(
                                destination: ScanView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel),
                                label: {
                                    ZStack{
                                        Circle()
                                            .frame(width: 40)
                                            .foregroundColor(.pDarkGray)
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                    }
                                })
                        }
                        Button{
                            isPlus.toggle()
                        } label: {
                            ZStack{
                                Circle()
                                    .frame(width: 50)
                                    .foregroundColor(.pBlue)
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }.padding(.horizontal,30)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.pBlue)
                    }
                }
                ToolbarItem(placement: .principal){
                    Text("장보기")
                        .font(.PTitle2)
                        .foregroundColor(.pWhite)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAlert = true
                    }) {
                        Text("종료")
                            .foregroundColor(.pBlue)
                        
                    }
                }
            }
            .alert(isPresented: $isAlert){
                Alert(title: Text("장보기를 종료하시겠습니까?"),
                      message: Text("다시는 이 화면으로 돌아오지 못합니다."),
                      primaryButton: .destructive(Text("종료하기"), action: {
                    isFinish=true
                    
                    for index in listViewModel.shoppingList.indices {
                        listViewModel.shoppingList[index].isPurchase = listViewModel.shoppingList[index].isChoise
                    }
                    
                    let korTotalPrice = shoppingViewModel.korTotalPricing(from: shoppingViewModel.shoppingItem)
                    
                    let frcTotalPrice = shoppingViewModel.frcTotalPricing(from: shoppingViewModel.shoppingItem)
                    
                    let dateItem = DateItem(date: Date(), items: shoppingViewModel.shoppingItem, korTotal: korTotalPrice, frcTotal: frcTotalPrice, place: "프랑스마트")
                    
                    shoppingViewModel.dateItem.append(dateItem)
                    
                    shoppingViewModel.saveShoppingListToUserDefaults()
                    listViewModel.saveShoppingListToUserDefaults()
                    
                }),
                      secondaryButton: .cancel(Text("돌아가기")))
            }
            NavigationLink(destination: ResultView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel), isActive: $isFinish) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    CartView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
}

