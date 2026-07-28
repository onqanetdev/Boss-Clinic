//
//  CustomtextFieldForText.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 28/07/26.
//

import Foundation
import SwiftUI

struct CustomtextFieldForText: View {
    @Binding var text: String

    let placeholder: String
    //let prefixImage: String

    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    
    var isDisabled: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            TextField(
                "Example",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundColor(Color(uiColor: .gray))   // keep as-is
            )
            .disabled(isDisabled)
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .font(.custom("Inter18pt-Regular", size: 16))
            .foregroundStyle(Color.white)
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
        )
    }
}
