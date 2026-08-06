//
//  PrivacyViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation


class PrivacyViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var privacyResponse: PrivacyModel?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW

    // MARK: - Fetch Privacy Policy

    func fetchPrivacyPolicy() {

        isLoading = true
        errorMessage = nil
        isOffline = false   // NEW

        PrivacyAPICaller.fetchPrivacyPolicy { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.privacyResponse = response

                print("✅ Privacy Policy Loaded Successfully")
                print("📄 Title:", response.data.title)

            case .failure(let error):

                if case .noInternet = error {      // NEW
                    self.isOffline = true
                } else {
                    self.errorMessage = error.errorDescription
                }
                
            }
        }
    }
}



