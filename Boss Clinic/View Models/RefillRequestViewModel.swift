//
//  RefillRequestViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import Foundation



final class RefillRequestViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var refillRequestResponse: RefillRequestResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW

    func requestRefill(
        medicationID: String,
        schedule: String
    ) {

        isLoading = true
        errorMessage = nil
        isOffline = false   // NEW

        RefillRequestAPICaller.shared.requestRefill(
            medicationID: medicationID,
            schedule: schedule
        ) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.refillRequestResponse = response

            case .failure(let error):

                switch error {

                case .validationError(let message):
                    self.errorMessage = message

                case .urlError:
                    self.errorMessage = "Invalid URL."

                case .serverError:
                    self.errorMessage = "Server error. Please try again."

                case .decodingError:
                    self.errorMessage = "Failed to decode response."

                case .responsErr:
                    self.errorMessage = "Invalid response from the server."

                case .unauthorized:
                    self.errorMessage = "Your session has expired. Please log in again."
                case .noInternet:
                    self.errorMessage = "No Internet Connection"
                }
            }
        }
    }
}


