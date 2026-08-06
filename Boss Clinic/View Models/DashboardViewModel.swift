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
    @Published var isOffline = false   // NEW: drive a distinct offline UI

    func fetchDashboard() {

        isLoading = true
        errorMessage = nil
        isOffline = false

        DashboardAPICaller.shared.fetchDashboard { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.dashboardResponse = response

                print("✅ Dashboard Loaded Successfully")

            case .failure(let error):

                if case .noInternet = error {
                    self.isOffline = true
                } else {
                    self.errorMessage = error.localizedDescription
                }

                print("❌ Dashboard Error: \(error)")
            }
        }
    }
}


