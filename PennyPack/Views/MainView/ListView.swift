import SwiftUI

struct ListView: View {
    @ObservedObject var mainViewModel: MainViewModel
    var body: some View {
        VStack{
            List{
                ForEach($mainViewModel.listManager.shoppingList, id: \.id){ $item in
                    if !item.isPurchase {
                        TextField("마트에서 살 물건을 이곳에 적어주세요.", text: $item.title)
                            .onSubmit {
                                mainViewModel.listManager.saveShoppingListToUserDefaults()
                            }
                    }
                }
                .onDelete(perform: mainViewModel.listManager.removeList)
                .listRowSeparator(.hidden)
                .listRowBackground(
                    Rectangle()
                        .foregroundColor(.pWhite)
                        .cornerRadius(12)
                )
                Button {
                    mainViewModel.listManager.addList(title: "")
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
        }
    }
}

#Preview {
    ListView(mainViewModel: MainViewModel(shoppingManager: ShoppingManager(), listManager: ListManager()))
}
