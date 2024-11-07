import SwiftUI


struct TestView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    
    @ObservedObject var listViewModel: ListViewModel
    @State private var isMainViewActive = false
    
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading) {
                HStack {
                    Text(shoppingViewModel.formatDate(from: shoppingViewModel.dateItem.last?.date ?? Date()))
                        .font(.RTitle)
                    Spacer()
                }
                .padding(.bottom, 4)
                HStack {
                    Text("영수증")
                    Spacer()
                }
                .padding(.bottom,8)
                Divider()
                    .padding(.bottom,8)
                
                HStack {
                    Text(shoppingViewModel.dateItem.last?.place ?? "장소")
                        .font(.RCallout)
                    Spacer()
                }
                .padding(.bottom, 12)
                ScrollView {
                    VStack(alignment:.center) {
                        VStack(alignment: .center) {
                            HStack {
                                Text("품목")
                                    .font(.RCaption1)
                                    .frame(width: 118, alignment: .leading)
                                Text("수량")
                                    .font(.RCaption1)
                                    .frame(width: 24, alignment: .trailing)
                                Text("단가")
                                    .font(.RCaption1)
                                    .frame(width: 67, alignment: .trailing)
                                Text("합계")
                                    .font(.RCaption1)
                                    .frame(width: 57, alignment: .trailing)
                            }
                            .padding(.bottom, 20)
                            if let items = shoppingViewModel.dateItem.last?.items {
                                LazyVGrid(columns: [
                                    GridItem(.fixed(118)),
                                    GridItem(.fixed(24)),
                                    GridItem(.fixed(67)),
                                    GridItem(.fixed(57))
                                ])
                                {
                                    ForEach(items) { item in
                                        Text(item.korName)
                                            .font(.RCaption1)
                                            .frame(width: 118, alignment: .leading)
                                            .padding(.bottom, 8)
                                        Text("\(item.quantity)")
                                            .font(.RCaption1)
                                            .frame(width: 24, alignment: .trailing)
                                            .padding(.bottom, 8)
                                        Text("\(item.korUnitPrice) 원")
                                            .font(.RCaption1)
                                            .frame(width: 67, alignment: .trailing)
                                            .padding(.bottom, 8)
                                        Text("\(item.korPrice) 원")
                                            .font(.RCaption1)
                                            .frame(width: 57, alignment: .trailing)
                                            .padding(.bottom, 8)
                                    }
                                }
                            }
                            
                        }
                        .padding(32)
                        .background(Color("RLightGreen"))
                        .cornerRadius(4)
                        .padding(.bottom, 12)
                        
                        HStack {
                            Text("총계")
                                .font(.RCallout)
                            Spacer()
                            Text("\(shoppingViewModel.dateItem.last?.korTotal ?? 10000)")
                                .font(.RCallout)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 36)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isMainViewActive = true
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            
            NavigationLink(destination: MainView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel), isActive: $isMainViewActive) {
                EmptyView()
            }

        }.navigationBarBackButtonHidden()
       
    }
}

#Preview {
    TestView(shoppingViewModel: ShoppingViewModel(),listViewModel: ListViewModel())
}
