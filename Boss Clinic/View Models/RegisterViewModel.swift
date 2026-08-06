//
//  RegisterViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation



@MainActor
class RegisterViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var registerResponse: RegisterResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var isRegistrationSuccessful: Bool = false
    @Published var isOffline: Bool = false   // NEW
    
    var registerReqModel = RegisterReqModel(
        name: "",
        email: "",
        phone: "",
        //password: "",
        //confirmPassword: ""
    )
    
    // MARK: - Register API
    
    func registerNewUser(registerReqModel: RegisterReqModel) {
        
        self.isLoading = true
        self.errorMessage = nil
        self.isOffline = false   // NEW
        
        RegisterAPICaller.shared.registerUser(
            name: registerReqModel.name,
            email: registerReqModel.email,
            phone: registerReqModel.phone,
        ) { [weak self] result in
            
            guard let self else { return }
            
            self.isLoading = false
            
            switch result {
                
            case .success(let response):
                
                self.registerResponse = response
                self.isRegistrationSuccessful = true
                
                print("✅ \(response.message)")
                
            case .failure(let error):
                
                switch error {
                    
                case .noInternet:            // NEW
                    self.isOffline = true
                    
                case .validationError(let message):
                    self.errorMessage = message
                    
                default:
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


