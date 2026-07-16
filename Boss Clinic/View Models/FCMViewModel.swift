//
//  FCMViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation



final class FCMViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var fcmResponse: FCMModel?
    @Published var errorMessage: String?
    @Published var isFCMTokenSaved = false
    
    func saveFCMToken(_ token: String) {
        
        isLoading = true
        errorMessage = nil
        isFCMTokenSaved = false
        
        FCMAPICaller.shared.saveFCMToken(fcmToken: token) { [weak self] result in
            
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
                
            case .success(let response):
                self.fcmResponse = response
                self.isFCMTokenSaved = true
                print("✅ API Success")
                print(response.message)
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

