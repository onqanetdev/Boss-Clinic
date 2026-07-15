//
//  TermsConditionViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation


class TermsConditionViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var termsConditionResponse: TermsConditionModel?
    @Published var errorMessage: String?

    func fetchTermsCondition() {

        isLoading = true
        errorMessage = nil

        TermsConditionAPICaller.fetchTermsCondition { [weak self] result in

            guard let self = self else { return }

            // ⬇️ Critical: completion may fire on a background queue —
            // always hop to main before touching @Published state.
            DispatchQueue.main.async {

                self.isLoading = false

                switch result {

                case .success(let response):
                    self.termsConditionResponse = response
                    print("✅ Terms & Condition Loaded Successfully")
                    print("📄 Title:", response.data.title)

                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
}
