import SwiftUI


struct ReceiptView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    @State private var isMainViewActive = false
    @Binding var isButton: Bool
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                Color.pWhite
                    .ignoresSafeArea()
                ScrollView{
                    VStack (alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0){
                            HStack {
                                Text(shoppingViewModel.formatDate(from: shoppingViewModel.selectedDateItem?.date ?? Date()))
                                    .font(.PTitle2)
                                    .foregroundColor(.pWhite)
                                Spacer()
                            }.padding(.top, 24)
                            .padding(.bottom, 4)
                            HStack {
                                Text("영수증")
                                    .font(.PTitle1)
                                    .foregroundColor(.pWhite)
                                Spacer()
                            }
                            .padding(.bottom,20)
                        }
                        .padding(.horizontal, 24)
                        .background(.pBlack)
                        HStack{
                            Text("\(shoppingViewModel.selectedDateItem?.frcTotal ?? 59) €")
                                .font(.PTitle1)
                                .foregroundColor(.pBlack)
                            Spacer()
                            Text("\(shoppingViewModel.selectedDateItem?.korTotal ?? 61500) 원")
                                .font(.PTitle1)
                                .foregroundColor(.pDarkGray)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        HStack {
                            Spacer()
                            Text("€ 1 = ₩ 1499.62")
                                .font(.PSubhead)
                                .foregroundColor(.pDarkGray)
                            Text("(EUR/KRW)")
                                .font(.PFootnote)
                                .foregroundColor(.pDarkGray)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical,3)
                        .background(.pLightGray)
                        .padding(.bottom, 24)
                        VStack(alignment:.center) {
                            VStack(alignment: .center) {
                                HStack(spacing: 0) {
                                    Text("품목")
                                        .frame(width: 142, alignment: .leading)
                                    Text("단가")
                                        .frame(width: 80, alignment: .leading)
                                    Text("수량")
                                        .frame(width: 81, alignment: .leading)
                                    Text("합계")                                       
                                        .frame(width: 26, alignment: .leading)
                                }
                                .font(.PCallout)
                                .foregroundColor(.pBlack)
                                .padding(.bottom, 12)
                                if let items = shoppingViewModel.selectedDateItem?.items  {
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
                            }.padding(.bottom,60)
                            
                            HStack(spacing: 0){
                                Text("장보기 리스트")
                                    .font(.PTitle3)
                                Spacer()
                            }
                            
                            ZStack{
                                Rectangle()
                                    .frame(height: 140)
                                    .foregroundColor(.pLightGray)
                                    .cornerRadius(12)
                                DropdownListView(listViewModel: listViewModel)
                                    .frame(width: 330,height: 120)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
       
    }
}

#Preview {
    ReceiptView(shoppingViewModel: ShoppingViewModel(),listViewModel: ListViewModel(), isButton: .constant(false))
}
