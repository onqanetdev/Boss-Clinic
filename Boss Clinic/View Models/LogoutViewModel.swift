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
 
    func logoutUser() {
 
        isLoading = true
 
        LogoutAPICaller.shared.logout { [weak self] result in
 
            guard let self else { return }
 
            self.isLoading = false
 
            switch result {
 
            case .success(let response):
                self.logoutResponse = response
 
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
 

