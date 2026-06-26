//
//  CustomTextField.swift
//  Boss Clinic
//
//  Created by Onqanet on 26/06/26.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String

    let placeholder: String
    let prefixImage: String

    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    
    var isDisabled: Bool = false

    var body: some View {
        HStack(spacing: 16) {

            Image(prefixImage)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundColor(.gray)
            )
            .disabled(isDisabled)
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .font(.custom("Inter18pt-Regular", size: 16))
            .foregroundColor(.white)
            
            
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

#Preview {
    PreviewWrapper()
}


private struct PreviewWrapper: View {
    @State private var email = ""

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            CustomTextField(
                text: $email,
                placeholder: "Enter your email",
                prefixImage: "emailIcon" // Replace with your asset name
            )
            .padding(.horizontal, 20)
        }
    }
}



