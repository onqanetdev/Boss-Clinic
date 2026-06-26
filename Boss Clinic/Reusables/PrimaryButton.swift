//
//  PrimaryButton.swift
//  Boss Clinic
//
//  Created by Onqanet on 25/06/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Inter18pt-SemiBold", size: 14))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.08),
                        radius: 8,
                        x: 0,
                        y: 4)
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        PrimaryButton(title: "Get Started") {
            print("Tapped")
        }
        .padding(.horizontal, 30)
    }
}

