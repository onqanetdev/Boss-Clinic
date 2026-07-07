//
//  EmptyTodayScheduleView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 02/07/26.
//

import SwiftUI

struct EmptyTodayScheduleView: View {

    var body: some View {

        VStack(spacing: 18) {

            HStack {

                Text("Today's Schedule")
                    .font(.custom("Inter18pt-Bold", size: 17))
                    .foregroundColor(.white)

                Spacer()
            }

            VStack(spacing: 12) {

                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 42))
                    .foregroundColor(Color.white.opacity(0.5))

                Text("No medications scheduled")
                    .font(.custom("Inter18pt-SemiBold", size: 16))
                    .foregroundColor(.white)

                Text("You're all clear for today.")
                    .font(.custom("Inter18pt-Regular", size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 35)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.15), lineWidth: 2)
            )
        }
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}

#Preview {
    EmptyTodayScheduleView()
}
