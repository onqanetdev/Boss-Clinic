//
//  NotificationToggleCard.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 17/07/26.
//

import Foundation
import SwiftUI


struct NotificationToggleCard: View {

    let title: String
    let subtitle: String?

    @Binding var isOn: Bool

    var body: some View {

        HStack(alignment: .center) {

            VStack(alignment: .leading, spacing: 8) {

                Text(title)
                    .font(.custom("Inter18pt-Regular", size: 13))
                    .foregroundColor(.white)

                if let subtitle {

                    Text(subtitle)
                        .font(.custom("Inter18pt-Regular", size: 10))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.white)
        }
        .padding(20)
        .frame(minHeight: 70)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.35), lineWidth: 1)
        )
    }
}


