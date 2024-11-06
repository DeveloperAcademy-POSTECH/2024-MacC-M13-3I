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
    @State var shoppingItems: [ShoppingItem] = []
    
    
    @State private var isAlert = false
    @State private var isFinish = false
    
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
                        VStack{
                            HStack{
                                Spacer()
                                Text("€ 1 = ₩ 1499.62 (EUR/KRW)")
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                HStack{
                                    Text("오늘의 장보기 리스트")
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }.padding()
                                    .padding(.horizontal)
                                    .background(.green)
                            })
                            List{
                                ForEach(shoppingViewModel.testModel, id: \.id){ item in
                                    VStack{
                                        Text("\(item.testText)")
                                    }
                                }
                            } .listStyle(PlainListStyle())
                                .padding(.horizontal)
                                .background(.rBackgroundGray)
                        }
                    }
                }
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
                }),
                      secondaryButton: .cancel(Text("돌아가기")))
            }
            
            NavigationLink(destination: ResultView(shoppingViewModel: shoppingViewModel), isActive: $isFinish) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("장보기")
    }
    
}

#Preview {
    CartView(shoppingViewModel: ShoppingViewModel())
}

