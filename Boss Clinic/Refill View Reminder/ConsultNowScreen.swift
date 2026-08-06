//
//  ConsultNowScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 31/07/26.
//

import Foundation
import SwiftUI

struct ConsultNowScreen: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var consultVM = ConsultNowViewModel()

    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var reason = ""

    private var isFormValid: Bool {
        !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @State private var showOfflineAlert = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
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
                    .padding(.bottom, 20)

                    // MARK: Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 100, height: 100)

                        Image(systemName: "calendar.badge.clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)

                    // MARK: Title
                    Text("Schedule Consultation")
                        .font(.custom("Inter24pt-Bold", size: 26))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)

                    Text("Pick a date and time that works for you.")
                        .font(.custom("Inter18pt-Regular", size: 15))
                        .foregroundColor(Color.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 28)

                    // MARK: Date
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Date")
                            .font(.custom("Inter18pt-SemiBold", size: 15))
                            .foregroundColor(.white.opacity(0.6))

                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .colorScheme(.dark)
                        .accentColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 18)

                    // MARK: Time
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Time")
                            .font(.custom("Inter18pt-SemiBold", size: 15))
                            .foregroundColor(.white.opacity(0.6))

                        DatePicker(
                            "",
                            selection: $selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .colorScheme(.dark)
                        .accentColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 18)

                    // MARK: Reason
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Reason for consultation")
                            .font(.custom("Inter18pt-SemiBold", size: 15))
                            .foregroundColor(.white.opacity(0.6))

                        ZStack(alignment: .topLeading) {
                            if reason.isEmpty {
                                Text("Briefly describe why you'd like to consult…")
                                    .font(.custom("Inter18pt-Regular", size: 15))
                                    .foregroundColor(.white.opacity(0.35))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 14)
                            }

                            TextEditor(text: $reason)
                                .font(.custom("Inter18pt-Regular", size: 15))
                                .foregroundColor(.white)
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .frame(height: 130)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 32)

                    // MARK: Book button
                    Button {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"

                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm"

                        consultVM.createAppointment(
                            appointmentDate: dateFormatter.string(from: selectedDate),
                            appointmentTime: timeFormatter.string(from: selectedTime),
                            status: "scheduled",
                            reason: reason
                        )
                    } label: {
                        Group {
                            if consultVM.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            } else {
                                Text("Book Appointment")
                                    .font(.custom("Inter18pt-SemiBold", size: 17))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isFormValid ? Color.white : Color.white.opacity(0.4))
                        )
                    }
                    .disabled(!isFormValid || consultVM.isLoading)
                    .padding(.bottom, 14)

                    // MARK: Cancel
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.custom("Inter18pt-SemiBold", size: 17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
        .onChange(of: consultVM.appointmentResponse) { response in
            guard response != nil else { return }
            dismiss()
        }
        
        .onChange(of: consultVM.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .alert("No Internet Connection", isPresented: $showOfflineAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
    }
}

#Preview {
    ConsultNowScreen()
}
