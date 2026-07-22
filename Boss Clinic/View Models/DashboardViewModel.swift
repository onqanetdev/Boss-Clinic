//
//  DashboardViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation



final class DashboardViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var dashboardResponse: DashboardResponse?
    @Published var errorMessage: String?

    func fetchDashboard() {

        isLoading = true
        errorMessage = nil

        DashboardAPICaller.shared.fetchDashboard { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.dashboardResponse = response

                print("✅ Dashboard Loaded Successfully")
                print("📄 Message: \(response.message)")
                print("💊 Next Medication: \(response.data.nextMedication?.name ?? "No Medication name Found")")
                print("📅 Today's Schedule Count: \(response.data.todaySchedule.count)")
                print("🔔 Refill Reminder Count: \(response.data.refillReminders.count)")

            case .failure(let error):

                self.errorMessage = error.localizedDescription

                print("❌ Dashboard Error")
                print(error.localizedDescription)
            }
        }
    }
}

