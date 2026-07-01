//
//  RefillReminderCardView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI

struct RefillReminderCardView: View {

    var body: some View {

        HStack(spacing: 20) {

            // Medicine Icon
            Image("medicine")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.15), lineWidth: 2)
                )

            

            // Reminder Details
            VStack(alignment: .leading, spacing: 10) {

                Text("Refill Reminder")
                    .font(.custom("Inter18pt-Regular", size: 13))
                    .foregroundColor(.gray)

                Text("Lisinopril 10 mg")
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(.white)

                Text("3 days left")
                    .font(.custom("Inter18pt-Regular", size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Button
            Button {

                print("Refill Now")

            } label: {

                Text("Refill Now")
                    .font(.custom("Inter18pt-SemiBold", size: 10))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
            }
        }
        .padding(5)
        .background(
            Color(red: 7/255, green: 7/255, blue: 6/255)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        RefillReminderCardView()
            .padding()
    }
}
