//
//  AppointmentListScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/08/26.
//

import SwiftUI


struct AppointmentListScreen: View {

    @StateObject private var viewModel = AppointmentListViewModel()
    @StateObject private var statusViewModel = AppointmentStatusViewModel()

    @State private var showOfflineAlert = false
    @State private var showActionErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var showConsultNowScreen = false

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // MARK: Back button + Title + Add button — inline, fixed, never scrolls
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
                        .font(.custom("Inter24pt-Bold", size: 24))
                        .foregroundColor(.white)

                    Spacer()

                    Button {
                        print("Add appointment tapped")
                        // TODO: Hook up navigation to the "create appointment" flow.
                        showConsultNowScreen = true
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
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
        .fullScreenCover(isPresented: $showConsultNowScreen) {
            ConsultNowScreen()
        }
        .onReceive(NotificationCenter.default.publisher(for: .appointmentCreated)) { _ in
            loadData()
        }
        .onAppear {
            loadData()
        }
        .onChange(of: viewModel.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .onChange(of: statusViewModel.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .onChange(of: statusViewModel.errorMessage) { message in
            if message != nil {
                showActionErrorAlert = true
            }
        }
        .alert("No Internet Connection", isPresented: $showOfflineAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
        .alert("Something Went Wrong", isPresented: $showActionErrorAlert) {
            Button("OK", role: .cancel) {
                statusViewModel.errorMessage = nil
            }
        } message: {
            Text(statusViewModel.errorMessage ?? "Please try again.")
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

                            AppointmentRow(
                                appointment: appointment,
                                isUpdating: statusViewModel.isUpdating,
                                onConfirm: {
                                    confirmAppointment(appointment)
                                },
                                onCancel: {
                                    cancelAppointment(appointment)
                                },
                                onReschedule: { notes, date, time in
                                    rescheduleAppointment(appointment, notes: notes, date: date, time: time)
                                },
                                onRequestCall: {
                                    requestCall(for: appointment)
                                }
                            )
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

    // MARK: - Row actions
    //
    // NOTE: `viewModel.isLoading = true` fires immediately on tap so the
    // skeleton appears right away, rather than only after the action's own
    // network call (confirm/cancel/reschedule/call) finishes. `loadData()`
    // still runs afterward to fetch the real refreshed list. This assumes
    // `isLoading` is a settable `@Published var` on AppointmentListViewModel
    // — if it's `private(set)`, this needs a small setter method there instead.

    private func confirmAppointment(_ appointment: Appointment) {
        viewModel.isLoading = true
        statusViewModel.updateStatus(appointmentId: appointment.id, type: .confirm) { _ in
            loadData()
        }
    }

    private func cancelAppointment(_ appointment: Appointment) {
        viewModel.isLoading = true
        statusViewModel.updateStatus(appointmentId: appointment.id, type: .cancel) { _ in
            loadData()
        }
    }

    private func rescheduleAppointment(_ appointment: Appointment, notes: String, date: Date, time: Date) {

        viewModel.isLoading = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        statusViewModel.updateStatus(
            appointmentId: appointment.id,
            type: .reschedule,
            notes: notes,
            newAppointmentDate: dateFormatter.string(from: date),
            newAppointmentTime: timeFormatter.string(from: time)
        ) { _ in
            loadData()
        }
    }

    private func requestCall(for appointment: Appointment) {
        viewModel.isLoading = true
        statusViewModel.updateStatus(appointmentId: appointment.id, type: .call) { _ in
            loadData()
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

    /// Parses the API's "yyyy-MM-dd" date string into a friendly
    /// "Weekday, d MMMM yyyy" header, matching the style of the
    /// Reminders screen's day/date section headers.
    private func formattedHeader(for rawDate: String) -> String {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

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
    var isUpdating: Bool = false

    var onConfirm: () -> Void = {}
    var onCancel: () -> Void = {}
    var onReschedule: (String, Date, Date) -> Void = { _, _, _ in }
    var onRequestCall: () -> Void = {}

    private enum RowAction {
        case confirm
        case cancel
        case reschedule
    }

    @State private var selectedAction: RowAction? = nil
    @State private var notesText: String = ""
    @State private var rescheduleDate: Date = Date()
    @State private var rescheduleTime: Date = Date()
    @State private var showRescheduleModal = false
    @State private var showDatePopover = false
    @FocusState private var notesFieldFocused: Bool

    // Confirmation alert state — Confirm and Cancel both require a
    // second tap before their callback actually fires.
    @State private var pendingConfirmationAction: RowAction? = nil
    @State private var showActionAlert = false
    @State private var callRequested = false

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

            // MARK: Existing notes — only shown when the API actually has one
            if let existingNotes {
                VStack(alignment: .leading, spacing: 4) {

                    Text("Notes")
                        .font(.custom("Inter18pt-Regular", size: 11))
                        .foregroundColor(.white.opacity(0.4))
                        .textCase(.uppercase)

                    Text(existingNotes)
                        .font(.custom("Inter18pt-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            // MARK: Row actions — Cancel / Confirm / Reschedule
            if showsActionRow {

                HStack(spacing: 10) {

                    actionButton(
                        title: "Cancel",
                        color: .red,
                        isSelected: selectedAction == .cancel
                    ) {
                        print("Appointment ID: \(appointment.id)")
                        selectedAction = .cancel
                        notesFieldFocused = false
                        pendingConfirmationAction = .cancel
                        showActionAlert = true
                    }

                    actionButton(
                        title: "Confirm",
                        color: .green,
                        isSelected: selectedAction == .confirm
                    ) {
                        print("Appointment ID: \(appointment.id)")
                        selectedAction = .confirm
                        notesFieldFocused = false
                        pendingConfirmationAction = .confirm
                        showActionAlert = true
                    }

                    actionButton(
                        title: "Reschedule",
                        color: .orange,
                        isSelected: showRescheduleModal
                    ) {
                        print("Appointment ID: \(appointment.id)")
                        notesFieldFocused = false
                        showRescheduleModal = true
                    }
                }
                .disabled(isUpdating)
            }

            requestCallButton
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
        .animation(.easeInOut(duration: 0.2), value: selectedAction)
        .alert(alertTitle, isPresented: $showActionAlert) {
            Button("Yes", role: pendingConfirmationAction == .cancel ? .destructive : nil) {
                handleAlertConfirmed()
            }
            Button("No", role: .cancel) {
                handleAlertDismissed()
            }
        }
        .fullScreenCover(isPresented: $showRescheduleModal) {
            rescheduleModal
                .presentationBackground(.clear)
        }
    }

    // MARK: - Confirmation alert

    private var alertTitle: String {
        switch pendingConfirmationAction {
        case .confirm:
            return "Are you sure want to confirm this?"
        case .cancel:
            return "Are you want to cancel this appointment?"
        case .reschedule, .none:
            return ""
        }
    }

    private func handleAlertConfirmed() {
        print("Appointment ID: \(appointment.id)")
        switch pendingConfirmationAction {
        case .confirm:
            onConfirm()
        case .cancel:
            onCancel()
        case .reschedule, .none:
            break
        }
        pendingConfirmationAction = nil
    }

    // User tapped "No" — back out of the selected state entirely.
    private func handleAlertDismissed() {
        selectedAction = nil
        pendingConfirmationAction = nil
    }

    // MARK: - Request a call button

    private var requestCallButton: some View {
        Button {
            print("Appointment ID: \(appointment.id)")
            callRequested = true
            onRequestCall()
        } label: {
            HStack(spacing: 8) {

                Image(systemName: callRequested ? "checkmark.circle.fill" : "phone.fill")
                    .font(.system(size: 12))

                Text(callRequested ? "We'll call you shortly" : "I want a call from clinic")
                    .font(.custom("Inter18pt-SemiBold", size: 12))
            }
            .foregroundColor(callRequested ? .green : .white.opacity(0.85))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(callRequested)
    }

    // MARK: - Reschedule modal (date, time, notes)

    private var trimmedNotes: String {
        notesText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var dateDisplayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }

    private var rescheduleModal: some View {
        ZStack {

            Color.black.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture {
                    showRescheduleModal = false
                }

            VStack(alignment: .leading, spacing: 18) {

                // MARK: Header — title + close button
                HStack {
                    Text("Reschedule Appointment")
                        .font(.custom("Inter18pt-SemiBold", size: 18))
                        .foregroundColor(.white)

                    Spacer()

                    Button {
                        showRescheduleModal = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(Color.white.opacity(0.08)))
                    }
                }

                // MARK: New date
                VStack(alignment: .leading, spacing: 6) {

                    Text("New Date")
                        .font(.custom("Inter18pt-Regular", size: 11))
                        .foregroundColor(.white.opacity(0.4))
                        .textCase(.uppercase)

                    Button {
                        showDatePopover = true
                    } label: {
                        Text(dateDisplayFormatter.string(from: rescheduleDate))
                            .font(.custom("Inter18pt-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange.opacity(0.4), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showDatePopover) {
                        VStack(spacing: 0) {

                            DatePicker(
                                "",
                                selection: $rescheduleDate,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .tint(.orange)
                            .padding()
                            .onChange(of: rescheduleDate) { _ in
                                // Auto-dismiss the calendar as soon as a date is picked,
                                // rather than requiring the person to close it manually.
                                showDatePopover = false
                            }

                            Spacer()
                        }
                        .presentationDetents([.height(420)])
                        .presentationDragIndicator(.visible)
                        .background(Color.black.ignoresSafeArea())
                    }
                }

                // MARK: New time
                VStack(alignment: .leading, spacing: 6) {

                    Text("New Time")
                        .font(.custom("Inter18pt-Regular", size: 11))
                        .foregroundColor(.white.opacity(0.4))
                        .textCase(.uppercase)

                    DatePicker(
                        "",
                        selection: $rescheduleTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .tint(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange.opacity(0.4), lineWidth: 1)
                    )
                }

                // MARK: Notes
                VStack(alignment: .leading, spacing: 6) {

                    Text("Notes")
                        .font(.custom("Inter18pt-Regular", size: 11))
                        .foregroundColor(.white.opacity(0.4))
                        .textCase(.uppercase)

                    ZStack(alignment: .topLeading) {

                        if notesText.isEmpty {
                            Text("Add a reason for this reschedule…")
                                .font(.custom("Inter18pt-Regular", size: 13))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                        }

                        TextEditor(text: $notesText)
                            .focused($notesFieldFocused)
                            .font(.custom("Inter18pt-Regular", size: 13))
                            .foregroundColor(.white.opacity(0.9))
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .frame(height: 70)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange.opacity(0.4), lineWidth: 1)
                    )
                }

                // MARK: Save
                HStack {
                    Spacer()

                    Button {
                        guard !trimmedNotes.isEmpty else { return }
                        print("Appointment ID: \(appointment.id)")
                        notesFieldFocused = false
                        onReschedule(trimmedNotes, rescheduleDate, rescheduleTime)
                        notesText = ""
                        showRescheduleModal = false
                    } label: {
                        Text("Save")
                            .font(.custom("Inter18pt-SemiBold", size: 13))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(trimmedNotes.isEmpty ? Color.orange.opacity(0.4) : Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(trimmedNotes.isEmpty)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.09, green: 0.09, blue: 0.09))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Action button

    private func actionButton(
        title: String,
        color: Color,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {
            Text(title)
                .font(.custom("Inter18pt-SemiBold", size: 12))
                .foregroundColor(isSelected ? .black : color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? color : Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.opacity(0.6), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    // Only show the existing-notes block when the API actually sent one.
    private var existingNotes: String? {
        guard let notes = appointment.notes else { return nil }
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    // Actions stay available for anything that isn't a final state.
    private var showsActionRow: Bool {
        appointment.status != .completed && appointment.status != .cancelled
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
        case .called:
            return .blue
        case .confirmed:
            return .green
        case .unknown:
            return .white.opacity(0.4)
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
