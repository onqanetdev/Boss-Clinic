//
//  NotificationListScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import Foundation
import SwiftUI

struct NotificationListScreen: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var notificationVM = NotificationViewModel()

    @State private var notifications: [NotificationItem] = []

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 25) {

                headerView

                if notifications.isEmpty {

                    Spacer()

                    Text("No Notifications")
                        .font(.custom("Inter18pt-Regular", size: 18))
                        .foregroundColor(.gray)

                    Spacer()

                } else {

                    ScrollView(showsIndicators: false) {

                        LazyVStack(spacing: 18) {

                            ForEach(notifications) { notification in

                                NotificationRowView(notification: notification)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            if notificationVM.isLoading {

                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            notificationVM.fetchNotifications()
        }
        .onChange(of: notificationVM.notificationResponse) { response in

            guard let response else { return }

            notifications = response.data ?? []
        }
    }

    // MARK: Header

    private var headerView: some View {

        HStack {

            Button {
                dismiss()
            } label: {

                Image(systemName: "arrow.left")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(.white)
            }

            Text("Notifications")
                .font(.custom("Inter18pt-SemiBold", size: 20))
                .foregroundColor(.white)

            Spacer()

//            Button {
//
//                // Clear All API
//
//            } label: {
//
//                Text("Clear all")
//                    .font(.custom("Inter18pt-Regular", size: 18))
//                    .foregroundColor(.white.opacity(0.8))
//            }
        }
    }
}

