//
//  AppointmentListScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/08/26.
//

import SwiftUI

struct AppointmentListScreen: View {

    @StateObject private var viewModel = AppointmentListViewModel()

    @State private var showOfflineAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // MARK: Back button + Title — inline, fixed, never scrolls
                HStack(spacing: 16) {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }

                    Text("Appointments")
                        .font(.custom("Inter24pt-Bold", size: 28))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)

                // MARK: Scrollable content area
                ScrollView(showsIndicators: false) {

                    VStack(alignment: .leading, spacing: 24) {

                        Group {
                            if viewModel.isLoading {
                                AppointmentListSkeleton()
                            } else {
                                appointmentList
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer(minLength: 40)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .refreshable {
                    await viewModel.refreshAppointmentList()
                }
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: viewModel.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .alert("No Internet Connection", isPresented: $showOfflineAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
        .navigationBarBackButtonHidden(true)
    }
        
    

    // MARK: - Appointment List (grouped by date)

    @ViewBuilder
    private var appointmentList: some View {

        if !viewModel.appointments.isEmpty {

            LazyVStack(alignment: .leading, spacing: 28) {

                ForEach(groupedAppointments) { section in

                    VStack(alignment: .leading, spacing: 12) {

                        Text(section.headerLabel)
                            .font(.custom("Inter18pt-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .padding(.bottom, 4)

                        ForEach(section.items) { appointment in

                            AppointmentRow(appointment: appointment)
                                .onAppear {
                                    viewModel.fetchNextPageIfNeeded(currentItem: appointment)
                                }
                        }
                    }
                }

                if viewModel.isLoadingMore {
                    bottomLoader
                }
            }

        } else if !viewModel.isLoading {

            emptyState
        }
    }

    // MARK: - Grouping helper

    private struct AppointmentSection: Identifiable {
        let id: String            // raw "dd-MM-yyyy" date, used as stable key
        let headerLabel: String   // "Wednesday, 19 August 2026"
        let items: [Appointment]
    }

    private var groupedAppointments: [AppointmentSection] {

        var order: [String] = []
        var buckets: [String: [Appointment]] = [:]

        for item in viewModel.appointments {

            let key = item.appointmentDate

            if buckets[key] == nil {
                buckets[key] = []
                order.append(key)
            }
            buckets[key]?.append(item)
        }

        return order.map { key in

            let items = buckets[key] ?? []

            return AppointmentSection(
                id: key,
                headerLabel: formattedHeader(for: key),
                items: items
            )
        }
    }

    /// Parses the API's "dd-MM-yyyy" date string into a friendly
    /// "Weekday, d MMMM yyyy" header, matching the style of the
    /// Reminders screen's day/date section headers.
    private func formattedHeader(for rawDate: String) -> String {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"

        guard let date = inputFormatter.date(from: rawDate) else {
            return rawDate  // fallback: show the raw string if parsing fails
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, d MMMM yyyy"

        return outputFormatter.string(from: date)
    }

    // MARK: - Bottom loader

    private var bottomLoader: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            Spacer()
        }
        .padding(.vertical, 16)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 8) {

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 72, height: 72)

                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.bottom, 4)

            Text("No appointments yet")
                .font(.custom("Inter18pt-SemiBold", size: 16))
                .foregroundColor(.white)

            Text("Your booked appointments will show up here.")
                .font(.custom("Inter18pt-Regular", size: 14))
                .foregroundColor(Color.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    // MARK: - Load

    private func loadData() {
        viewModel.fetchAppointmentList(pageNumber: 1, perPageContent: 10, reset: true)
    }
}

// MARK: - Row

struct AppointmentRow: View {

    let appointment: Appointment

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            // MARK: Time + Status — top row
            HStack(alignment: .top) {

                Text(displayTime)
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(.white)

                Spacer()

                Text(statusLabel)
                    .font(.custom("Inter18pt-Regular", size: 11))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(statusColor.opacity(0.5))
                    )
            }

            // MARK: Reason — labeled so it reads as "why", not a title
            VStack(alignment: .leading, spacing: 4) {

                Text("Reason for appointment")
                    .font(.custom("Inter18pt-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.4))
                    .textCase(.uppercase)

                Text(appointment.reason)
                    .font(.custom("Inter18pt-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }

//            Divider()
//                .background(Color.white.opacity(0.1))

            // MARK: Patient — labeled with an icon, not a bare name
//            HStack(spacing: 8) {
//
//                Image(systemName: "person.fill")
//                    .font(.system(size: 11))
//                    .foregroundColor(.white.opacity(0.4))
//
//                Text("Patient")
//                    .font(.custom("Inter18pt-Regular", size: 12))
//                    .foregroundColor(.white.opacity(0.4))
//
//                Text(appointment.username)
//                    .font(.custom("Inter18pt-SemiBold", size: 12))
//                    .foregroundColor(.white.opacity(0.75))
//            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }

    // Strips seconds off "17:25:00" → "17:25" for display.
    private var displayTime: String {
        String(appointment.appointmentTime.prefix(5))
    }

    private var statusLabel: String {
        appointment.status.rawValue.capitalized
    }

    private var statusColor: Color {
        switch appointment.status {
        case .scheduled:
            return .white.opacity(0.75)
        case .rescheduled:
            return .orange
        case .completed:
            return .green
        case .cancelled:
            return .red
        }
    }
}

// MARK: - Skeleton

struct AppointmentListSkeleton: View {

    var body: some View {

        VStack(alignment: .leading, spacing: 28) {

            ForEach(0..<3, id: \.self) { _ in

                VStack(alignment: .leading, spacing: 14) {

                    shimmerBlock(width: 140, height: 14)

                    ForEach(0..<3, id: \.self) { _ in

                        HStack(spacing: 13) {
                            shimmerBlock(width: 50, height: 10)
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 1, height: 32)

                            VStack(alignment: .leading, spacing: 6) {
                                shimmerBlock(width: 120, height: 12)
                                shimmerBlock(width: 80, height: 10)
                            }

                            Spacer()

                            shimmerBlock(width: 70, height: 22, cornerRadius: 8)
                        }
                        .padding(.bottom, 14)
                    }
                }
            }
        }
        .redacted(reason: .placeholder)
    }

    private func shimmerBlock(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 4) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white.opacity(0.12))
            .frame(width: width, height: height)
    }
}

#Preview {
    NavigationStack {
        AppointmentListScreen()
    }
}
