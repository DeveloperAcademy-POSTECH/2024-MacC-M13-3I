import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func asString(withDecimalPlaces places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}
