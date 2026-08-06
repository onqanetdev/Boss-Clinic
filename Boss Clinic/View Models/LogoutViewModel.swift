//
//  LogoutViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import Foundation



class LogoutViewModel: ObservableObject {
 
    @Published var isLoading = false
    @Published var logoutResponse: LogoutResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW
 
    func logoutUser() {
 
        isLoading = true
        isOffline = false   // NEW
 
        LogoutAPICaller.shared.logout { [weak self] result in
 
            guard let self else { return }
 
            self.isLoading = false
 
            switch result {
 
            case .success(let response):
                self.logoutResponse = response
 
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
 

