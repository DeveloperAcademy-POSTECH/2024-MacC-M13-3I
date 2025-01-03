import Foundation
import SwiftUI

struct CartView: View {
    @EnvironmentObject var pathRouter: PathRouter
    @Environment(\.dismiss) var dismiss
    @StateObject private var cartViewModel = CartViewModel()
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    
    
//    @State private var recognizedText = ""
//    @State private var isAlert: Bool = false
//    @State private var isFinish: Bool = false
//    @State private var isPlus = false
//    @State private var isDropdownExpanded = false
//    @State private var isScan: Bool = false
//    @State var totalPriceWon: Int = 0
//    @State var totalPriceEuro: Double = 0.0
//    @State private var editingItemID: UUID? = nil
//    @FocusState private var focusedField: Field?
//    
    enum Field: Hashable {
        case korName, quantity, frcUnitPrice, frcName
    }
    
    var body: some View {
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
                        Text("\(cartViewModel.totalPriceWon) 원")
                            .font(.PTitle3)
                            .foregroundColor(.pGray)
                        Text("\(String(format: "%.2f", cartViewModel.totalPriceEuro)) €")
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
                            cartViewModel.isDropdownExpanded.toggle()
                        }) {
                            HStack{
                                Text("오늘의 장보기 리스트")
                                    .font(.PTitle2)
                                    .foregroundColor(.pBlack)
                                Spacer()
                                
                                Image(systemName: cartViewModel.isDropdownExpanded ? "chevron.up" : "chevron.down")
                            }
                            .foregroundColor(.pBlack)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(
                                Group {
                                    if cartViewModel.isDropdownExpanded {
                                        ZStack{
                                            Rectangle()
                                                .fill(Color.pWhite)
                                                .clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .topRight]))
                                                .overlay(
                                                    RoundedCorner(radius: 8, corners: [.topLeft, .topRight])
                                                        .stroke(Color.pGray, lineWidth: 2)
                                                )
                                        }
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
                        
                        if cartViewModel.isDropdownExpanded {
                            ZStack{
                                Color.pLightGray
                                    .clipShape(RoundedCorner(radius: 8, corners: [.bottomLeft, .bottomRight]))
                                    .padding(.horizontal)
                                DropdownListView(listViewModel: listViewModel)
                                    .padding()
                                RoundedCorner(radius: 8, corners: [.bottomLeft, .bottomRight])
                                    .stroke(Color.pGray, lineWidth: 2)
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
                        VStack(spacing: 0){
                            
                            if shoppingViewModel.cartItem.isEmpty {
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
//                            else{
//                                CartListView
//                                    .padding(.horizontal)
//
//                            }
                        }.overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.pGray, lineWidth: 2)
                                .padding(.horizontal)
                                .ignoresSafeArea()
                        )
                        
                    }
                }
            }
            ZStack{
                HStack {
                    Spacer()
                    VStack(spacing: 8){
                        Spacer()
                        if cartViewModel.isPlus {
                            Button{
                                let newItem = shoppingViewModel.addNewCartItem(korName: "", frcName: "", quantity: 1, korUnitPrice: 1490, frcUnitPrice: 1)
                                
                                cartViewModel.editingItemID = newItem.id
                                cartViewModel.isPlus.toggle()
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
                                cartViewModel.isScan.toggle()
                                cartViewModel.isPlus.toggle()
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
                        Button {
                            cartViewModel.isPlus.toggle()
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
                        
                    }.padding(.horizontal,30)
                }
                
                if cartViewModel.isAlert {
                    CustomAlertView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel, isAlertPresented: $cartViewModel.isAlert, isFinishPresented: $cartViewModel.isFinish, totalPriceWon: $cartViewModel.totalPriceWon, totalPriceEuro: $cartViewModel.totalPriceEuro)
                }
            }
            
            .onChange(of: shoppingViewModel.cartItem) { _ in
                pricing()
            }
            .onAppear {
                pricing()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        shoppingViewModel.cartItem = []
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
                        cartViewModel.isAlert = true
                        
                        for index in listViewModel.shoppingList.indices {
                            listViewModel.shoppingList[index].isPurchase = listViewModel.shoppingList[index].isChoise
                        }
                        
                        listViewModel.saveShoppingListToUserDefaults()
                    }) {
                        Text("종료")
                            .foregroundColor(.pBlue)
                        
                    }
                }
            }
        }
        .background(
            NavigationLink(destination: ResultView(), isActive: $cartViewModel.isFinish) {
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: ScanView(shoppingViewModel: shoppingViewModel), isActive: $cartViewModel.isScan) {
                EmptyView()
            }
        ).navigationBarBackButtonHidden()
    }
    
    func pricing() {
        cartViewModel.totalPriceWon = cartViewModel.korTotalPricing(from: shoppingViewModel.cartItem)
        cartViewModel.totalPriceEuro = cartViewModel.frcTotalPricing(from: shoppingViewModel.cartItem)
    }
    
