import Foundation
import SwiftUI

struct ResultView: View {
    @EnvironmentObject var pathRouter: PathRouter
//    @EnvironmentObject var pathViewModel: PathViewModel
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
        
    @State var showSheet: Bool = true
//    @Environment(\.presentationMode) var presentationMode
    
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
//                        print("Before removal: \(pathRouter.path)")
                        print("path count!!!! \(pathRouter.path.count)")
//                        pathViewModel.path.removeLast(pathRouter.path.count)
                        pathRouter.removeAll()
//                        print("After removal: \(pathRouter.path)")
                        
                        for index in listViewModel.shoppingList.indices {
                            listViewModel.shoppingList[index].isPurchase = listViewModel.shoppingList[index].isChoise
                        }
                        listViewModel.saveShoppingListToUserDefaults()
                        
//                        print("Path count after removal: \(pathRouter.path.count)")
                        
                        // 메인 뷰로 이동
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            pathRouter.removeAll()
                        }
                    }) {
                        Text("닫기")
                            .foregroundColor(.pBlue)
                    }
                }
            }
//            .environmentObject(pathViewModel)
        
//            NavigationLink(destination: MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), isActive: $isMainViewActive) {
//                EmptyView()
//            }
            
//        }
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ResultView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
        .environmentObject(PathViewModel())
}
