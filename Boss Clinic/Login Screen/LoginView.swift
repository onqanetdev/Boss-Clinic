//
//  LoginView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import SwiftUI
import FirebaseMessaging


struct LoginView: View {
 
    /// Called once OTP verification succeeds and a token has been saved.
    var onLoginSuccess: () -> Void
 
    @State private var phone = ""
    @State private var otp = ""
 
    @State private var showOTPField = false
    @State private var isPhoneEditable = true
    @State private var showPhoneError = false
 
    @StateObject private var loginVM = LoginViewModel()
    @StateObject private var verifyOTPVM = VerifyOTPViewModel()
    @StateObject private var fcmVM = FCMViewModel()
 
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
 
                Text("Phone")
                    .font(.custom("Inter18pt-SemiBold", size: 16))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 10)
 
                CustomTextField(
                    text: $phone,
                    placeholder: "Enter your phone",
                    prefixImage: "telephone",
                    keyboardType: .phonePad,
                    textContentType: .telephoneNumber
                )
                .disabled(!isPhoneEditable)
                .onChange(of: phone) { newValue in
                    phone = String(newValue.filter(\.isNumber).prefix(10))
                }
                .padding(.bottom, 10)
 
                if showPhoneError {
                    Text("Phone number must be 10 digits.")
                        .font(.custom("Inter18pt-Regular", size: 12))
                        .foregroundColor(.red)
                }
 
                Spacer()
                    .frame(height: 10)
 
                if showOTPField {
 
                    Text("OTP(\(loginVM.otpResponse?.data.otp ?? "No OTPr"))")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 10)
 
                    CustomTextField(
                        text: $otp,
                        placeholder: "Enter the OTP",
                        prefixImage: "password",
                        keyboardType: .numberPad,
                        textContentType: .oneTimeCode
                    )
                    .padding(.bottom, 10)
                }
 
                PrimaryButton(title: showOTPField ? "Verify OTP" : "Submit") {
                    handlePrimaryButtonTap()
                }
                .padding(.top, 20)
            }
 
            // Loader Overlay
            if loginVM.isLoading || verifyOTPVM.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
 
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
        .onChange(of: loginVM.isOTPSent) { success in
            if success {
                withAnimation {
                    showOTPField = true
                    isPhoneEditable = false
                }
            }
        }
        .onChange(of: verifyOTPVM.isLoginSuccessful) { success in
            guard success else { return }

            if let token = verifyOTPVM.loginResponse?.data.token {

                UserDefaults.standard.set(token, forKey: "accessToken")
                print("✅ Access Token Saved")

                if let fcmToken = Messaging.messaging().fcmToken {

                    print("📲 FCM Token: \(fcmToken)")
                    fcmVM.saveFCMToken(fcmToken)

                } else {

                    print("⚠️ FCM Token not available.")
                }
            }

            onLoginSuccess()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { verifyOTPVM.errorMessage != nil },
                set: { _ in verifyOTPVM.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(verifyOTPVM.errorMessage ?? "")
        }
    }
 
    private func handlePrimaryButtonTap() {
        if !showOTPField {
 
            guard phone.count == 10 else {
                showPhoneError = true
                return
            }
 
            showPhoneError = false
 
            let request = LoginReqModel(phone: phone)
            loginVM.loginUser(loginReqModel: request)
 
        } else {
 
            let request = VerifyOTPReqModel(
                phone: phone,
                otp: otp
            )
 
            verifyOTPVM.verifyOTP(verifyOTPReqModel: request)
        }
    }
}

//#Preview {
//    LoginView()
//}
