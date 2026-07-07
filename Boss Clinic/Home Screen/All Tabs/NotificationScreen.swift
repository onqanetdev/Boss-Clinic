//
//  NotificationScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 30/06/26.
//

import SwiftUI
 
// MARK: - Models
 
enum ReminderStatus: String {
    case upcoming = "Upcoming"
    case taken = "Taken"
    case missed = "Missed"
}
 
struct MedicationReminder: Identifiable {
    let id = UUID()
    let time: String
    let medicationName: String
    let subtitle: String
    let status: ReminderStatus
}
 
struct ReminderDaySection: Identifiable {
    let id = UUID()
    let dateLabel: String
    let reminders: [MedicationReminder]
}
 
// MARK: - Screen
 
struct NotificationScreen: View {
 
    private enum ReminderTab: String, CaseIterable {
        case upcoming = "Upcoming"
        case history = "History"
    }
 
    @State private var selectedTab: ReminderTab = .upcoming
 
    // TODO: Replace with real data from your view model / API
    private let upcomingSections: [ReminderDaySection] = [
        ReminderDaySection(dateLabel: "Today, May 20", reminders: [
            MedicationReminder(time: "10:00 AM", medicationName: "Amoxicillin 500 mg", subtitle: "1 Tablet • Everyday", status: .upcoming),
            MedicationReminder(time: "1:00 PM", medicationName: "Metformin 500 mg", subtitle: "1 Tablet • Everyday", status: .upcoming),
            MedicationReminder(time: "6:00 PM", medicationName: "Atorvastatin 20 mg", subtitle: "1 Tablet • Everyday", status: .upcoming)
        ]),
        ReminderDaySection(dateLabel: "Tomorrow, May 21", reminders: [
            MedicationReminder(time: "8:00 AM", medicationName: "Lisinopril 10 mg", subtitle: "1 Tablet • Everyday", status: .upcoming)
        ])
    ]
    
    //private let upcomingSections: [ReminderDaySection] = []
 
    // TODO: Replace with real past-reminder data
    private let historySections: [ReminderDaySection] = []
 
    private var visibleSections: [ReminderDaySection] {
        selectedTab == .upcoming ? upcomingSections : historySections
    }
 
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
 
                // MARK: Title
                Text("Reminders")
                    .font(.custom("Inter24pt-Bold", size: 28))
                    .foregroundColor(.white)
                    .padding(.top, 20)
 
                // MARK: Segmented control
                segmentedControl
 
                // MARK: Sections
                if visibleSections.isEmpty {
                    emptyState
                } else {
                    VStack(alignment: .leading, spacing: 28) {
                        ForEach(visibleSections) { section in
                            VStack(alignment: .leading, spacing: 0) {
                                Text(section.dateLabel)
                                    .font(.custom("Inter18pt-SemiBold", size: 14))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 14)
 
                                ForEach(Array(section.reminders.enumerated()), id: \.element.id) { index, reminder in
                                    ReminderRow(reminder: reminder)
 
                                    if index < section.reminders.count - 1 {
                                        Divider()
                                            .background(Color.white.opacity(0.15))
                                            .padding(.vertical, 14)
                                    }
                                }
                            }
                        }
                    }
                }
 
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
 
    // MARK: - Segmented control
 
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(ReminderTab.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(selectedTab == tab ? .white : Color.white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.15))
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
    }
 
    // MARK: - Empty state
 
    private var emptyState: some View {
        VStack(spacing: 8) {
            Text(selectedTab == .upcoming ? "No upcoming reminders" : "No history yet")
                .font(.custom("Inter18pt-SemiBold", size: 16))
                .foregroundColor(.white)
 
            Text(selectedTab == .upcoming
                 ? "You're all caught up for now."
                 : "Completed reminders will show up here.")
                .font(.custom("Inter18pt-Regular", size: 14))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
 
// MARK: - Row
 
private struct ReminderRow: View {
 
    let reminder: MedicationReminder
 
    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Text(reminder.time)
                .font(.custom("Inter18pt-SemiBold", size: 10))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)
 
            Rectangle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 1)
 
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.medicationName)
                    .font(.custom("Inter18pt-SemiBold", size: 12))
                    .foregroundColor(.white)
 
                Text(reminder.subtitle)
                    .font(.custom("Inter18pt-Regular", size: 10))
                    .foregroundColor(Color.white.opacity(0.5))
            }
 
            Spacer()
 
            statusPill
        }
    }
 
    private var statusPill: some View {
        Text(reminder.status.rawValue)
            .font(.custom("Inter18pt-Regular", size: 10))
            .foregroundColor(Color.white.opacity(0.75))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}
 
#Preview {
    NavigationStack {
        NotificationScreen()
    }
}

