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
//  Created by siye on 11/1/24.
//

import SwiftUI


struct TestView: View {
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    @State private var recognizedText = ""
    @StateObject var translation : TranslationSerivce
    @State private var translatedText1: String = ""
    
    init(shoppingViewModel: ShoppingViewModel, listViewModel: ListViewModel) {
           self.shoppingViewModel = shoppingViewModel
           _translation = StateObject(wrappedValue: TranslationSerivce(shoppingViewModel: shoppingViewModel))
        self.listViewModel = listViewModel
       }

    var body: some View {
        NavigationStack{
            VStack {
                DocumentScannerView(shoppingViewModel: shoppingViewModel, recognizedText: $recognizedText)
                
                ScrollView {
                    Text(recognizedText)
                    Text(translation.translatedText)
                }
                RegexView(translation: TranslationSerivce(shoppingViewModel: ShoppingViewModel()), recognizedText: $recognizedText)
            }
            .onChange(of: recognizedText) { newText in
                // recognizedText의 값이 변경될 때마다 자동으로 번역 함수 호출
                if !newText.isEmpty {
                    translation.translateText(text: newText) { result in
                        self.translatedText1 = result
                    }
                }
            }
        }
    }
}

#Preview {
    TestView(shoppingViewModel: ShoppingViewModel(),listViewModel: ListViewModel())
}

//#Preview {
//    DropdownListView(listViewModel: ListViewModel())
//}

