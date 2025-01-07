import SwiftUI

struct ScanView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var scanViewModel: ScanViewModel
    
    var body: some View {
        ZStack(alignment: .top){
            Color.pBlack
                .ignoresSafeArea()
            VStack {
                ScannerRetakeView(scanViewModel: scanViewModel)
                .padding(.bottom, 20)
                
                RegexView(
                    translation: scanViewModel.translation,
                    shoppingViewModel: scanViewModel.shoppingManager,
                    isEditing: $scanViewModel.isEditing,
                    recognizedText: $scanViewModel.recognizedText,
                    validItemsK: $scanViewModel.validItemsK,
                    validItemsF: $scanViewModel.validItemsF,
                    validPricesF: $scanViewModel.validPricesF,
                    quantity: $scanViewModel.quantity,
                    korUnitPrice: $scanViewModel.korUnitPrice,
                    frcUnitPrice: $scanViewModel.frcUnitPrice,
                    validItemText: $scanViewModel.validItemText,
                    validPriceText: $scanViewModel.validPriceText
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
                    scanViewModel.shoppingManager.cartItem = []
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
    ScanView(scanViewModel: ScanViewModel(shoppingManager: ShoppingManager(), cameraManager: CameraManager(), translation: TranslationSerivce()))
}
