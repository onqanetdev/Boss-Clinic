//
//  LoginViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation


@MainActor
class LoginViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var otpResponse: OTPResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var isOTPSent: Bool = false

    var loginReqModel = LoginReqModel(phone: "")

    // MARK: - Login API

    func loginUser(loginReqModel: LoginReqModel) {

        isLoading = true
        errorMessage = nil

        LoginAPICaller.shared.loginUser(phone: loginReqModel.phone) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.otpResponse = response
                self.isOTPSent = true

                print("✅ \(response.message)")
                print("📱 Phone: \(response.data.phone)")
                print("🔐 OTP: \(response.data.otp)")

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



