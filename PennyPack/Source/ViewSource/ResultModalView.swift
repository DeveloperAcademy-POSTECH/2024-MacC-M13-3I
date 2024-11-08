import SwiftUI


struct ResultModalView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    @State private var isMainViewActive = false
    @Binding var isButton: Bool
    
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading) {
                HStack {
                    Text(shoppingViewModel.formatDateToYYYYMDHHMM(from: shoppingViewModel.dateItem.last?.date ?? Date()))
                        .font(.PTitle2)
                    Spacer()
                }
                .padding(.bottom, 4)
                HStack {
                    Text("오늘의 영수증")
                        .font(.PTitle1)
                    Spacer()
                }
                .padding(.bottom,8)
                Divider()
                    .frame(height: 1)
                    .background(.pBlack)
                    .padding(.bottom,8)
                
                HStack {
                    Spacer()
                    Text("€ 1 = ₩ 1499.62 (EUR/KRW)")
                        .font(.PBody)
                }
                .padding(.bottom, 12)
                
                    VStack(alignment:.center) {
                        VStack(alignment: .center) {
                            HStack(spacing: 0) {
                                Text("품목")
                                    .font(.PSubhead)
                                    .frame(width: 118, alignment: .leading)
                                Text("단가")
                                    .font(.PSubhead)
                                    .frame(width: 67, alignment: .trailing)
                                Text("수량")
                                    .font(.PSubhead)
                                    .frame(width: 44, alignment: .trailing)
                                Text("합계")
                                    .font(.PSubhead)
                                    .frame(width: 57, alignment: .trailing)
                            }
                            .padding(.bottom, 20)
                            ScrollView{
                                if let items = shoppingViewModel.dateItem.last?.items {
                                    LazyVGrid(columns: [
                                        GridItem(.fixed(118)),
                                        GridItem(.fixed(24)),
                                        GridItem(.fixed(67)),
                                        GridItem(.fixed(57))
                                    ])
                                    {
                                        ForEach(items) { item in
                                            Text(item.korName)
                                                .font(.PSubhead)
                                                .frame(width: 118, alignment: .leading)
                                                .padding(.bottom, 8)
                                        Text("\(item.frcUnitPrice)")
                                            .font(.PSubhead)
                                            .frame(width: 24, alignment: .trailing)
                                            .padding(.bottom, 8)
                                            Text("\(item.quantity)")
                                                .font(.PSubhead)
                                                .frame(width: 67, alignment: .trailing)
                                                .padding(.bottom, 8)
                                            Text("\(item.frcPrice)")
                                                .font(.PSubhead)
                                                .frame(width: 57, alignment: .trailing)
                                                .padding(.bottom, 8)
                                        }
                                    }
                                }
                            }
                        }
                        Divider()
                            .frame(height: 1)
                            .background(.pBlack)
                            .padding(.bottom,8)
                        HStack(alignment: .bottom){
                            Text("합산 가격")
                                .font(.PTitle2)
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("\(shoppingViewModel.dateItem.last?.korTotal ?? 61500) 원")
                                    .font(.PTitle2)
                                Text("\(shoppingViewModel.dateItem.last?.frcTotal ?? 59) €")
                                    .font(.PTitle2)
                            }
                        }.padding(.bottom,48)
                        
                        HStack(spacing: 0){
                            Text("사지 않은")
                                .font(.PTitle3)
                                .foregroundColor(.pBlue)
                            Text("리스트 속 상품이 있어요")
                                .font(.PTitle3)
                            Spacer()
                        }
                        
                        ZStack{
                            Rectangle()
                                .foregroundColor(.pLightGray)
                                .cornerRadius(12)
                            DropdownListView(listViewModel: listViewModel)
                        }
                        
                    }
                    .padding(.bottom, 32)
                
            }
            .padding(.horizontal, 32)
            .padding(.top, 36)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        isMainViewActive = true
//                        
//                        for index in listViewModel.shoppingList.indices {
//                            listViewModel.shoppingList[index].isPurchase = listViewModel.shoppingList[index].isChoise
//                        }
//                        listViewModel.saveShoppingListToUserDefaults()
//                    }) {
//                        Image(systemName: "xmark")
//                    }
//                }
//            }
//            
//            NavigationLink(destination: MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), isActive: $isMainViewActive) {
//                EmptyView()
//            }

        }.navigationBarBackButtonHidden()
       
    }
}

#Preview {
    ResultModalView(shoppingViewModel: ShoppingViewModel(),listViewModel: ListViewModel(), isButton: .constant(false))
}
