//
//  AppointmentListViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/08/26.
//

import Foundation


final class AppointmentListViewModel: ObservableObject {

    @Published var isLoading = false        // full-screen initial loader
    @Published var isLoadingMore = false    // bottom-of-list loader
    @Published var isRefreshing = false     // pull-to-refresh, no skeleton
    @Published var appointments: [Appointment] = []
    @Published var errorMessage: String?
    @Published var isOffline = false

    private var currentPage: Int = 1
    private var perPage: Int = 10
    private var isFetching = false

    // ⚠️ The sample response you shared has no "meta"/pagination block,
    // so there's no lastPage/total to check against. As a heuristic,
    // we assume there's a next page as long as the last fetch returned
    // a full page (count == perPage). If the API adds a meta object
    // later, swap this for the same pattern used in
    // MedicationListViewModel (currentPage < lastPage).
    private var hasMorePages: Bool = true

    /// `reset = true` → fresh load (page resets, array replaced).
    /// `reset = false` → load next page, appended to existing array.
    /// `isPullToRefresh = true` → skip the full-screen skeleton loader.
    func fetchAppointmentList(
        pageNumber: Int = 1,
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
            hasMorePages = true

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

        AppointmentListAPICaller.shared.fetchAppointmentList(page: currentPage, perPage: perPage) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false
            self.isLoadingMore = false
            self.isRefreshing = false
            self.isFetching = false

            switch result {

            case .success(let response):

                let newAppointments = response.data

                if reset {
                    self.appointments = newAppointments
                } else {
                    self.appointments.append(contentsOf: newAppointments)
                }

                // Heuristic: fewer items than perPage means we hit the end.
                self.hasMorePages = newAppointments.count == self.perPage

                print("✅ Appointment List Loaded — page: \(self.currentPage), newItems: \(newAppointments.count), total: \(self.appointments.count), hasMore: \(self.hasMorePages)")

            case .failure(let error):

                if case .noInternet = error {
                    self.isOffline = true
                } else {
                    self.errorMessage = error.localizedDescription
                }

                print("❌ Appointment List Error: \(error.localizedDescription)")
            }

            completion?()
        }
    }

    /// Call from each row's `.onAppear`, mirroring MedicationListViewModel's
    /// fetchNextPageIfNeeded pattern.
    func fetchNextPageIfNeeded(currentItem: Appointment) {

        guard let index = appointments.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let thresholdIndex = appointments.index(
            appointments.endIndex,
            offsetBy: -3,
            limitedBy: appointments.startIndex
        ) ?? appointments.startIndex

        if index >= thresholdIndex, hasMorePages, !isFetching {
            fetchAppointmentList(reset: false)
        }
    }

    @MainActor
    func refreshAppointmentList() async {
        await withCheckedContinuation { continuation in
            fetchAppointmentList(pageNumber: 1, perPageContent: perPage, reset: true, isPullToRefresh: true) {
                continuation.resume()
            }
        }
    }
}


