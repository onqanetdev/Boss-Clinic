//
//  AppointmentReminderView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 11/08/26.
//

import SwiftUI


struct AppointmentReminderView: View {
    let reminder: AppointmentReminder
    var onDismiss: () -> Void = {}
 
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
 
            // Card — rounded rect with a visible border, inset from the
            // screen edges, matching the reference screenshot.
            VStack(spacing: 0) {
                // Close (X) — top trailing
                HStack {
                    Spacer()
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
 
                Spacer()
 
                // Icon badge — dark circle, white icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 132, height: 132)
 
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 52, weight: .regular))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 32)
 
                // Title — bold, 2-line centered
                Text("Upcoming Appointment")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 20)
 
                // Notification body — shown in place of the old
                // doctor/date/time detail block, since the body text is
                // always fully composed server-side (doctor_name can
                // arrive empty depending on which appointment event fired).
                if !reminder.bodyMessage.isEmpty {
                    Text(reminder.bodyMessage)
                        .font(.system(size: 17))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 40)
                } else {
                    // Fallback if body text wasn't available for some
                    // reason — reconstruct from the structured fields.
                    VStack(spacing: 8) {
                        if !reminder.doctorName.isEmpty {
                            Text(reminder.doctorName)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        if !reminder.appointmentDate.isEmpty {
                            Text(reminder.appointmentDate)
                                .font(.system(size: 17))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        if !reminder.appointmentTime.isEmpty {
                            Text("Time: \(reminder.appointmentTime)")
                                .font(.system(size: 17))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                    }
                    .padding(.bottom, 40)
                }
 
                Spacer()
 
                // Single action now that "View Details" is removed —
                // solid white pill, matches "Take Now" / "Refill Now" /
                // "Get Started" throughout the app.
                Button {
                    onDismiss()
                } label: {
                    Text("Dismiss")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 60)
        }
    }
}
 
#Preview {
    AppointmentReminderView(
        reminder: AppointmentReminder(
            id: "b1d3aa44-6bce-4c27-9d02-4d2ce630c9b3",
            doctorName: "",
            appointmentDate: "2026-08-11",
            appointmentTime: "17:29",
            bodyMessage: "Your appointment Scheduled at (Tuesday, August 11, 2026 at 17:29)."
        )
    )
}
