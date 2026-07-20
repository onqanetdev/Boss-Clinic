//
//  MedicationOverviewViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/07/26.
//

import Foundation



class MedicationOverviewViewModel: ObservableObject {

    @Published var isLoading = false

    @Published var upcomingResponse: UpcomingMedicationResponse?
    @Published var historyResponse: MedicationHistoryResponse?

    @Published var errorMessage: String?

    func fetchMedicationOverview(
        type: String,
        page: Int = 1,
        perPage: Int = 10
    ) {

        isLoading = true
        errorMessage = nil

        MedicationOverviewAPICaller.shared.fetchMedicationOverview(
            type: type,
            page: page,
            perPage: perPage
        ) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                if let history = response as? MedicationHistoryResponse {

                    self.historyResponse = history

                } else if let upcoming = response as? UpcomingMedicationResponse {

                    self.upcomingResponse = upcoming
                }

            case .failure(let error):

                switch error {

                case .validationError(let message):
                    self.errorMessage = message

                default:
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


