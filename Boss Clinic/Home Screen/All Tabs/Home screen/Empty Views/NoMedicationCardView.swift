//
//  NoMedicationCardView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI

struct NoMedicationCardView: View {

    var body: some View {

        VStack(spacing: 12) {

            Image(systemName: "checkmark.circle")
                .font(.system(size: 45))
                .foregroundColor(.green)

            Text("No Medication Today")
                .font(.custom("Inter18pt-SemiBold", size: 18))
                .foregroundColor(.white)

            Text("Enjoy your day! You don't have any medications scheduled.")
                .font(.custom("Inter18pt-Regular", size: 13))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .background(
            Color(red: 7/255, green: 7/255, blue: 6/255)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.15), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        NoMedicationCardView()
            .padding()
    }
}

