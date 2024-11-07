import SwiftUI

struct DropdownView: View {
    @ObservedObject var listViewModel: ListViewModel
    var body: some View {
        ZStack{
            Color.rLightGray
                .clipShape(RoundedCorner(radius: 8, corners: [.bottomLeft, .bottomRight]))
       
            VStack(alignment: .leading) {
                ForEach($listViewModel.shoppingList) { $list in
                    Button(action: {
                        list.isChoise.toggle()
                    }) {
                        HStack{
                            Button{
                            } label: {
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
                                    }
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
                                    }
                                }
                               
                            }
                            .padding(.leading)
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
            .padding()

        }.padding(.horizontal)
    }
}

#Preview {
    DropdownView(listViewModel: ListViewModel())
}
