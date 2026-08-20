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

private struct HistorySection: Identifiable {
    let id: String          // scheduledDate, used as a stable key
    let headerLabel: String // "Day, Date" — same style as upcoming
    let items: [MedicationHistory]
}




// MARK: - Screen

struct NotificationScreen: View {

   private enum ReminderTab: String, CaseIterable {
       case upcoming = "Upcoming"
       case history = "History"
   }

   @State private var selectedTab: ReminderTab = .upcoming

   @StateObject private var viewModel = MedicationOverviewViewModel()
    
    @State private var showOfflineAlert = false

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

            LazyVStack(alignment: .leading, spacing: 28) {

                ForEach(groupedHistory) { section in

                    VStack(alignment: .leading, spacing: 0) {

                        Text(section.headerLabel)
                            .font(.custom("Inter18pt-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .padding(.bottom, 14)

                        ForEach(Array(section.items.enumerated()), id: \.element.id) { index, reminder in

                            HistoryReminderRow(reminder: reminder)
                                .onAppear {

                                    let isLast = isLastHistoryItem(section: section, index: index)

                                    if isLast {
                                        viewModel.fetchMedicationOverview(type: "history", loadMore: true)
                                    }
                                }

                            if index < section.items.count - 1 {

                                Divider()
                                    .background(Color.white.opacity(0.15))
                                    .padding(.vertical, 14)
                            }
                        }
                    }
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

    
    
    private var groupedHistory: [HistorySection] {

        // Preserves API order and groups items sharing the same scheduledDate
        // under one header — same visual result as upcoming's pre-grouped `dates`.
        var order: [String] = []
        var buckets: [String: [MedicationHistory]] = [:]

        for item in viewModel.historyItems {

            let key = item.scheduledDate

            if buckets[key] == nil {
                buckets[key] = []
                order.append(key)
            }
            buckets[key]?.append(item)
        }

        return order.map { key in

            let items = buckets[key] ?? []

            // Prefer the day/date fields the API already sends per-item
            // (matches upcoming's "day" + "date"); fall back to the raw
            // scheduledDate string if they're missing.
            let day = items.first?.day
            let date = items.first?.date ?? key

            let headerLabel: String = {
                if let day, !day.isEmpty {
                    return "\(day), \(date)"
                }
                return date
            }()

            return HistorySection(id: key, headerLabel: headerLabel, items: items)
        }
    }
    
    
   // MARK: - Pagination triggers

   private func isLastUpcomingItem(section: UpcomingMedicationDate, index: Int) -> Bool {

       guard let lastSection = viewModel.upcomingItems.last else { return false }
       return section.date == lastSection.date && index == section.logs.count - 1
   }

    private func isLastHistoryItem(section: HistorySection, index: Int) -> Bool {

        guard let lastSection = groupedHistory.last else { return false }
        return section.id == lastSection.id && index == section.items.count - 1
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
                           //print("The day is: ", viewModel.historyItems[0].date)
                          // print("The Date is: ", viewModel.historyItems[0].day)
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
       // Always reset to the Upcoming tab on appear
           selectedTab = .upcoming

           // Always clear any existing upcoming state and refetch fresh
           viewModel.resetUpcoming()
           viewModel.fetchMedicationOverview(type: "upcoming")
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

               Text(reminder.medication?.name ?? "Unknown medication")
                   .font(.custom("Inter18pt-SemiBold", size: 12))
                   .foregroundColor(.white)

               Text(reminder.medication?.dose ?? "-")
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
