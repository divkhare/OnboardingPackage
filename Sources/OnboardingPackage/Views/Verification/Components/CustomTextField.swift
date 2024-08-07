//
//  CustomTextField.swift
//
//
//  Created by Div Khare on 8/2/24.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var contentType: UITextContentType = .telephoneNumber
    @Binding var isValid: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(UIColor.white))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color.gray.opacity(0.3) : Color.red, lineWidth: 2)
            )
            .textContentType(contentType)
    }
}
