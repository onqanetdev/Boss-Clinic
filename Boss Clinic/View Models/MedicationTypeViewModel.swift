//
//  MedicationTypeViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/10/26.
//

import Foundation




class MedicationTypeViewModel: ObservableObject {

    @Published var medicationTypes: [MedicationTypeOption] = []
    @Published var isLoading = false
    @Published var isOffline = false
    @Published var errorMessage: String?

    private let apiCaller = MedicationTypeAPICaller()

    func fetchMedicationTypes() {

        guard !isLoading else { return }

        isLoading = true
        isOffline = false
        errorMessage = nil

        apiCaller.fetchMedicationTypes { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let response):
                self.medicationTypes = response.data

            case .failure(let error):
                if case MedicationTypeAPIError.offline = error {
                    self.isOffline = true
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

