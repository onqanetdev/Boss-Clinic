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

   @StateObject private var viewModel = MedicationOverviewViewModel()

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // MARK: Title — fixed, never scrolls
                Text("Reminders")
                    .font(.custom("Inter24pt-Bold", size: 28))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                // MARK: Segmented control — fixed, never scrolls
                segmentedControl

                // MARK: Scrollable content area
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        Group {
                            if viewModel.isLoading {
                                ReminderListSkeleton()
                            } else if selectedTab == .upcoming {
                                upcomingList
                            } else {
                                historyList
                            }
                        }

                        Spacer(minLength: 40)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)   // ← the fix
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            loadData()
        }
        .navigationBarBackButtonHidden(true)
    }
   // MARK: - Upcoming List

   @ViewBuilder
   private var upcomingList: some View {

       if !viewModel.upcomingItems.isEmpty {

           LazyVStack(alignment: .leading, spacing: 28) {

               ForEach(viewModel.upcomingItems) { section in

                   VStack(alignment: .leading, spacing: 0) {

                       Text("\(section.day), \(section.date)")
                           .font(.custom("Inter18pt-SemiBold", size: 14))
                           .foregroundColor(.white)
                           .padding(.bottom, 14)

                       ForEach(Array(section.logs.enumerated()), id: \.element.id) { index, reminder in

                           UpcomingReminderRow(reminder: reminder)
                               .onAppear {

                                   let isLast = isLastUpcomingItem(section: section, index: index)

                                   if isLast {
                                       viewModel.fetchMedicationOverview(type: "upcoming", loadMore: true)
                                   }
                               }

                           if index < section.logs.count - 1 {

                               Divider()
                                   .background(Color.white.opacity(0.15))
                                   .padding(.vertical, 14)
                           }
                       }
                   }
               }

               if viewModel.isLoadingMoreUpcoming {
                   bottomLoader
               }
           }

       } else if !viewModel.isLoading {

           emptyState
       }
   }

   // MARK: - History List

   @ViewBuilder
   private var historyList: some View {

       if !viewModel.historyItems.isEmpty {

           LazyVStack(alignment: .leading, spacing: 18) {

               ForEach(Array(viewModel.historyItems.enumerated()), id: \.element.id) { index, reminder in

                   HistoryReminderRow(reminder: reminder)
                       .onAppear {

                           let isLast = isLastHistoryItem(index: index)
//                           print("👁️ history row appeared — id: \(reminder.id), index: \(index)/\(viewModel.historyItems.count - 1), isLastItem: \(isLast)")

                           if isLast {
                               viewModel.fetchMedicationOverview(type: "history", loadMore: true)
                           }
                       }

                   Divider()
                       .background(Color.white.opacity(0.15))
                       .padding(.vertical, 14)
               }

               if viewModel.isLoadingMoreHistory {
                   bottomLoader
               }
           }

       } else if !viewModel.isLoading {

           emptyState
       }
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

   // MARK: - Pagination triggers

   private func isLastUpcomingItem(section: UpcomingMedicationDate, index: Int) -> Bool {

       guard let lastSection = viewModel.upcomingItems.last else { return false }
       return section.date == lastSection.date && index == section.logs.count - 1
   }

   private func isLastHistoryItem(index: Int) -> Bool {
       return index == viewModel.historyItems.count - 1
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

                       guard selectedTab != tab else { return }

                       withAnimation(.easeInOut(duration: 0.2)) {
                           selectedTab = tab
                       }

                       if tab == .upcoming {

                           viewModel.resetUpcoming()
                           viewModel.fetchMedicationOverview(type: "upcoming")

                       } else {

                           viewModel.resetHistory()
                           viewModel.fetchMedicationOverview(type: "history")
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
       if viewModel.upcomingItems.isEmpty {
           viewModel.fetchMedicationOverview(type: "upcoming")
       }
   }
}

// MARK: - Rows

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
