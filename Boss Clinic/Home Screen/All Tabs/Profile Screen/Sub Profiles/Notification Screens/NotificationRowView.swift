//
//  NotificationRowView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import SwiftUI

struct NotificationRowView: View {

    let notification: NotificationItem

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            Text(notification.title)
                .font(.custom("Inter18pt-SemiBold", size: 18))
                .foregroundColor(.white)

            Text(notification.message)
                .font(.custom("Inter18pt-Regular", size: 16))
                .foregroundColor(Color.gray)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(red: 20/255,
                  green: 20/255,
                  blue: 20/255)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 28)
        )
    }
}
