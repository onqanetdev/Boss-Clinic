//
//  MedicationListViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation



final class MedicationListViewModel: ObservableObject {

    @Published var isLoading = false        // full-screen initial loader
    @Published var isLoadingMore = false    // bottom-of-list loader
    @Published var medications: [ActiveMedication] = []
    @Published var errorMessage: String?
    @Published var isOffline = false

    private var currentPage: Int = 0
    private var lastPage: Int = 1
    private var perPage: Int = 10
    private var isFetching = false

    var hasMorePages: Bool {
        currentPage < lastPage
    }

    /// `reset = true` → fresh load (page resets, array replaced).
    /// `reset = false` → load next page, appended to existing array.
    func fetchMedicationList(pageNumber: Int = 0, perPageContent: Int = 10, reset: Bool = true) {

        guard !isFetching else { return }

        if reset {
            currentPage = pageNumber
            perPage = perPageContent
            isLoading = true
        } else {
            guard hasMorePages else { return }
            currentPage += 1
            isLoadingMore = true
        }

        isFetching = true
        errorMessage = nil
        isOffline = false

        MedicationListAPICaller.shared.fetchMedicationList(page: currentPage, perPage: perPage) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false
            self.isLoadingMore = false
            self.isFetching = false

            switch result {

            case .success(let response):

                self.lastPage = response.data.meta.lastPage
                self.currentPage = response.data.meta.currentPage

                // temporary array holding the newly fetched page
                let newMedications = response.data.medications

                if reset {
                    self.medications = newMedications
                } else {
                    self.medications.append(contentsOf: newMedications)
                }

                print("✅ Medication List Loaded Successfully")
              //  print("💊 Total Medications Now: \(self.medications.count)")

            case .failure(let error):

                if case .noInternet = error {
                    self.isOffline = true
                } else {
                    self.errorMessage = error.localizedDescription
                }

                print("❌ Medication List Error: \(error.localizedDescription)")
            }
        }
    }

    /// Call from each row's `.onAppear`. Triggers the next page once the
    /// user scrolls near the end of the currently loaded list.
    func fetchNextPageIfNeeded(currentItem: ActiveMedication) {

        guard let index = medications.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let thresholdIndex = medications.index(
            medications.endIndex,
            offsetBy: -3,
            limitedBy: medications.startIndex
        ) ?? medications.startIndex

        if index >= thresholdIndex, hasMorePages, !isFetching {
            fetchMedicationList(reset: false)
        }
    }
}
