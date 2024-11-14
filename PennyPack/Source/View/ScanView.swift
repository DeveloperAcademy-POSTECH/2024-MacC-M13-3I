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
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraViewModel = CameraViewModel()
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @State private var recognizedText = ""
    @StateObject var translation : TranslationSerivce
    @State private var translatedText1: String = ""
    
    init(shoppingViewModel: ShoppingViewModel) {
        self.shoppingViewModel = shoppingViewModel
        _translation = StateObject(wrappedValue: TranslationSerivce())
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top){
                Color.pBlack
                    .ignoresSafeArea() //위치 수정해야 할듯
                VStack {
                    ScannerRetakeView(recognizedText: $recognizedText)
                    // SwiftUI의 선언적 특성 때문에 뷰 내에서 직접 함수를 호출하는 것은 성능 문제를 일으킬 수 있음. 번역 결과를 저장할 상태 변수를 추가하면, 번역 로직이 뷰 업데이트 주기와 분리되어 더 효율적으로 동작하며, SwiftUI의 선언적 특성에 더 잘 부합함.
                        .padding(.bottom, 20)
                    RegexView(translation: TranslationSerivce(), recognizedText: $recognizedText, shoppingViewModel: shoppingViewModel)
                        .clipShape(RoundedCorner(radius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.pGray)
                        )
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        shoppingViewModel.shoppingItem = []
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.pBlue)
                    }
                }
                ToolbarItem(placement: .principal){
                    Text("카메라")
                    
                        .font(.PTitle2)
                        .foregroundColor(.pWhite)
                }
            }
//            .ignoresSafeArea()
        }
    } 
}

struct KeyboardAvoidanceModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    keyboardHeight = keyboardRectangle.height
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
            }
    }
}


//#Preview {
//    ScanView(shoppingViewModel: shoppingViewModel,listViewModel: listViewModel)
//}
#Preview {
    ScanView(shoppingViewModel: ShoppingViewModel())
}
