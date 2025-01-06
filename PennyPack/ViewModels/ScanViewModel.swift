import Foundation
import SwiftUI

class ScanViewModel: ObservableObject{
    @Published var shoppingManager: ShoppingManager
    @Published var cameraViewModel: CameraViewModel
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
    
    init(shoppingManager: ShoppingManager, cameraViewModel: CameraViewModel, translation: TranslationSerivce) {
        self.shoppingManager = shoppingManager
        self.cameraViewModel = cameraViewModel
        self.translation = translation
    }
    
    
}
