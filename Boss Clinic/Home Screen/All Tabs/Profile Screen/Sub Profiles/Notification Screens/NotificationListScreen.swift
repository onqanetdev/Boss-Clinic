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
    @StateObject private var notificationReadVM = NotificationReadViewModel()

    @State private var selectedNotification: NotificationItem?
    @State private var showOfflineAlert = false

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 25) {

                headerView

                if notificationVM.notifications.isEmpty && !notificationVM.isLoading {

                    Spacer()

                    Text("No Notifications")
                        .font(.custom("Inter18pt-Regular", size: 18))
                        .foregroundColor(.gray)

                    Spacer()

                } else {

                    ScrollView(showsIndicators: false) {

                        LazyVStack(spacing: 18) {

                            ForEach(notificationVM.notifications) { notification in

                                NotificationRowView(notification: notification) {

                                    notificationReadVM.markNotificationAsRead(
                                        notificationID: notification.id
                                    )

                                    selectedNotification = notification
                                }
                                .onAppear {
                                    notificationVM.fetchNextPageIfNeeded(currentItem: notification)
                                }
                            }

                            if notificationVM.isLoadingMore {

                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            if notificationVM.isLoading || notificationReadVM.isLoading {

                NotificationSkeletonScreen()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: notificationVM.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .onChange(of: notificationReadVM.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .alert("No Internet Connection", isPresented: $showOfflineAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
        .onAppear {
            notificationVM.fetchNotifications(reset: true)
        }
        .onChange(of: notificationReadVM.notificationReadResponse) { response in

            guard let response else { return }

            print(response.message)

            notificationVM.fetchNotifications(reset: true)
        }
        .onChange(of: notificationReadVM.errorMessage) { error in

            guard let error else { return }

            print(error)
        }
        .navigationDestination(item: $selectedNotification) { notification in
            NotificationDetailScreen(notification: notification)
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
        }
    }
}


