//
//  NotificationDetailScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 04/08/26.
//


import SwiftUI



struct NotificationDetailScreen: View {

    let notification: NotificationItem

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 24) {

                    header

                    detailCard

                    Spacer(minLength: 30)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

private extension NotificationDetailScreen {

    var header: some View {

        HStack {

            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(.white)
            }

            Text("Notification")
                .font(.custom("Inter18pt-SemiBold", size: 20))
                .foregroundColor(.white)

            Spacer()
        }
    }

    var detailCard: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Image(systemName: "bell.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title ?? "Notification")
                        .font(.custom("Inter18pt-SemiBold", size: 18))
                        .foregroundColor(.white)

//                    Text(notification.notificationCategory?.capitalized ?? "")
//                        .font(.custom("Inter18pt-Regular", size: 13))
//                        .foregroundColor(.gray)
                }

                Spacer()
            }

            Divider()
                .background(Color.white.opacity(0.2))

            Text(notification.message ?? "")
                .font(.custom("Inter18pt-Regular", size: 15))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(4)

            if let datetime = notification.datetime {
                infoRow("Scheduled", datetime.asFormattedDate)
            }

            infoRow("Received", notification.createdAt.asFormattedDate ?? "-")

            infoRow("Status", (notification.isRead ?? false) ? "Read" : "Unread")
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .foregroundColor(.white)
        }
    }
}
