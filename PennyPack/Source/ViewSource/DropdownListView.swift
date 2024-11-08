import SwiftUI

struct DropdownListView: View {
    @ObservedObject var listViewModel: ListViewModel
    @State var isButton: Bool = false
    var body: some View {
        ScrollView{
            ZStack{
                Color.rLightGray
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
                                                .fill(.rMainBlue)
                                                .stroke(
                                                    Color.rMainBlue,
                                                    style: StrokeStyle(
                                                        lineWidth: 1.5)
                                                )
                                                .frame(width: 15, height: 15)
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                        }.padding(.leading)
                                       
                                    }
                                    else {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.white)
                                                .stroke(
                                                    Color.rMainBlue,
                                                    style: StrokeStyle(
                                                        lineWidth: 1.5)
                                                )
                                                .frame(width: 15, height: 15)
                                        }.padding(.leading)
                                        
                                    }
                                    Text(list.title)
                                    Spacer()
                                }
                                .foregroundColor(.black)
                                .padding(.vertical, 12)
                                .background(.white)
                                .cornerRadius(12)
                                
                            }
                        }
                    }
                }
                .padding()
            }.padding(.horizontal)
            
        }
    }
}

#Preview {
    DropdownListView(listViewModel: ListViewModel())
}
