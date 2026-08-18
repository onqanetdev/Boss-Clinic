//
//  NotificationViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import Foundation



final class NotificationViewModel: ObservableObject {

    @Published var isLoading = false        // full-screen initial loader
    @Published var isLoadingMore = false    // small loader at bottom of list
    @Published var notifications: [NotificationItem] = []
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false

    @Published var pageNo: Int = 0
    @Published var perPagecontent: Int = 10

    private var currentPage: Int = 0
    private var lastPage: Int = 1
    private var isFetching = false

    var hasMorePages: Bool {
        currentPage < lastPage
    }

    /// `reset = true` → fresh load (page resets, array replaced).
    /// `reset = false` → load next page, appended to existing array.
    func fetchNotifications(reset: Bool = true) {

        guard !isFetching else { return }

        if reset {
            currentPage = pageNo
            isLoading = true
        } else {
            guard hasMorePages else { return }
            currentPage += 1
            isLoadingMore = true
        }

        isFetching = true
        errorMessage = nil
        isOffline = false

        NotificationAPICaller.shared.fetchNotifications(page: currentPage, perPage: perPagecontent) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false
            self.isLoadingMore = false
            self.isFetching = false

            switch result {

            case .success(let response):

                self.lastPage = response.data.meta.lastPage
                self.currentPage = response.data.meta.currentPage

                if reset {
                    self.notifications = response.data.notifications
                } else {
                    self.notifications.append(contentsOf: response.data.notifications)
                }

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
                    self.errorMessage = "No Internet Connection."
                }
            }
        }
    }

    /// Call this from each row's `.onAppear`. Triggers the next page
    /// once the user scrolls near the end of the currently loaded list.
    func fetchNextPageIfNeeded(currentItem: NotificationItem) {

        guard let index = notifications.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let thresholdIndex = notifications.index(
            notifications.endIndex,
            offsetBy: -3,
            limitedBy: notifications.startIndex
        ) ?? notifications.startIndex

        if index >= thresholdIndex, hasMorePages, !isFetching {
            fetchNotifications(reset: false)
        }
    }
}



