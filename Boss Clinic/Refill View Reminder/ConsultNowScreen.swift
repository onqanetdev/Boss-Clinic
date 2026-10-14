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
    @State private var showSuccessPopup = false

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
                            //status: "scheduled",
                            reason: reason
                        )
                    } label: {
                        Group {
                            if consultVM.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            } else {
                                Text("Request Appointment")
                                    .font(.custom("Inter18pt-SemiBold", size: 16))
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

                    // MARK: Request info note
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.45))
                            .padding(.top, 1)

                        Text("This is an appointment request. Our team will contact you to arrange and confirm your booking.")
                            .font(.custom("Inter18pt-Regular", size: 12))
                            .foregroundColor(.white.opacity(0.45))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
            
            // MARK: Success popup
            if showSuccessPopup {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)

                successPopup
                    .padding(.horizontal, 28)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            
        }
        .onChange(of: consultVM.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .onChange(of: consultVM.appointmentResponse) { response in
            guard response != nil else { return }
            NotificationCenter.default.post(name: .appointmentCreated, object: nil)
            withAnimation(.easeInOut(duration: 0.2)) {
                showSuccessPopup = true
            }
        }
        .alert("No Internet Connection", isPresented: $showOfflineAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
    }
    
    // MARK: - Success popup

    private var successPopup: some View {
        VStack(spacing: 16) {

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 72, height: 72)

                Image(systemName: "checkmark")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.green)
            }
            .padding(.top, 4)

            Text("Request Sent")
                .font(.custom("Inter24pt-Bold", size: 22))
                .foregroundColor(.white)

            Text("Your appointment request has been sent. You'll be notified once the clinic confirms it.")
                .font(.custom("Inter18pt-Regular", size: 14))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showSuccessPopup = false
                }
                dismiss()
            } label: {
                Text("Done")
                    .font(.custom("Inter18pt-SemiBold", size: 16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                    )
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color(red: 0.11, green: 0.11, blue: 0.11))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.4), radius: 20, y: 10)
    }
}

#Preview {
    ConsultNowScreen()
}
