//
//  ProfileViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation



@MainActor
class ProfileViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var profileResponse: ProfileResponse? = nil
    @Published var errorMessage: String? = nil

    // MARK: - Fetch Profile

    func fetchProfile() {

        isLoading = true
        errorMessage = nil

        ProfileAPICaller.shared.fetchProfile { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.profileResponse = response

                print("✅ \(response.message)")
                print("👤 Name: \(response.data.name)")
                print("📧 Email: \(response.data.email)")
                print("📱 Phone: \(response.data.phone)")

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



