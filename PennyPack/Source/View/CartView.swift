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
                Color.rBlack
                    .ignoresSafeArea()
                VStack{
                    HStack(alignment: .bottom){
                        Text("합산 가격")
                            .font(.title2)
                            .foregroundColor(.white)
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("45,000 원")
                                .font(.headline)
                                .foregroundColor(.rStrokeGray)
                            Text("30.00 €")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top,20)
                    ZStack{
                        Color.rBackgroundGray
                            .ignoresSafeArea()
                        VStack(spacing: 0){
                            HStack{
                                Spacer()
                                Text("€ 1 = ₩ 1499.62 (EUR/KRW)")
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            
                            // 드롭다운 토글 버튼
                            Button(action: {
                                isDropdownExpanded.toggle() // 드롭다운 열림/닫힘 제어
                            }) {
                                HStack {
                                    Text("오늘의 장보기 리스트" )
                                    Spacer()
                                    Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down") // 커스텀 아이콘
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(
                                    Group {
                                        if isDropdownExpanded {
                                            Rectangle()
                                                .fill(Color.white)
                                                .clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .topRight]))
                                        } else {
                                            Rectangle()
                                                .fill(Color.white)
                                                .cornerRadius(12)
                                        }
                                    }
                                )
                            }
                            .padding(.horizontal)

                            // 드롭다운 내용
                            if isDropdownExpanded {
                                DropdownView(listViewModel: listViewModel)
                            }
                            
                            HStack{
                                Text("장바구니에는 무엇이 있을까?")
                                Spacer()
                            }.padding(.horizontal)
                                .padding(.vertical, 20)
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
                                        .foregroundColor(.gray)
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
                                            .foregroundColor(.gray)
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
                                    .foregroundColor(.rMainBlue)
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }.padding(.horizontal,30)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.rMainBlue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAlert = true
                    }) {
                        Text("종료")
                            .foregroundColor(.rMainBlue)
                        
                    }
                }
            }
            .alert(isPresented: $isAlert){
                Alert(title: Text("장보기를 종료하시겠습니까?"),
                      message: Text("다시는 이 화면으로 돌아오지 못합니다."),
                      primaryButton: .destructive(Text("종료하기"), action: {
                    isFinish=true
                    
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
        .navigationTitle("장보기")
    }
    
}

#Preview {
    CartView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
}

