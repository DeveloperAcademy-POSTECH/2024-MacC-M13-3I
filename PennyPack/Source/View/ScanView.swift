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
                    .ignoresSafeArea()
                VStack {
                    ScannerRetakeView(recognizedText: $recognizedText)
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
