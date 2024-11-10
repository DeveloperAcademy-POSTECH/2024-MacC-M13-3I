import SwiftUI

struct DropdownListView: View {
    @ObservedObject var listViewModel: ListViewModel
    @State var isButton: Bool = false
    var body: some View {
        ScrollView{
            ZStack(alignment: .top){
                Color.pLightGray
                    .frame(height: 156)
                    .clipShape(RoundedCorner(radius: 8, corners: [.bottomLeft, .bottomRight]))
           
                VStack(alignment: .leading) {
                    ForEach($listViewModel.shoppingList) { $list in
                        if !list.isPurchase {
                            Button(action: {
                                list.isChoise.toggle()
                                print (listViewModel.shoppingList)
                            }) {
                                HStack{
                                    if list.isChoise {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.pBlue)
                                                .stroke(
                                                    Color.pBlue,
                                                    style: StrokeStyle(
                                                        lineWidth: 1.5)
                                                )
                                                .frame(width: 15, height: 15)
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12))
                                                .foregroundColor(.pWhite)
                                        }
                                       
                                    }
                                    else {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.white)
                                                .stroke(
                                                    Color.pBlue,
                                                    style: StrokeStyle(
                                                        lineWidth: 1.5)
                                                )
                                                .frame(width: 15, height: 15)
                                        }
                                        
                                    }
                                    Text(list.title)
                                        .font(.PBody)
                                        .foregroundColor(.pBlack)
                                    Spacer()
                                }
                                .padding(.leading)
                                .padding(.vertical, 8)
                                .background(.pWhite)
                                .cornerRadius(12)
                                
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
        .frame(height: 156)
    }
}

#Preview {
    DropdownListView(listViewModel: ListViewModel())
}
