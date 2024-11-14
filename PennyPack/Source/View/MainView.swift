import SwiftUI

struct MainView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
   
    @State private var listText = ""
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                VStack(spacing: 0){
                    HStack{
                        Text("PennyPack")
                            .font(.PLargeTitle)
                            .foregroundColor(.pWhite)
                        Spacer()
                        NavigationLink(
                            destination: CalendarView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel),
                            label: {
                                Image(systemName: "calendar")
                                    .font(.system(size: 24))
                                    .foregroundColor(.pWhite)
                            })
                    }
                    .padding(.horizontal)
                    .padding(.top, 48)
                    .padding(.bottom, 20)
                    HStack{
                        Image("France")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Text("프랑스")
                            .font(.PTitle3)
                            .foregroundColor(.pBlack)
                        Spacer()
                        Text("€ 1 = ₩ 1499.62")
                            .font(.PTitle2)
                            .foregroundColor(.pBlack)
                        Text("(EUR/KRW)")
                            .font(.PFootnote)
                            .foregroundColor(.pBlack)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.pWhite)
                            .stroke(Color.pGray, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                    
                    VStack(spacing: 0){
                        VStack(spacing: 0){
                            HStack{
                                Text("오늘의 장보기 리스트")
                                    .font(.PTitle2)
                                    .foregroundColor(.pBlack)
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(
                                Rectangle()
                                    .foregroundColor(.white)
                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                                
                            )
                            Divider() 
                                .frame(height: 1)
                                .background(.pGray)
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.pLightGray)
                                    .clipShape(RoundedCorner(radius: 12, corners: [.bottomLeft, .bottomRight]))
                                
                                VStack(spacing: 0){
                                    ListView(shoppingViewModel: shoppingViewModel
                                             , listViewModel: listViewModel)
                                    
                                }.padding(.vertical)
                            }
                        }
                        .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.pGray, lineWidth: 2)
                        ).padding(.horizontal)
                            .padding(.bottom, 24)
                        NavigationLink(
                            destination: CartView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel),
                            label: {
                                HStack{
                                    Image(systemName: "cart")
                                        .font(.system(size: 20))
                                        .foregroundColor(.pWhite)
                                    Text("장보기 시작")
                                        .font(.PTitle2)
                                        .foregroundColor(.pWhite)
                                }.foregroundColor(.white)
                                    .padding(.vertical,13)
                                    .padding(.horizontal,111)
                                .background(
                                    Rectangle()
                                        .foregroundColor(.pBlue)
                                        .cornerRadius(24)
                                )
                            })
                        .padding(.bottom,30)
                    }
                }
                
            }
            .onAppear{
                shoppingViewModel.loadShoppingListFromUserDefaults()
                listViewModel.loadShoppingListFromUserDefaults()
            }
        }.navigationBarBackButtonHidden()
    }
}




#Preview {
    MainView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
}

