//
//  EditProfileViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation




@MainActor
class EditProfileViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var profileEditResponse: ProfileEditModel? = nil
    @Published var errorMessage: String? = nil
    @Published var isProfileUpdated: Bool = false

    // MARK: - Update Profile

    func updateProfile(
        name: String,
        gender: String,
        phoneReceived: String,
        address: String
    ) {

        isLoading = true
        errorMessage = nil
        isProfileUpdated = false

        EditProfileAPICaller.shared.updateProfile(
            name: name,
            gender: gender,
            address: address,
            phone: phoneReceived
            
        ) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.profileEditResponse = response
                self.isProfileUpdated = true

                print("✅ \(response.message)")
                print("👤 Name: \(response.data.name)")
                print("📧 Email: \(response.data.email)")

            case .failure(let error):

                switch error {

                case .validationError(let message):
                    self.errorMessage = message

                default:
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


