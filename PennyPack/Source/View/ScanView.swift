//
//  ScanView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

//import SwiftUI
//
//
//struct ScanView: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var shoppingViewModel: ShoppingViewModel
//    @ObservedObject var listViewModel: ListViewModel
//    @State private var recognizedText = ""
//    @StateObject var translation : TranslationSerivce
//
//    init(shoppingViewModel: ShoppingViewModel, listViewModel: ListViewModel) {
//        self.shoppingViewModel = shoppingViewModel
//        _translation = StateObject(wrappedValue: TranslationSerivce(shoppingViewModel: shoppingViewModel))
//        self.listViewModel = listViewModel
//    }
//
//    var body: some View {
//        NavigationStack{
//            ZStack{
//                Color.pBlack
//                    .ignoresSafeArea()
//                VStack {
//                    DocumentScannerView(recognizedText: $recognizedText)
//
//                    ScrollView {
//                        Text(recognizedText)
//                            .foregroundColor(.white)
//                        Text(translation.translatedText)
//                            .foregroundColor(.white)
//                    }
//                    RegexView(recognizedText: $recognizedText, validPrices: [0.81], validItems: "")
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.pBlue)
//                    }
//                }
//            }
//            .navigationTitle("카메라")
//            .navigationBarBackButtonHidden()
//            .onChange(of: recognizedText) { newText in
//                // recognizedText의 값이 변경될 때마다 자동으로 번역 함수 호출
//                if !newText.isEmpty {
//                    translation.translateText(text: newText)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ScanView(shoppingViewModel: ShoppingViewModel(),listViewModel: ListViewModel())
//}


import SwiftUI

struct ScanView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
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
        ScrollView {
            ZStack {
                Color.pBlack
                
                VStack {
                    DocumentScannerView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel, recognizedText: $recognizedText)
                    Spacer()
                    VStack(spacing: 0){
                        Text(recognizedText)
                            .foregroundColor(.white)
                        Text(translatedText1)
                            .foregroundColor(.white)
                            .onChange(of: recognizedText) { newValue in
                                translation.translateText(text: newValue) { result in
                                    self.translatedText1 = result
                                } // SwiftUI의 선언적 특성 때문에 뷰 내에서 직접 함수를 호출하는 것은 성능 문제를 일으킬 수 있음. 번역 결과를 저장할 상태 변수를 추가하면, 번역 로직이 뷰 업데이트 주기와 분리되어 더 효율적으로 동작하며, SwiftUI의 선언적 특성에 더 잘 부합함.
                            }
                        RegexView(translation: TranslationSerivce(shoppingViewModel: ShoppingViewModel()), recognizedText: $recognizedText)
                    }
                    .padding(.top, 50)
                    .background(
                        Rectangle()
                        //                            .frame(width: 361, height: 158)
                            .foregroundColor(.white)
                            .clipShape(RoundedCorner(radius: 12))
                    )
                    .padding(.horizontal)
                }
            }
        }.ignoresSafeArea()
    }
}

//#Preview {
//    ScanView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel)
//}
#Preview {
    ScanView(shoppingViewModel: ShoppingViewModel(), listViewModel: ListViewModel())
}
