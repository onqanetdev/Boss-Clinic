//
//  ConsultNowViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 31/07/26.
//

import Foundation



final class ConsultNowViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var appointmentResponse: BookAppointmentResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW

    private let apiCaller = ConsultNowAPICaller.shared

    func createAppointment(
        appointmentDate: String,
        appointmentTime: String,
        status: String,
        reason: String
    ) {

        isLoading = true
        errorMessage = nil

        apiCaller.createAppointment(
            appointmentDate: appointmentDate,
            appointmentTime: appointmentTime,
            status: status,
            reason: reason
        ) { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoading = false

                switch result {

                case .success(let response):

                    self.appointmentResponse = response

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

