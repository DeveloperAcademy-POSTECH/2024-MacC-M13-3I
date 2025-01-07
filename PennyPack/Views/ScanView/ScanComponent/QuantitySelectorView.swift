import SwiftUI

struct QuantitySelectorView: View {
    @ObservedObject var scanViewModel: ScanViewModel
    
    let minQuantity: Int
    let maxQuantity: Int
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: decrementQuantity) {
                Circle()
                    .fill(.pGray)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "minus")
                            .foregroundColor(.pDarkGray)
                    )
            }
            .disabled(scanViewModel.quantity <= minQuantity)
            
            Text("\(scanViewModel.quantity)")
                .font(.PTitle3)
                .frame(minWidth: 36)
            
            Button(action: incrementQuantity) {
                Circle()
                    .fill(.pGray)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "plus")
                            .foregroundColor(.pDarkGray)
                    )
            }
            .disabled(scanViewModel.quantity >= maxQuantity)
        }
    }
    private func incrementQuantity() {
        if scanViewModel.quantity < maxQuantity {
            scanViewModel.quantity += 1
        }
    }
    
    private func decrementQuantity() {
        if scanViewModel.quantity > minQuantity {
            scanViewModel.quantity -= 1
        }
    }
}

