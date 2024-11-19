import Foundation
import SwiftUI

struct ResultView: View {
    @EnvironmentObject var pathRouter: PathRouter
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
        
    @State var showSheet: Bool = true
    var body: some View {
            ZStack{
                Color.pBlack
                    .ignoresSafeArea()
                VStack{
                    HStack(spacing: 0){
                        Text("오늘의 장보기")
                            .foregroundColor(.pBlue)
                        Text("는")
                            .foregroundColor(.pWhite)
                    }
                    .font(.PTitle1)
                    Text("만족하셨나요?")
                        .foregroundColor(.pWhite)
                        .font(.PTitle1)
                    Text("다음 주는 조금 더 아껴볼까요?")
                        .font(.PBody)
                        .foregroundColor(.pWhite)
                }
            }
            .sheet(isPresented: $showSheet) {
                ResultModalView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel, isButton: .constant(false))
                    .presentationDetents([.height(125.0), .height(700)])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Closing button tapped")
                        print("path count!!!! \(pathRouter.path.count)")
                        pathRouter.removeAll()
                        for index in listViewModel.shoppingList.indices {
                            listViewModel.shoppingList[index].isPurchase = listViewModel.shoppingList[index].isChoise
                        }
                        listViewModel.saveShoppingListToUserDefaults()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            pathRouter.removeAll()
                        }
                    }) {
                        Text("닫기")
                            .foregroundColor(.pBlue)
                    }
                }
            }
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ResultView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
        .environmentObject(PathViewModel())
}
