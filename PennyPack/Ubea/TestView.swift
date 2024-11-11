//import SwiftUI
//
//struct DropdownListView: View {
//    @ObservedObject var listViewModel: ListViewModel
//    @State var isButton: Bool = false
//    
//    var body: some View {
//        VStack(spacing: 0){
//            List{
//                ForEach($listViewModel.shoppingList) { $list in
//                    if !list.isPurchase {
//                        Button(action: {
//                            list.isChoise.toggle()
//                        }) {
//                            HStack{
//                                if list.isChoise {
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 4)
//                                            .fill(.pBlue)
//                                            .stroke(
//                                                Color.pBlue,
//                                                style: StrokeStyle(
//                                                    lineWidth: 1.5)
//                                            )
//                                            .frame(width: 15, height: 15)
//                                        Image(systemName: "checkmark")
//                                            .font(.system(size: 12))
//                                            .foregroundColor(.pWhite)
//                                    }
//                                    Text(list.title)
//                                        .font(.PBody)
//                                        .foregroundColor(.pBlack)
//                                }
//                                else {
//                                    RoundedRectangle(cornerRadius: 4)
//                                        .fill(.white)
//                                        .stroke(
//                                            Color.pBlue,
//                                            style: StrokeStyle(
//                                                lineWidth: 1.5)
//                                        )
//                                    .frame(width: 15, height: 15)
//                                    Text(list.title)
//                                        .font(.PBody)
//                                        .foregroundColor(.pBlack)
//                                }
//                            }
//                        }
//                    }
//                }
//                .listRowSeparator(.hidden)
//                .listRowBackground(
//                    Rectangle()
//                        .foregroundColor(.pWhite)
//                        .cornerRadius(12)
//                )
//            }
//            .listRowSpacing(8)
//            .listStyle(PlainListStyle())
//            .padding()
//            .background(.pLightGray)
//            
//        }
//    }
//}
//
//#Preview {
//    DropdownListView(listViewModel: ListViewModel())
//}