//    private var CartListView: some View {
//        List{
//            ForEach(Array(shoppingViewModel.cartItem.enumerated()), id: \.element.id) { index, item in
//                VStack(spacing: 0){
//                    if cartViewModel.editingItemID == item.id {
//                        HStack(spacing: 0){
//                            TextField("상품명", text: Binding(
//                                get: { item.korName },
//                                set: { newValue in
//                                    shoppingViewModel.cartItem[index].korName = newValue
//                                }
//                            ))
//                            .font(.PTitle3)
//                            .frame(width: 180, alignment: .leading)
//                            .focused($cartViewModel.focusedField, equals: .korName)
//                            .onSubmit {
//                                cartViewModel.focusedField = .quantity
//                            }
//                            .hideKeyboard()
//                            
//                            HStack(spacing: 0){
//                                TextField("1", text: Binding(
//                                    get: { String(item.quantity) },
//                                    set: { newValue in
//                                        if let intValue = Int(newValue) {
//                                            shoppingViewModel.cartItem[index].quantity = intValue
//                                        }
//                                    }
//                                ))
//                                .font(.PBody)
//                                .multilineTextAlignment(.trailing)
//                                .focused($cartViewModel.focusedField, equals: .quantity)
//                                .onSubmit {
//                                    cartViewModel.focusedField = .frcUnitPrice
//                                }
//                                Text("개")
//                                    .font(.PBody)
//                            }
//                            .frame(width: 40, alignment: .trailing)
//                            
//                            HStack(spacing: 0){
//                                TextField("0.00", text: Binding(
//                                    get: { String(format: "%.2f", item.frcUnitPrice)},
//                                    set: { newValue in
//                                        if let intValue = Double(newValue) {
//                                            shoppingViewModel.cartItem[index].frcUnitPrice = intValue.rounded(toPlaces: 2)
//                                        }
//                                    }
//                                ))
//                                .font(.PTitle3)
//                                .multilineTextAlignment(.trailing)
//                                .focused($cartViewModel.focusedField, equals: .frcUnitPrice)
//                                .onChange(of: item.frcUnitPrice) { newValue in
//                                    shoppingViewModel.cartItem[index].korUnitPrice = Int(newValue * 1490)
//                                }
//                                .onSubmit {
//                                    cartViewModel.focusedField = .frcName
//                                }
//                                .hideKeyboard()
//                                Text(" €")
//                                    .font(.PTitle3)
//                            }
//                            .frame(width: 110, alignment: .trailing)
//                        }
//                        HStack{
//                            TextField("프랑스 이름", text: Binding(
//                                get: { item.frcName },
//                                set: { newValue in
//                                    shoppingViewModel.cartItem[index].frcName = newValue
//                                }
//                            ))
//                            .font(.PBody)
//                            .frame(width: 180, alignment: .leading)
//                            .focused($cartViewModel.focusedField, equals: .frcName)
//                            .onSubmit {
//                                cartViewModel.focusedField = nil
//                                cartViewModel.editingItemID = nil
//                            }
//                            .hideKeyboard()
//                            Spacer()
//                            
//                            Text("\(Int(item.frcUnitPrice)*1490) 원")
//                                .font(.PBody)
//                                .frame(width: 120, alignment: .trailing)
//                        }
//                    }
//                    else {
//                        HStack(spacing: 0){
//                            Text("\(item.korName)")
//                                .font(.PTitle3)
//                                .frame(width: 180, alignment: .leading)
//                            Text("\(item.quantity)개")
//                                .font(.PBody)
//                                .frame(width: 40, alignment: .trailing)
//                            Text("\(String(format: "%.2f", item.frcUnitPrice)) €")
//                                .font(.PTitle3)
//                                .frame(width: 110, alignment: .trailing)
//                        }
//                        HStack{
//                            Text(item.frcName)
//                                .font(.PBody)
//                                .frame(width: 180, alignment: .leading)
//                            Spacer()
//                            Text("\(Int(item.frcUnitPrice)*1490) 원")
//                                .font(.PBody)
//                                .frame(width: 120, alignment: .trailing)
//                        }
//                    }
//                }.listRowBackground(
//                    index == 0 ?
//                    AnyView(
//                        Rectangle()
//                            .foregroundColor(.white)
//                            .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
//                    ) :
//                        AnyView(Color.clear)
//                )
//            }
//            .onDelete(perform: shoppingViewModel.removeList)
//        }
//        .listStyle(PlainListStyle())
//        .background(
//            Color.white
//                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
//                .ignoresSafeArea()
//        )
//    }
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

