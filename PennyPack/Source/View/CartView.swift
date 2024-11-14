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
    @State private var recognizedText = ""
    
    
    @State private var isAlert = false
    @State private var isFinish = false
    @State private var isPlus = false
    @State private var isDropdownExpanded = false
    
    @State private var isScan: Bool = false
    
    @State private var totalPriceWon: Int = 0
    @State private var totalPriceEuro: Double = 0.0
    @State private var editingItemID: UUID? = nil // 현재 편집 중인 항목의 ID
    @FocusState private var focusedField: Field? // 포커스 상태 관리
    
    enum Field: Hashable {
        case korName, quantity, frcUnitPrice, frcName, korUnitPrice // 필드 식별
    }
    
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
                            Text("\(totalPriceWon) 원")
                                .font(.PTitle3)
                                .foregroundColor(.pGray)
                            Text("\(String(format: "%.2f", totalPriceEuro)) €")
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
                            
                            Button(action: {
                                isDropdownExpanded.toggle()
                            }) {
                                HStack{
                                    Text("오늘의 장보기 리스트")
                                        .font(.PTitle2)
                                        .foregroundColor(.pBlack)
                                    Spacer()
                                    Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down")
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
                                        }
                                        else {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.pWhite)
                                                .stroke(Color.pGray, lineWidth: 2)
                                        }
                                    }
                                )
                            }
                            .padding(.horizontal)
                            
                            if isDropdownExpanded {
                                ZStack{
                                    Color.pLightGray
                                        .clipShape(RoundedCorner(radius: 8, corners: [.bottomLeft, .bottomRight]))
                                        .padding(.horizontal)
                                    DropdownListView(listViewModel: listViewModel)
                                        .padding()
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
                            VStack(spacing: 0){
                                
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
                                    CartListView
                                        .padding(.horizontal)
                                    
                                    
                                }
                            }.overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.pGray, lineWidth: 2)
                                    .padding(.horizontal)
                                    .ignoresSafeArea()
                            )
                            
                        }
                    }
                }
                HStack{
                    Spacer()
                    VStack(spacing: 8){
                        Spacer()
                        if isPlus {
                            Button{
                                let newItem = shoppingViewModel.addNewShoppingItem(korName: "", frcName: "", quantity: 1, korUnitPrice: 1000, frcUnitPrice: 1)
                                
                                editingItemID = newItem.id
                                isPlus.toggle()
                            } label: {
                                ZStack{
                                    Circle()
                                        .frame(width: 40)
                                        .foregroundColor(.pDarkGray)
                                    Text("Aa")
                                        .foregroundColor(.white)
                                }
                            }.background()
                            
                            Button {
                                isScan.toggle()
                                isPlus.toggle()
                            } label: {
                                ZStack{
                                    Circle()
                                        .frame(width: 40)
                                        .foregroundColor(.pDarkGray)
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                }
                            }
                            
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
            .onChange(of: shoppingViewModel.shoppingItem) { _ in
                pricing()
            }
            .onAppear {
                pricing()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        shoppingViewModel.shoppingItem = []
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
                    
                    let dateItem = DateItem(date: Date(), items: shoppingViewModel.shoppingItem, korTotal: totalPriceWon, frcTotal: totalPriceEuro, place: "프랑스마트")
                    
                    shoppingViewModel.dateItem.append(dateItem)
                    shoppingViewModel.shoppingItem = []
                    
                    shoppingViewModel.saveShoppingListToUserDefaults()
                    listViewModel.saveShoppingListToUserDefaults()
                    
                }),
                      secondaryButton: .cancel(Text("돌아가기")))
            }
            
            
            NavigationLink(destination: ResultView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel)) {
                
                NavigationLink(destination: ResultView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel), isActive: $isFinish) {
                    
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden()
            
            NavigationLink(destination: ScanView(shoppingViewModel: shoppingViewModel), isActive: $isScan) {
                EmptyView()
            }
        }
    }
    
    func pricing() {
        totalPriceWon = shoppingViewModel.korTotalPricing(from: shoppingViewModel.shoppingItem)
        totalPriceEuro = shoppingViewModel.frcTotalPricing(from: shoppingViewModel.shoppingItem)
        
        print(totalPriceWon,"원")
        print(String(format: "%.2f", totalPriceEuro),"€")
    }
    
    private var CartListView: some View {
        List{
            ForEach(Array(shoppingViewModel.shoppingItem.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 0){
                    if editingItemID == item.id {
                        HStack(spacing: 0){
                            TextField("상품명", text: Binding(
                                get: { item.korName },
                                set: { newValue in
                                    shoppingViewModel.shoppingItem[index].korName = newValue
                                }
                            ))
                            .font(.PTitle3)
                            .frame(width: 180, alignment: .leading)
                            .focused($focusedField, equals: .korName) // 포커스 상태 관리
                            .onSubmit {
                                focusedField = .quantity
                            }
                            .onAppear (perform : UIApplication.shared.hideKeyboard)
                            
                            HStack(spacing: 0){
                                TextField("1", text: Binding(
                                    get: { String(item.quantity) },
                                    set: { newValue in
                                        if let intValue = Int(newValue) {
                                            shoppingViewModel.shoppingItem[index].quantity = intValue
                                        }
                                    }
                                ))
                                .font(.PBody)
                                .multilineTextAlignment(.trailing)
                                .focused($focusedField, equals: .quantity)
                                .onSubmit {
                                    focusedField = .frcUnitPrice
                                }
                                Text("개")
                                    .font(.PBody)
                            }
                            .frame(width: 30, alignment: .trailing)
                            
                            HStack(spacing: 0){
                                TextField("0.00", text: Binding(
                                    get: { String(format: "%.2f", item.frcUnitPrice)},
                                    set: { newValue in
                                        if let intValue = Double(newValue) {
                                            shoppingViewModel.shoppingItem[index].frcUnitPrice = intValue.rounded(toPlaces: 2)
                                        }
                                    }
                                ))
                                .font(.PTitle3)
                                .multilineTextAlignment(.trailing)
                                .focused($focusedField, equals: .frcUnitPrice)
                                .onSubmit {
                                    focusedField = .frcName
                                }
                                .onAppear (perform : UIApplication.shared.hideKeyboard)
                                Text(" €")
                                    .font(.PTitle3)
                            }
                            .frame(width: 120, alignment: .trailing)
                        }
                        HStack{
                            TextField("프랑스 이름", text: Binding(
                                get: { item.frcName },
                                set: { newValue in
                                    shoppingViewModel.shoppingItem[index].frcName = newValue
                                }
                            ))
                            .font(.PBody)
                            .frame(width: 180, alignment: .leading)
                            .focused($focusedField, equals: .frcName)
                            .onSubmit {
                                focusedField = .korUnitPrice
                            }
                            .onAppear (perform : UIApplication.shared.hideKeyboard)
                            Spacer()
                            
                            HStack(spacing: 0){
                                TextField("0", text: Binding(
                                    get: { String(item.korUnitPrice) },
                                    set: { newValue in
                                        if let intValue = Int(newValue){
                                            shoppingViewModel.shoppingItem[index].korUnitPrice = intValue
                                        }
                                    }
                                ))
                                .font(.PBody)
                                .multilineTextAlignment(.trailing)
                                .focused($focusedField, equals: .korUnitPrice)
                                .onSubmit {
                                    focusedField = nil
                                }
                                .onAppear (perform : UIApplication.shared.hideKeyboard)
                                Text(" 원")
                                    .font(.PBody)
                            }
                            .frame(width: 120, alignment: .trailing)
                        }
                    }
                    else {
                        HStack(spacing: 0){
                            Text("\(item.korName)")
                                .font(.PTitle3)
                                .frame(width: 180, alignment: .leading)
                            Text("\(item.quantity)개")
                                .font(.PBody)
                                .frame(width: 26, alignment: .trailing)
                            Text("\(String(format: "%.2f", item.frcUnitPrice)) €")
                                .font(.PTitle3)
                                .frame(width: 120, alignment: .trailing)
                        }
                        HStack{
                            Text(item.frcName)
                                .font(.PBody)
                                .frame(width: 180, alignment: .leading)
                            Spacer()
                            Text("\(Int(item.frcUnitPrice)*1490) 원")
                                .font(.PBody)
                                .frame(width: 120, alignment: .trailing)
                        }
                    }
                }.listRowBackground(
                    index == 0 ?
                    AnyView(
                        Rectangle()
                            .foregroundColor(.white)
                            .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                    ) :
                        AnyView(Color.clear)
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
    }
}

    
#Preview {
    CartView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func asString(withDecimalPlaces places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}
