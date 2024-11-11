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
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.pBlack
                    
                VStack {
                    viewModel.cameraPreview.ignoresSafeArea()
                        .onAppear {
                            viewModel.configure()
                        }
                        .gesture(MagnificationGesture()
                            .onChanged { val in
                                viewModel.zoom(factor: val)
                            }
                            .onEnded { _ in
                                viewModel.zoomInitialize()
                            }
                        )
                        .frame(width: 360, height: 350)
                        .cornerRadius(11)
                        .padding(.top, 184)
                    
                    Button(action: {
                        viewModel.capturePhoto()
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(.pBlue)
                                .frame(width: 70)
                            Image(systemName: "camera.fill")
                                .resizable()
                                .frame(width: 33, height: 26)
                                .foregroundColor(.white)
                        }
                    })
                    .padding(.top, 18)
                    
                    Spacer()
                    
                    VStack(spacing: 0){
                        HStack{
                            Text("상품명 프랑스어")
                            Spacer()
                            Text("원")
                        }.font(.PBody)
                        HStack{
                            Text("상품명 한국어")
                            Spacer()
                            Text("원")
                        }.font(.PTitle2)
                        HStack{
                            Text("수량")
                                .font(.PTitle2)
                            Spacer()
                            Text("1")
                                .font(.PTitle3)
                        }
                        HStack{
                            Spacer()
                            Text("수정, 저장")
                        }
                    }
                    .padding(.top, 50)
                    .background(
                        Rectangle()
                            .frame(width: 361, height: 158)
                            .foregroundColor(.white)
                            .clipShape(RoundedCorner(radius: 12))
                    )
                    .padding(.horizontal)
                }
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    ScanView(viewModel: CameraViewModel())
}
