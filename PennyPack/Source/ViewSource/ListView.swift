import SwiftUI

struct ListView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    
    var body: some View {
        VStack{
            List{
                ForEach($listViewModel.shoppingList, id: \.id){ $item in
                    if !item.isPurchase {
                        TextField("마트에서 살 물건을 이곳에 적어주세요.", text: $item.title)
                            .onSubmit {
                                listViewModel.saveShoppingListToUserDefaults()
                            }
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
                            .foregroundStyle(.pBlue, .pLightGray)
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
                .background(.pLightGray)
                

        }
    }
}

#Preview {
    ListView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
}
