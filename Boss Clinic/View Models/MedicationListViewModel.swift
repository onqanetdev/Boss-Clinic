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
    @Published var isRefreshing = false     // pull-to-refresh, no skeleton
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
    /// `isPullToRefresh = true` → skip the full-screen skeleton loader.
    func fetchMedicationList(
        pageNumber: Int = 0,
        perPageContent: Int = 10,
        reset: Bool = true,
        isPullToRefresh: Bool = false,
        completion: (() -> Void)? = nil
    ) {

        guard !isFetching else {
            completion?()
            return
        }

        if reset {
            currentPage = pageNumber
            perPage = perPageContent

            if isPullToRefresh {
                isRefreshing = true
            } else {
                isLoading = true
            }
        } else {
            guard hasMorePages else {
                completion?()
                return
            }
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
            self.isRefreshing = false
            self.isFetching = false

            switch result {

            case .success(let response):

                self.lastPage = response.data.meta.lastPage
                self.currentPage = response.data.meta.currentPage

                let newMedications = response.data.medications

                if reset {
                    self.medications = newMedications
                } else {
                    self.medications.append(contentsOf: newMedications)
                }

                print("✅ Medication List Loaded Successfully")

            case .failure(let error):

                if case .noInternet = error {
                    self.isOffline = true
                } else {
                    self.errorMessage = error.localizedDescription
                }

                print("❌ Medication List Error: \(error.localizedDescription)")
            }

            completion?()
        }
    }

    /// Call from each row's `.onAppear`.
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

    @MainActor
    func refreshMedicationList() async {
        await withCheckedContinuation { continuation in
            fetchMedicationList(pageNumber: 0, perPageContent: 10, reset: true, isPullToRefresh: true) {
                continuation.resume()
            }
        }
    }
}
