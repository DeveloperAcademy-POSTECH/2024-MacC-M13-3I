//
//  ContentView.swift
//  PennyPack
//
//  Created by siye on 11/1/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
//            print(isValidPhoneNumber("1234567890"))
//            isValidPhoneNumber(price: "1234567890")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


func Lov() {
    let price = "4.33"
    let regularExpression = #"^\d{1,2}\.\d{1,2}[^€/kg]$"#
    
    if let targetIndex = price.range(of: regularExpression, options: .regularExpression) {
        print("정규식과 일치")
        print("휴대폰번호 - \(price[targetIndex])")
    } else {
        print("정규식과 불일치")
    }
}

func matchesPattern(_ string: String, pattern: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    } catch {
        print("Invalid regex pattern: \(error.localizedDescription)")
        return false
    }
}
func isValidPhoneNumber(_ number: String) -> Bool {
    let pattern = "^[0-9]{3}-[0-9]{3}-[0-9]{4}$"
    return matchesPattern(number, pattern: pattern)
}
