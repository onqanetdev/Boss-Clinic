//
//  NotificationReadViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 27/07/26.
//

import Foundation


final class NotificationReadViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var notificationReadResponse: NotificationReadResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW

    private let apiCaller = NotificationReadAPICaller.shared

    func markNotificationAsRead(notificationID: String) {

        isLoading = true
        errorMessage = nil

        apiCaller.markNotificationAsRead(
            notificationID: notificationID
        ) { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoading = false

                switch result {

                case .success(let response):

                    self.notificationReadResponse = response

                case .failure(let error):

                   // self.errorMessage = error.localizedDescription
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



