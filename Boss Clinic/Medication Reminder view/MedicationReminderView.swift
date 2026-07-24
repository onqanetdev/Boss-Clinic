//
//  MedicationReminderView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 09/07/26.
//

import SwiftUI

struct MedicationReminderView: View {
 
    let reminder: DoseReminder
    var onTakeNow: () -> Void = {}
    var onSnooze: () -> Void = {}
 
    @Environment(\.dismiss) private var dismiss
 
    @StateObject private var reminderTakenVM = ReminderTakenViewModel()
 
    // Auto-dismiss countdown
    @State private var remainingSeconds: Int = 10 * 60 // 10 minutes
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
 
            VStack(spacing: 0) {
 
                // MARK: Close button
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
 
                // MARK: Title
                Text("Time to take your\nmedication")
                    .font(.custom("Inter24pt-Bold", size: 26))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 36)
 
                // MARK: Bell icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 120, height: 120)
 
                    Image(systemName: "bell.and.waves.left.and.right.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 32)
 
                // MARK: Medication details
                VStack(spacing: 8) {
                    Text(reminder.medicationName)
                        .font(.custom("Inter24pt-Bold", size: 22))
                        .foregroundColor(.white)
 
                    if !reminder.dosageText.isEmpty {
                        Text(reminder.dosageText)
                            .font(.custom("Inter18pt-Regular", size: 17))
                            .foregroundColor(Color.white.opacity(0.6))
                    }
 
                    if !reminder.scheduledTime.isEmpty {
                        Text("Time: \(reminder.scheduledTime)")
                            .font(.custom("Inter18pt-Regular", size: 17))
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                .padding(.bottom, 40)
 
                // MARK: Take Now
                Button {
                    markAsTaken()
                } label: {
                    Text("Take Now")
                        .font(.custom("Inter18pt-SemiBold", size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white)
                        )
                }
                .disabled(reminderTakenVM.isLoading)
                .padding(.bottom, 14)
 
                // MARK: Snooze
                Button {
                    onSnooze()
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                        Text("Snooze")
                    }
                    .font(.custom("Inter18pt-SemiBold", size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .disabled(reminderTakenVM.isLoading)
                .padding(.bottom, 20)
 
                // MARK: Auto-dismiss countdown
                Text("Dismiss \(dismissLabel)")
                    .font(.custom("Inter18pt-Regular", size: 14))
                    .foregroundColor(Color.white.opacity(0.4))
            }
            .padding(.horizontal, 28)
            .padding(.top, 24)
            .padding(.bottom, 32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 20)
 
            // MARK: Loader
            if reminderTakenVM.isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
 
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .onReceive(timer) { _ in
            guard remainingSeconds > 0 else {
                dismiss()
                return
            }
            remainingSeconds -= 1
        }
        .onChange(of: reminderTakenVM.reminderTakenResponse) { response in
            guard response != nil else { return }
 
            onTakeNow()
            dismiss()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { reminderTakenVM.errorMessage != nil },
                set: { _ in reminderTakenVM.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(reminderTakenVM.errorMessage ?? "")
        }
    }
 
    private var dismissLabel: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        if minutes > 0 {
            return "\(minutes) min"
        }
        return "\(seconds)s"
    }
 
    private func markAsTaken() {
 
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
 
        reminderTakenVM.markReminderAsTaken(
            medicationID: reminder.id,
            time: reminder.scheduledTime,
            scheduledDate: today
        )
    }
}
 
#Preview {
    MedicationReminderView(
        reminder: DoseReminder(
            id: "1",
            medicationName: "Amoxicillin 500 mg",
            dosageText: "1 Tablet",
            scheduledTime: "10:00 AM"
        )
    )
}
