import SwiftUI

struct ScanView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraViewModel = CameraViewModel()
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @State private var recognizedText = ""
    @StateObject var translation = TranslationSerivce()
    @State private var translatedText1: String = ""
    
    @State private var isEditing: Bool = false
    @State private var validItemsK: [String] = []
    @State private var validItemsF: [String] = []
    @State private var validPricesF: [Double] = []
    @State private var quantity = 1
    @State private var korUnitPrice = 0
    @State private var frcUnitPrice = 0.0
    @State private var validItemText = ""
    @State private var validPriceText = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top){
                Color.pBlack
                    .ignoresSafeArea()
                VStack {
                    ScannerRetakeView(
                        translation: translation,
                        isEditing: $isEditing,
                        recognizedText: $recognizedText,
                        validItemsK: $validItemsK,
                        validItemsF: $validItemsF,
                        validPricesF: $validPricesF,
                        quantity: $quantity,
                        validItemText: $validItemText,
                        validPriceText: $validPriceText
                    ).padding(.bottom, 20)
                    
                    RegexView(
                        translation: TranslationSerivce(),
                        shoppingViewModel: shoppingViewModel,
                        isEditing: $isEditing,
                        recognizedText: $recognizedText,
                        validItemsK: $validItemsK,
                        validItemsF: $validItemsF,
                        validPricesF: $validPricesF,
                        quantity: $quantity,
                        korUnitPrice: $korUnitPrice,
                        frcUnitPrice: $frcUnitPrice,
                        validItemText: $validItemText,
                        validPriceText: $validPriceText
                    )
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

#Preview {
    ScanView(shoppingViewModel: ShoppingViewModel())
}
