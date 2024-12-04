import SwiftUI

struct HideView: View {
    @ObservedObject var listViewModel: ListViewModel
    var body: some View {
        Button{
            listViewModel.addListShowcase(title: "")
        } label: {
            Text("리스트 생성하기")
        }
    }
}
