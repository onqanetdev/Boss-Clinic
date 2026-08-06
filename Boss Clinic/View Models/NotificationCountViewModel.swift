//
//  NotificationCountViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 24/07/26.
//

import Foundation



final class NotificationCountViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var notificationCountResponse: NotificationCountResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW

    private let apiCaller = NotificationCountAPICaller.shared

    func fetchNotificationCount() {

        isLoading = true
        errorMessage = nil
        isOffline = false   // NEW

        apiCaller.fetchNotificationCount { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoading = false

                switch result {

                case .success(let response):

                    self.notificationCountResponse = response

                case .failure(let error):

                    //self.errorMessage = error.localizedDescription
                    if case .noInternet = error {      // NEW
                        self.isOffline = true
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}



