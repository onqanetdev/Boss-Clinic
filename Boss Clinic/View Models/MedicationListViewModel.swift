//
//  MedicationListViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation


final class MedicationListViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var medicationResponse: ActiveMedicationResponse?
    @Published var errorMessage: String?

    func fetchMedicationList() {

        isLoading = true
        errorMessage = nil

        MedicationListAPICaller.shared.fetchMedicationList { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.medicationResponse = response

                print("✅ Medication List Loaded Successfully")
                print("💊 Total Medications: \(response.data.count)")

            case .failure(let error):

                self.errorMessage = error.localizedDescription

                print("❌ Medication List Error: \(error.localizedDescription)")
            }
        }
    }
}


