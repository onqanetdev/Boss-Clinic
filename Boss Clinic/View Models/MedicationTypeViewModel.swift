//
//  MedicationTypeViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/10/26.
//

import Foundation




class MedicationTypeViewModel: ObservableObject {

    // Types
    @Published var medicationTypes: [MedicationTypeOption] = []
    @Published var isLoading = false

    // Frequencies
    @Published var medicationFrequencies: [MedicationTypeOption] = []
    @Published var isLoadingFrequencies = false

    @Published var isOffline = false
    @Published var errorMessage: String?

    private let apiCaller = MedicationTypeAPICaller()

    // MARK: - Types

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
                self.handle(error)
            }
        }
    }

    // MARK: - Frequencies

    func fetchMedicationFrequencies() {

        guard !isLoadingFrequencies else { return }

        isLoadingFrequencies = true
        isOffline = false
        errorMessage = nil

        apiCaller.fetchMedicationFrequencies { [weak self] result in
            guard let self = self else { return }

            self.isLoadingFrequencies = false

            switch result {
            case .success(let response):
                self.medicationFrequencies = response.data
            case .failure(let error):
                self.handle(error)
            }
        }
    }

    // MARK: - Error handling

    private func handle(_ error: Error) {
        if case MedicationTypeAPIError.offline = error {
            isOffline = true
        } else {
            errorMessage = error.localizedDescription
        }
    }
}

