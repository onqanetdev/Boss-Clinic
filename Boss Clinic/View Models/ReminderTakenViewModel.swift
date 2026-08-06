//
//  ReminderTakenViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/07/26.
//

import Foundation



final class ReminderTakenViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var reminderTakenResponse: MedicationTakenResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW
    
    
    private let apiCaller = ReminderTakenAPICaller.shared

    func markReminderAsTaken(
        medicationID: String,
        time: String,
        scheduledDate: String
    ) {

        isLoading = true
        errorMessage = nil
        isOffline = false   // NEW

        apiCaller.markReminderAsTaken(
            medicationID: medicationID,
            time: time,
            scheduledDate: scheduledDate
        ) { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoading = false

                switch result {

                case .success(let response):

                    self.reminderTakenResponse = response

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


