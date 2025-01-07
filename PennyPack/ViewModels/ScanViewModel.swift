import Foundation
import SwiftUI

class ScanViewModel: ObservableObject{
    @Published var shoppingManager: ShoppingManager
    @Published var cameraManager: CameraManager
    @Published var translation: TranslationSerivce
    
    @Published var recognizedText = ""
    @Published var translatedText1: String = ""
    @Published var isEditing: Bool = false
    @Published var validItemsK: [String] = []
    @Published var validItemsF: [String] = []
    @Published var validPricesF: [Double] = []
    @Published var quantity = 1
    @Published var korUnitPrice = 0
    @Published var frcUnitPrice = 0.0
    @Published var validItemText = ""
    @Published var validPriceText = ""
    @Published var isPicture: Bool = false
    @Published var recentImage: UIImage?
 
    init(shoppingManager: ShoppingManager, cameraManager: CameraManager, translation: TranslationSerivce) {
        self.shoppingManager = shoppingManager
        self.cameraManager = cameraManager
        self.translation = translation
    }
    
    func reset() {
        isEditing = false
        recognizedText = ""
        validItemsK.removeAll()
        validItemsF.removeAll()
        validPricesF.removeAll()
        quantity = 1
        validItemText = ""
        validPriceText = ""
    }
}
