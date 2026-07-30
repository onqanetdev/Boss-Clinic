//
//  MedicationOverviewViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/07/26.
//

import Foundation



class MedicationOverviewViewModel: ObservableObject {

   // MARK: - Accumulated (paginated) data shown on screen
   // These are the "temporary arrays" that keep growing as the user
   // scrolls and Load More pages get appended.

   @Published var upcomingItems: [UpcomingMedicationDate] = []
   @Published var historyItems: [MedicationHistory] = []

   // MARK: - Loading states

   @Published var isLoading: Bool = false            // full-screen skeleton, first page only
   @Published var isLoadingMoreUpcoming: Bool = false // bottom loader - upcoming
   @Published var isLoadingMoreHistory: Bool = false  // bottom loader - history

   // MARK: - Pagination tracking

   private var upcomingCurrentPage = 1
   private var historyCurrentPage = 1

   private(set) var hasMoreUpcoming = true
   private(set) var hasMoreHistory = true

   private let perPage = 10

   // MARK: - Fetch

   /// - Parameters:
   ///   - type: "upcoming" or "history"
   ///   - loadMore: pass true when triggered by reaching the bottom of the list.
   ///     Pass false (default) for the very first load / tab switch.
   func fetchMedicationOverview(type: String, loadMore: Bool = false) {

       print("🟡 fetchMedicationOverview CALLED — type: \(type), loadMore: \(loadMore)")

       if type == "upcoming" {

           if loadMore {
               guard hasMoreUpcoming, !isLoadingMoreUpcoming else {
                   print("🔴 upcoming loadMore BLOCKED — hasMoreUpcoming: \(hasMoreUpcoming), isLoadingMoreUpcoming: \(isLoadingMoreUpcoming)")
                   return
               }
           } else if isLoading {
               print("🔴 upcoming initial load BLOCKED — isLoading already true")
               return
           }

       } else {

           if loadMore {
               guard hasMoreHistory, !isLoadingMoreHistory else {
                   print("🔴 history loadMore BLOCKED — hasMoreHistory: \(hasMoreHistory), isLoadingMoreHistory: \(isLoadingMoreHistory)")
                   return
               }
           } else if isLoading {
               print("🔴 history initial load BLOCKED — isLoading already true")
               return
           }
       }

       let nextPage: Int

       if type == "upcoming" {
           nextPage = loadMore ? upcomingCurrentPage + 1 : 1
       } else {
           nextPage = loadMore ? historyCurrentPage + 1 : 1
       }

       print("🟢 fetchMedicationOverview PROCEEDING — type: \(type), requesting page: \(nextPage), perPage: \(perPage)")

       if loadMore {
           if type == "upcoming" {
               isLoadingMoreUpcoming = true
           } else {
               isLoadingMoreHistory = true
           }
       } else {
           isLoading = true
       }

       MedicationOverviewAPICaller.shared.fetchMedicationOverview(
           type: type,
           page: nextPage,
           perPage: perPage
       ) { [weak self] result in

           guard let self = self else { return }

           DispatchQueue.main.async {

               self.isLoading = false
               self.isLoadingMoreUpcoming = false
               self.isLoadingMoreHistory = false

               switch result {

               case .success(let response):
                   print("✅ fetchMedicationOverview SUCCESS — type: \(type), page: \(nextPage)")
                   self.handleSuccess(type: type, page: nextPage, response: response)

               case .failure(let error):
                   print("❌ MEDICATION OVERVIEW FETCH ERROR — type: \(type), page: \(nextPage), error: \(error)")
               }
           }
       }
   }

   // MARK: - Handle Success

   private func handleSuccess(type: String, page: Int, response: Any) {

       if type == "history" {

           guard let historyResponse = response as? MedicationHistoryResponse else { return }

           historyCurrentPage = page
           hasMoreHistory = historyResponse.data.meta.currentPage < historyResponse.data.meta.lastPage

           if page == 1 {
               historyItems = historyResponse.data.history
           } else {
               historyItems.append(contentsOf: historyResponse.data.history)
           }

           print("📊 history — page: \(page), currentPage: \(historyResponse.data.meta.currentPage), lastPage: \(historyResponse.data.meta.lastPage), newItems: \(historyResponse.data.history.count), totalOnScreen: \(historyItems.count), hasMoreHistory: \(hasMoreHistory)")

       } else {

           guard let upcomingResponse = response as? UpcomingMedicationResponse else { return }

           upcomingCurrentPage = page
           hasMoreUpcoming = upcomingResponse.data.meta.currentPage < upcomingResponse.data.meta.lastPage

           if page == 1 {
               upcomingItems = upcomingResponse.data.dates
           } else {
               upcomingItems = mergeUpcomingDates(existing: upcomingItems, new: upcomingResponse.data.dates)
           }

           let newLogCount = upcomingResponse.data.dates.reduce(0) { $0 + $1.logs.count }
           let totalLogCount = upcomingItems.reduce(0) { $0 + $1.logs.count }
           print("📊 upcoming — page: \(page), currentPage: \(upcomingResponse.data.meta.currentPage), lastPage: \(upcomingResponse.data.meta.lastPage), newLogs: \(newLogCount), totalLogsOnScreen: \(totalLogCount), hasMoreUpcoming: \(hasMoreUpcoming)")
       }
   }

   // MARK: - Merge helper

   // Upcoming data is grouped by date. If page 2 returns logs for a date
   // that's already on screen, its logs get appended to that section
   // instead of creating a duplicate date header.
   private func mergeUpcomingDates(
       existing: [UpcomingMedicationDate],
       new: [UpcomingMedicationDate]
   ) -> [UpcomingMedicationDate] {

       var merged = existing

       for newSection in new {

           if let index = merged.firstIndex(where: { $0.date == newSection.date }) {

               let existingSection = merged[index]
               let combinedLogs = existingSection.logs + newSection.logs

               merged[index] = UpcomingMedicationDate(
                   date: existingSection.date,
                   day: existingSection.day,
                   total: existingSection.total,
                   logs: combinedLogs
               )

           } else {

               merged.append(newSection)
           }
       }

       return merged
   }

   // MARK: - Reset (e.g. pull-to-refresh or tab re-selection)

   func resetUpcoming() {
       upcomingItems = []
       upcomingCurrentPage = 1
       hasMoreUpcoming = true
   }

   func resetHistory() {
       historyItems = []
       historyCurrentPage = 1
       hasMoreHistory = true
   }
}
