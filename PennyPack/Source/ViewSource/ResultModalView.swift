import SwiftUI


struct ResultModalView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    @State private var isMainViewActive = false
    @Binding var isButton: Bool
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.pWhite
                    .ignoresSafeArea()
                ScrollView{
                    VStack (alignment: .leading, spacing: 0) {
                        HStack {
                            Text(shoppingViewModel.formatDateToYYYYMDHHMM(from: shoppingViewModel.dateItem.last?.date ?? Date()))
                                .font(.PTitle3)
                            Spacer()
                        }
                        .padding(.bottom, 12)
                        HStack {
                            Text("오늘의 영수증")
                                .font(.PTitle1)
                            Spacer()
                        }
                        .padding(.bottom,20)
                        Divider()
                            .frame(height: 1.5)
                            .background(.pDarkGray)
                            .padding(.bottom,8)
                        
                        HStack {
                            Spacer()
                            Text("€ 1 = ₩ 1499.62")
                                .font(.PSubhead)
                            Text("(EUR/KRW)")
                                .font(.PFootnote)
                        }.foregroundColor(.pDarkGray)
                            .padding(.bottom, 20)
                        
                        VStack(alignment:.center, spacing: 0) {
                            VStack(alignment: .center) {
                                HStack(spacing: 0) {
                                    Text("품목")
                                        .frame(width: 142, alignment: .leading)
                                    Text("단가")
                                        .frame(width: 80, alignment: .leading)
                                    Text("수량")
                                        .frame(width: 81, alignment: .leading)
                                    
                                    Text("합계")                                        .frame(width: 26, alignment: .leading)
                                }
                                .font(.PCallout)
                                .foregroundColor(.pBlack)
                                .padding(.bottom, 12)
                                if let items = shoppingViewModel.dateItem.last?.items {
                                    VStack(spacing: 8){
                                        ForEach(items) { item in
                                            HStack(spacing: 0){
                                                Text(item.korName)
                                                    .font(.PSubhead)
                                                    .frame(width: 130, alignment: .leading)
                                                Text("\(item.frcUnitPrice)")
                                                    .font(.PSubhead)
                                                    .frame(width: 38, alignment: .trailing)
                                                Text("\(item.quantity)")
                                                    .font(.PSubhead)
                                                    .frame(width: 80, alignment: .trailing)
                                                Text("\(item.frcUnitPrice * item.quantity)")
                                                    .font(.PSubhead)
                                                    .frame(width: 81, alignment: .trailing)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                            Divider()
                                .frame(height: 1.5)
                                .background(.pDarkGray)
                                .padding(.bottom,12)
                            HStack(alignment: .bottom){
                                Text("합산 가격")
                                    .font(.PTitle3)
                                Spacer()
                                VStack(alignment: .trailing, spacing: 0){
                                    Text("\(shoppingViewModel.dateItem.last?.korTotal ?? 61500) 원")
                                        .font(.PTitle3)
                                    Text("\(shoppingViewModel.dateItem.last?.frcTotal ?? 59) €")
                                        .font(.PTitle1)
                                }
                            }.padding(.bottom,36)
                            
                            HStack(spacing: 0){
                                Text("사지 않은")
                                    .font(.PTitle3)
                                    .foregroundColor(.pBlue)
                                Text(" 리스트 속 상품이 있어요")
                                    .font(.PTitle3)
                                Spacer()
                            }.padding(.bottom, 4)
                            
                            ZStack{
                                Rectangle()
                                    .frame(height: 140)
                                    .foregroundColor(.pLightGray)
                                    .cornerRadius(12)
                                DropdownListView(listViewModel: listViewModel)
                                    .frame(width: 330,height: 120)
                            }
                            
                        }
                        .padding(.bottom, 32)
                        
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 36)
                }
            }
        }.navigationBarBackButtonHidden()
        
    }
}

#Preview {
    ResultModalView(shoppingViewModel: ShoppingViewModel(),listViewModel: ListViewModel(), isButton: .constant(false))
}
