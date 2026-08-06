//
//  NewsletterViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 03/08/26.
//

import Foundation





final class NewsletterViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var newsletterResponse: NewsletterResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW

    private let apiCaller = NewsletterAPICaller.shared

    func fetchNewsletters() {

        isLoading = true
        errorMessage = nil
        isOffline = false   // NEW

        apiCaller.fetchNewsletters { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.isLoading = false

                switch result {

                case .success(let response):

                    self.newsletterResponse = response

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

