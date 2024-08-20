//
//  CustomPhoneTextField.swift
//
//
//  Created by Div Khare on 8/2/24.
//

import Foundation
import SwiftUI

struct CustomPhoneTextField: View {
    @Binding var text: String
    var placeholder: String
    @Binding var isValid: Bool
    var countryCode: String
    
    @State private var formattedText: String = ""
    
    var body: some View {
        TextField(placeholder, text: $formattedText)
            .foregroundColor(.black)
            .onChange(of: formattedText) { newValue in
                var filtered = newValue.filter { $0.isNumber || $0 == "+" }
                
                // Remove "+1" if it's at the beginning
                if filtered.hasPrefix("+1") {
                    filtered = String(filtered.dropFirst(2))
                } else if filtered.hasPrefix("1") {
                    filtered = String(filtered.dropFirst())
                }
                
                formattedText = formatPhoneNumber(filtered)
                text = filtered
                validatePhoneNumber()
            }
            .padding()
            .background(Color(UIColor.white))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color.gray.opacity(0.3) : Color.red, lineWidth: 2)
            )
            .textContentType(.telephoneNumber)
    }

    private func formatPhoneNumber(_ number: String) -> String {
        var result = ""
        var index = number.startIndex
        for i in 0..<min(10, number.count) {
            if i == 3 || i == 6 {
                result += "-"
            }
            result.append(number[index])
            index = number.index(after: index)
        }
        
        return result
    }
    
    private func validatePhoneNumber() {
        let phoneNumber = countryCode + text
        let phoneNumberRegex = "^[+][0-9]{10,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        isValid = phoneTest.evaluate(with: phoneNumber)
    }
}
