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
 

 
// MARK: - Screen
 
struct NotificationScreen: View {
 
    private enum ReminderTab: String, CaseIterable {
        case upcoming = "Upcoming"
        case history = "History"
    }
 
    @State private var selectedTab: ReminderTab = .upcoming
 
    // TODO: Replace with real data from your view model / API

    
    @StateObject private var viewModel = MedicationOverviewViewModel()
    
    @State private var upcomingMedicalData: UpcomingMedicationResponse?
    @State private var historyMedicalData: MedicationHistoryResponse?
    
 
    var body: some View {

        ZStack{
            
            Color.black
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
     
                    // MARK: Title
                    Text("Reminders")
                        .font(.custom("Inter24pt-Bold", size: 28))
                        .foregroundColor(.white)
                        .padding(.top, 20)
     
                    // MARK: Segmented control
                    segmentedControl
     
                    
                    Group {
                        if selectedTab == .upcoming {

                            if let upcoming = upcomingMedicalData,
                               !upcoming.data.dates.isEmpty {

                                VStack(alignment: .leading, spacing: 28) {

                                    ForEach(upcoming.data.dates) { section in

                                        VStack(alignment: .leading, spacing: 0) {

                                            Text("\(section.day), \(section.date)")
                                                .font(.custom("Inter18pt-SemiBold", size: 14))
                                                .foregroundColor(.white)
                                                .padding(.bottom, 14)

                                            ForEach(Array(section.logs.enumerated()), id: \.element.id) { index, reminder in

                                                UpcomingReminderRow(reminder: reminder)

                                                if index < section.logs.count - 1 {

                                                    Divider()
                                                        .background(Color.white.opacity(0.15))
                                                        .padding(.vertical, 14)
                                                }
                                            }
                                        }
                                    }
                                }

                            } else {

                                emptyState
                            }

                        } else {

                            if let history = historyMedicalData,
                               !history.data.history.isEmpty {

                                VStack(alignment: .leading, spacing: 18) {

                                    ForEach(history.data.history) { reminder in

                                        HistoryReminderRow(reminder: reminder)

                                        Divider()
                                            .background(Color.white.opacity(0.15))
                                            .padding(.vertical, 14)
                                    }
                                }

                            } else {

                                emptyState
                            }
                        }
                    }
                    
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
            
            
            
            if viewModel.isLoading {

                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.4)
            }
            
        }
        .onAppear {
            loadData()
        }

        .onChange(of: viewModel.upcomingResponse) { response in
            upcomingMedicalData = response
        }

        .onChange(of: viewModel.historyResponse) { response in
            historyMedicalData = response
        }
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

                        if tab == .upcoming {

                            if upcomingMedicalData == nil {
                                viewModel.fetchMedicationOverview(type: "upcoming")
                            }

                        } else {

                            if historyMedicalData == nil {
                                viewModel.fetchMedicationOverview(type: "history")
                            }
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
    
    private func loadData() {
        viewModel.fetchMedicationOverview(type: "upcoming")
    }
}
 
// MARK: - Row
 



//MARK: Updated Rows and Columns

struct UpcomingReminderRow: View {

    let reminder: UpcomingMedication

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

                Text(reminder.strength)
                    .font(.custom("Inter18pt-Regular", size: 10))
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Text("Upcoming")
                .font(.custom("Inter18pt-Regular", size: 10))
                .foregroundColor(.white.opacity(0.75))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3))
                )
        }
    }
}


struct HistoryReminderRow: View {

    let reminder: MedicationHistory

    var body: some View {

        HStack(alignment: .top, spacing: 13) {

            Text(reminder.scheduledTime)
                .font(.custom("Inter18pt-SemiBold", size: 10))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)

            Rectangle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 1)

            VStack(alignment: .leading, spacing: 4) {

                Text(reminder.medication.name)
                    .font(.custom("Inter18pt-SemiBold", size: 12))
                    .foregroundColor(.white)

                Text(reminder.medication.dose)
                    .font(.custom("Inter18pt-Regular", size: 10))
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Text(reminder.status.capitalized)
                .font(.custom("Inter18pt-Regular", size: 10))
                .foregroundColor(.white.opacity(0.75))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3))
                )
        }
    }
}



 
#Preview {
    NavigationStack {
        NotificationScreen()
    }
}

