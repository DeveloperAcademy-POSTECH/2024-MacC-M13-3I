import SwiftUI

struct ListView: View {
    @ObservedObject var mainViewModel: MainViewModel
    var body: some View {
        VStack{
            List{
                if let firstListManager = mainViewModel.listManager.first {
//                    ForEach($mainViewModel.listManager.shoppingList, id: \.id){ $item in
//                        if !item.isPurchase {
//                            TextField("마트에서 살 물건을 이곳에 적어주세요.", text: $item.title)
//                                .onSubmit {
//                                    mainViewModel.listManager
//                                }
//                        }
//                    }
                    ForEach(firstListManager.shoppingList, id: \.id) { item in
                        if !item.isPurchase {
                            TextField("마트에서 살 물건을 이곳에 적어주세요.", text: Binding(
                                get: { item.title },
                                set: { newValue in
                                    if let index = firstListManager.shoppingList.firstIndex(where: { $0.id == item.id }) {
                                        firstListManager.shoppingList[index].title = newValue
                                    }
                                }
                            ))
                            .onSubmit {
                                // addList 호출은 데이터 모델로 위임
                                firstListManager.addList(title: "새로운 항목")
                            }
                        }
                    }
                    .onDelete { indexSet in
                        // 삭제 처리: firstListManager에서 해당 항목 삭제
                        firstListManager.removeList(at: indexSet)
                    }
                } else {
                    Text("목록이 비어 있어요!")
                }
                //                ForEach($mainViewModel.listManager.shoppingList, id: \.id){ $item in
                //                    if !item.isPurchase {
                //                        TextField("마트에서 살 물건을 이곳에 적어주세요.", text: $item.title)
                //                            .onSubmit {
                //                                mainViewModel.listManager
                //                            }
                //                    }
                //                }
                //                .onDelete(perform: mainViewModel.listManager.removeList)
                //                .listRowSeparator(.hidden)
                //                .listRowBackground(
                //                    Rectangle()
                //                        .foregroundColor(.pWhite)
                //                        .cornerRadius(12)
                //                )
                Button {
//                    mainViewModel.listManager.addList(title: "")
                    if let firstListManager = mainViewModel.listManager.first {
                            firstListManager.addList(title: "새로운 항목")
                        }
                } label: {
                    HStack{
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.pLightGray)
                                .frame(width: 18,height: 18)
                            Image(systemName: "plus")
                                .font(.system(size: 10))
                                .foregroundStyle(.pBlue)
                        }
                        Spacer()
                    }
                } .listRowSeparator(.hidden)
                    .listRowBackground(
                        Rectangle()
                            .foregroundColor(.pWhite)
                            .cornerRadius(12)
                    )
            }
            .listRowSpacing(8)
            .listStyle(PlainListStyle())
            .padding(.horizontal)
            .background(.pLightGray)
            .listRowSeparator(.hidden)
            .listRowBackground(
                Rectangle()
                    .foregroundColor(.pWhite)
                    .cornerRadius(12)
            )
        }
    }
}

#Preview {
    ListView(mainViewModel: MainViewModel(shoppingManager: [ShoppingManager()], listManager: [ListManager()]))
}
