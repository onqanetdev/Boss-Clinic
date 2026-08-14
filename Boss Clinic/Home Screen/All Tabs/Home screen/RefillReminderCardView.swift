//
//  RefillReminderCardView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI

struct RefillReminderCardView: View {

    let medication: RefillReminder

    // TODO: Replace these with real data passed in from wherever this card is used
    let medicationName: String = "Lisinopril 10 mg"
    let daysLeft: Int = 3

    @State private var showRefillAlert = false

    // NOTE: these were previously typed `() -> Void?` (optional Void).
    // Every caller passes a plain `() -> Void` closure, and the implicit
    // Void -> Void? wrapping Swift has to perform for that mismatch is
    // exactly the kind of thing that blows up the type-checker — this was
    // the root cause of the "unable to type-check in reasonable time" /
    // cascading `homeScreenAlerts` errors upstream in HomeScreen.
    let onTappedRefill: () -> Void
    let onTappedNotNow: () -> Void

    @State private var pendingConsultNow = false
    @State private var showConsultNowScreen = false

    var body: some View {

        HStack(spacing: 15) {

            // Medicine Icon
            Image("med_okay")
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.15), lineWidth: 2)
                )

            // Reminder Details
            VStack(alignment: .leading, spacing: 10) {

                Text("Refill Reminder")
                    .font(.custom("Inter18pt-Regular", size: 13))
                    .foregroundColor(.gray)

                Text(medication.medicineName)
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(.white)

                Text("\(medication.daysLeft) days left")
                    .font(.custom("Inter18pt-Regular", size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Button
            Button {
                showRefillAlert = true
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
        .padding(10)
        .background(
            Color(red: 7/255, green: 7/255, blue: 6/255)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.12), lineWidth: 2)
        )
        .fullScreenCover(isPresented: $showRefillAlert, onDismiss: handleRefillAlertDismiss) {
            RefillAlertView(
                medicationName: medicationName,
                daysLeft: daysLeft,
                onRefillNow: onTappedRefill,
                onScheduleConsultation: scheduleConsultation,
                onNotNow: onTappedNotNow
            )
        }
        .fullScreenCover(isPresented: $showConsultNowScreen) {
            ConsultNowScreen()
        }
    }

    // MARK: - Actions

    /// RefillAlertView has now fully closed. If the user tapped
    /// "Consult Now" while it was open, present ConsultNowScreen next.
    private func handleRefillAlertDismiss() {
        guard pendingConsultNow else { return }
        pendingConsultNow = false

        // Small delay so the outgoing dismiss animation finishes before
        // the next fullScreenCover starts presenting.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showConsultNowScreen = true
        }
    }

    private func scheduleConsultation() {
        // TODO: navigate to your actual consultation booking flow
        pendingConsultNow = true
    }
}
