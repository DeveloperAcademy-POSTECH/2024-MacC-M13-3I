import SwiftUI

extension View {
    func hideKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIView.endEditing), to: nil, from: nil, for: nil)
        }
    }
}
