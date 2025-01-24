import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var pathRouter: PathRouter
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        ZStack{
            Color.pCameraBlack
                .ignoresSafeArea()
            VStack(spacing: 0){
                Text("장보기 종료하기")
                    .font(.PTitle3)
                    .foregroundColor(.pBlack)
                    .padding(.top, 28)
                if cartViewModel.listManager.shoppingList.filter { !$0.isPurchase }.isEmpty {
                    Text("장보기를 종료하시겠습니까?")
                        .font(.PBody)
                        .foregroundColor(.gray)
                        .padding(.bottom, 28)
                }
                else {
                    VStack(spacing: 0){
                        Text("아직 구매하지 않은")
                        Text("장보기 리스트가 남아있어요.")
                        Text("이대로 장보기를 종료하시겠습니까?")
                    }
                    .font(.footnote)
                    .foregroundColor(.pBlack)
                    .padding(.vertical, 16)
                    
                    VStack(alignment: .leading, spacing: 4){
                        ForEach($cartViewModel.listManager.shoppingList) { $list in
                            if !list.isPurchase {
                                    Text(list.title)
                                        .font(.PBody)
                                        .foregroundColor(.pBlack)
                            }
                        }
                    }
                    .padding(.bottom, 28)
                }
                
                Divider()
                    .frame(width: 240,height: 1)
                    .background(.pBackground)
                
                HStack(spacing: 0){
                    Button{
                        cartViewModel.isAlert.toggle()
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
                        cartViewModel.isFinish.toggle()
                        pathRouter.push(.result)
                        let receiptDate = ReceiptDate(date: Date(), items: cartViewModel.shoppingManager.cartItem, korTotal: cartViewModel.totalPriceWon, frcTotal: cartViewModel.totalPriceEuro, place: "프랑스마트")
                        
                        cartViewModel.shoppingManager.receiptDate.append(receiptDate)
                        cartViewModel.shoppingManager.cartItem = []
                        cartViewModel.shoppingManager
                        
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
}

#Preview {
    CustomAlertView(cartViewModel: CartViewModel(shoppingManager: ShoppingManager(), listManager: ListManager()))
}
