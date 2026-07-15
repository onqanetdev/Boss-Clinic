//
//  ContactUsViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation


final class ContactUsViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var contactUsResponse: ContactUsModel?
    @Published var errorMessage: String?
    @Published var isMessageSent = false

    func sendMessage(
        name: String,
        email: String,
        message: String
    ) {

        isLoading = true
        errorMessage = nil
        isMessageSent = false

        ContactUsAPICaller.sendContactMessage(
            name: name,
            email: email,
            message: message
        ) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.contactUsResponse = response
                self.isMessageSent = true

                print("✅ Contact message sent successfully")
                print("👤 Name:", response.data.name)
                print("📧 Email:", response.data.email)

            case .failure(let error):

                if let networkError = error as? NetworkError {
                    self.errorMessage = networkError.errorDescription
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}



