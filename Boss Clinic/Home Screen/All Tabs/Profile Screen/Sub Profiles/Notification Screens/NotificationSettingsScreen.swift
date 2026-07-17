//
//  NotificationSettingsScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 17/07/26.
//

import Foundation
import SwiftUI



struct NotificationSettingsScreen: View {

    @Environment(\.dismiss) private var dismiss
    
    
    @StateObject private var notificationVM = NotificationSettingsViewModel()

    @State private var medicationReminder = true
    @State private var refillReminder = true
    @State private var soundEnabled = true
    @State private var vibrationEnabled = true

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 28) {

                    // MARK: Header

                    HStack(spacing: 14) {

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }

                        Text("Notification Settings")
                            .font(.custom("Inter24pt-Bold", size: 20))
                            .foregroundColor(.white)

                        Spacer()
                    }

                    // MARK: General

                    Text("General")
                        .font(.custom("Inter18pt-Regular", size: 15))
                        .foregroundColor(.gray)

                    VStack(spacing: 18) {

                        NotificationToggleCard(
                            title: "Medication Reminders",
                            subtitle: "Get notified when it's time to take a dose",
                            isOn: $medicationReminder
                        )

                        NotificationToggleCard(
                            title: "Refill Reminders",
                            subtitle: "Get notified when medication is running low",
                            isOn: $refillReminder
                        )
                    }

                    // MARK: Alert Style

                    Text("Alert Style")
                        .font(.custom("Inter18pt-Regular", size: 15))
                        .foregroundColor(.gray)

                    VStack(spacing: 18) {

                        NotificationToggleCard(
                            title: "Sound",
                            subtitle: nil,
                            isOn: $soundEnabled
                        )

                        NotificationToggleCard(
                            title: "Vibration",
                            subtitle: nil,
                            isOn: $vibrationEnabled
                        )
                    }

                    // MARK: Button

                    Button {

                        print("Send Test Notification")

                    } label: {

                        Text("Send Test Notification")
                            .font(.custom("Inter18pt-Regular", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 62)
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 22)
                .padding(.top, 16)
            }
            
            
            if notificationVM.isLoading {

                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(1.5)
                }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            notificationVM.fetchNotificationSettings()
        }
        .onChange(of: notificationVM.notificationSettingsResponse) { response in

            guard let response else { return }

            medicationReminder = response.data.medicationReminders
            refillReminder = response.data.refillReminders
            soundEnabled = response.data.sound
            vibrationEnabled = response.data.vibration
        }
    }
}


