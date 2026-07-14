//
//  VerifyOTPViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation


@MainActor
class VerifyOTPViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var loginResponse: LoginResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoginSuccessful: Bool = false

    var verifyOTPReqModel = VerifyOTPReqModel(
        phone: "",
        otp: ""
    )

    // MARK: - Verify OTP API

    func verifyOTP(verifyOTPReqModel: VerifyOTPReqModel) {

        isLoading = true
        errorMessage = nil

        VerifyOTPAPICaller.shared.verifyOTP(
            phone: verifyOTPReqModel.phone,
            otp: verifyOTPReqModel.otp
        ) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.loginResponse = response
                self.isLoginSuccessful = true

                print("✅ \(response.message)")
                print("👤 User: \(response.data.user.name)")
                print("🔑 Token: \(response.data.token)")

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



