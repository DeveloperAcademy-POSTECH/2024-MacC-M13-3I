import SwiftUI

struct MainView: View {
//    @StateObject private var shoppingViewModel = ShoppingViewModel()
    
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
   
    @State private var listText = ""
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color.rBackgroundGray
                    .ignoresSafeArea()
                VStack{
                    Color.rBlack
                        .ignoresSafeArea()
                        .frame(height: 339)
                    Spacer()
                }
                
                VStack(spacing: 24){
                    HStack{
                        Text("PennyPack")
                            .font(.RMainTitle)
                            .foregroundColor(.white)
                        Spacer()
                        NavigationLink(
                            destination: CalendarView(),
                            label: {
                                Image(systemName: "calendar")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            })
                    }.padding(.horizontal)
                    
                    HStack{
                        Image("France")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Text("프랑스")
                        Spacer()
                        Text("€ 1 = ₩ 1499.62")
                        Text("(EUR/KRW)")
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(
                        Color.white
                            .cornerRadius(12)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.rStrokeGray, lineWidth: 1)
                        
                    )
                    .padding(.horizontal)
                    
                    VStack(spacing: 0){
                        HStack{
                            Text("오늘의 장보기 리스트")
                            Spacer()
                        }
                        .padding()
                        .background(
                            Rectangle()
                                .foregroundColor(.white)
                                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                        )
                        .padding(.horizontal)
                        ZStack{
                            Rectangle()
                                .foregroundColor(.rLightGray)
                                .clipShape(RoundedCorner(radius: 12, corners: [.bottomLeft, .bottomRight]))
                            
                            VStack(spacing: 0){
                                List{
                                    ForEach($listViewModel.shoppingList, id: \.id){ $item in
                                        TextField("마트에서 살 물건을 이곳에 적어주세요.", text: $item.title)
                                            .onSubmit {
                                                listViewModel.saveShoppingListToUserDefaults()
                                            }
                                    }
                                    .listRowBackground(
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                    )
                                    Button {
                                        listViewModel.addLinkList(title: "")
                                        
                                    } label: {
                                        HStack{
                                            Spacer()
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 18))
                                                .foregroundStyle(.gray, .rBackgroundGray)
                                            Spacer()
                                        }
                                    }
                                    .listRowBackground(
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                    )
                                }.listRowSpacing(8)
                                    .listStyle(PlainListStyle())
                                    .padding(.horizontal)
                                    .background(.rLightGray)
                                    
                                
                            }.padding(.vertical)
                        }.padding(.horizontal)
                        NavigationLink(
                            destination: CartView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel),
                            label: {
                                HStack{
                                    Image(systemName: "cart")
                                        .font(.system(size: 24))
                                    Text("장보기 시작")
                                }.foregroundColor(.white)
                                    .padding(.vertical,13)
                                    .padding(.horizontal,111)
                                .background(
                                    Rectangle()
                                        .foregroundColor(.rMainBlue)
                                        .cornerRadius(24)
                                )
                            })
                        
                        .padding(.top,24)
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

