import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var pathRouter: PathRouter
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    @Binding var isAlertPresented: Bool
    @Binding var isFinishPresented: Bool
    @Binding var totalPriceWon: Int
    @Binding var totalPriceEuro: Double
    var body: some View {
        ZStack{
            Color.pCameraBlack
                .ignoresSafeArea()
            VStack(spacing: 0){
                Text("장보기 종료하기")
                    .font(.PTitle3)
                    .foregroundColor(.pBlack)
                    .padding(.top, 28)
                VStack(spacing: 0){
                    
                    Text("아직 구매하지 않은")
                    Text("장보기 리스트가 남아있어요.")
                    Text("이대로 장보기를 종료하시겠습니까?")
                }
                .font(.footnote)
                .foregroundColor(.pBlack)
                .padding(.vertical, 16)
                
                VStack(alignment: .leading, spacing: 4){
                    ForEach($listViewModel.shoppingList) { $list in
                        if !list.isPurchase {
                            HStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white)
                                    .stroke(
                                        Color.pBlue,
                                        style: StrokeStyle(
                                            lineWidth: 1.5)
                                    )
                                    .frame(width: 15, height: 15)
                                Text(list.title)
                                    .font(.PBody)
                                    .foregroundColor(.pBlack)
                            }
                        }
                    }
                }
                .padding(.bottom, 28)
                
                Divider()
                    .frame(width: 240,height: 1)
                    .background(.pBackground)
                
                HStack(spacing: 0){
                    Button{
                        isAlertPresented.toggle()
                        print("isAlertPresented: ",isAlertPresented)
                    } label: {
                        Text("돌아가기")
                            .font(.PBody)
                            .foregroundColor(.pDarkGray)
                            .padding(.horizontal,32)
                            .padding(.vertical,12)
                    }
                    
                    Divider()
                        .frame(width: 1,height: 44)
                        .background(.pBackground)
                    Button{
                        isFinishPresented.toggle()
                        print("isFinish: ",isFinishPresented)
                        pathRouter.push(.result)
//                        finishShopping()
                        let dateItem = DateItem(date: Date(), items: shoppingViewModel.shoppingItem, korTotal: totalPriceWon, frcTotal: totalPriceEuro, place: "프랑스마트")
                        
                        shoppingViewModel.dateItem.append(dateItem)
                        shoppingViewModel.shoppingItem = []
                        shoppingViewModel.saveShoppingListToUserDefaults()
                        
                    } label: {
                        Text("종료하기")
                            .font(.PBody)
                            .foregroundColor(.pBlue)
                            .padding(.horizontal,32)
                            .padding(.vertical,12)
                            
                    }
                }

                
            }
            .background(Color.pWhite)
            .cornerRadius(12)
        }
    }
    //윈터 pathRouter.push(.result)를 위한 추가
//    private func finishShopping() {
//        for index in listViewModel.shoppingList.indices {
//            listViewModel.shoppingList[index].isPurchase = listViewModel.shoppingList[index].isChoise
//        }
//        
//        let dateItem = DateItem(date: Date(), items: shoppingViewModel.shoppingItem, korTotal: totalPriceWon, frcTotal: totalPriceEuro, place: "프랑스마트")
//        
//        shoppingViewModel.dateItem.append(dateItem)
//        shoppingViewModel.shoppingItem = []
//        
//        shoppingViewModel.saveShoppingListToUserDefaults()
//        listViewModel.saveShoppingListToUserDefaults()
//        
////        isFinish = true
//        pathRouter.push(.result)
//    }
}

#Preview {
    CustomAlertView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel(), isAlertPresented: .constant(false), isFinishPresented: .constant(false), totalPriceWon: .constant(0), totalPriceEuro: .constant(0.0))
}
