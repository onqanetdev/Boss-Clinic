//
//  SignUpView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import SwiftUI
import FirebaseMessaging



struct SignUpView: View {
 
    /// Called once registration AND OTP verification succeed.
    var onSignUpSuccess: () -> Void
 
    @State private var fullName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var otp = ""
 
    @State private var signUpPhoneError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
 
    /// Once registration succeeds, we swap the form for an OTP entry step.
    @State private var showOTPField = false
 
    @StateObject private var registerVM = RegisterViewModel()
    @StateObject private var verifyOTPVM = VerifyOTPViewModel()
 
    @StateObject private var fcmVM = FCMViewModel()
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
 
                if showOTPField {
 
                    // MARK: OTP
                    Text("OTP")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 5)
 
                    Text("We've sent a code to \(phone). OTP is \(registerVM.registerResponse?.data.otp ?? "No OTP")")
                        .font(.custom("Inter18pt-Regular", size: 12))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 5)
 
                    CustomTextField(
                        text: $otp,
                        placeholder: "Enter the OTP",
                        prefixImage: "password",
                        keyboardType: .numberPad,
                        textContentType: .oneTimeCode
                    )
                    .padding(.bottom, 20)
 
                    PrimaryButton(title: "Verify OTP") {
                        handleVerifyOTPTap()
                    }
                    .padding(.top, 20)
 
                } else {
 
                    // MARK: Full Name
                    Text("Full Name")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 5)
 
                    CustomTextField(
                        text: $fullName,
                        placeholder: "Enter your full name",
                        prefixImage: "user"
                    )
                    .padding(.bottom, 5)
 
                    // MARK: Phone
                    Text("Phone")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 5)
 
                    CustomTextField(
                        text: $phone,
                        placeholder: "Enter your phone",
                        prefixImage: "telephone",
                        keyboardType: .phonePad,
                        textContentType: .telephoneNumber
                    )
                    .onChange(of: phone) { newValue in
                        phone = String(newValue.filter(\.isNumber).prefix(10))
                    }
                    .padding(.bottom, 5)
 
                    if let signUpPhoneError {
                        Text(signUpPhoneError)
                            .font(.custom("Inter18pt-Regular", size: 12))
                            .foregroundColor(.red)
                            .padding(.top, 2)
                    }
 
                    // MARK: Email
                    Text("Email")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 5)
 
                    CustomTextField(
                        text: $email,
                        placeholder: "Enter your email",
                        prefixImage: "mailbox",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress
                    )
                    .padding(.bottom, 5)
 
                    if let emailError {
                        Text(emailError)
                            .font(.custom("Inter18pt-Regular", size: 12))
                            .foregroundColor(.red)
                            .padding(.top, 2)
                    }
 
                    PrimaryButton(title: "Sign Up") {
                        handleSignUpTap()
                    }
                    .padding(.top, 20)
                }
            }
 
            // Loader Overlay
            if registerVM.isLoading || verifyOTPVM.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
 
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
        .onChange(of: registerVM.isRegistrationSuccessful) { success in
            if success {
                withAnimation {
                    showOTPField = true
                }
            }
        }
        .onChange(of: verifyOTPVM.isLoginSuccessful) { success in
            guard success else { return }

            if let token = verifyOTPVM.loginResponse?.data.token {

                UserDefaults.standard.set(token, forKey: "accessToken")
                UserDefaults.standard.set(verifyOTPVM.loginResponse?.data.user.name, forKey: "loginUserName")
                print("✅ Access Token Saved")

                if let fcmToken = Messaging.messaging().fcmToken {

                    print("📲 FCM Token: \(fcmToken)")
                    fcmVM.saveFCMToken(fcmToken)

                } else {

                    print("⚠️ FCM Token not available.")
                }
            }

            onSignUpSuccess()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { registerVM.errorMessage != nil },
                set: { _ in registerVM.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(registerVM.errorMessage ?? "")
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
 
    private func handleSignUpTap() {
        // Clear previous validation errors
        signUpPhoneError = nil
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
 
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            registerVM.errorMessage = "Please enter your full name."
            return
        }
 
        guard Validators.isValidPhone(phone) else {
            signUpPhoneError = "Phone number must be 10 digits."
            return
        }
 
        guard Validators.isValidEmail(email) else {
            emailError = "Please enter a valid email address."
            return
        }
 

 
        let request = RegisterReqModel(
            name: fullName,
            email: email,
            phone: phone,
        )
 
        registerVM.registerNewUser(registerReqModel: request)
    }
 
    private func handleVerifyOTPTap() {
        let request = VerifyOTPReqModel(
            phone: phone,
            otp: otp
        )
 
        verifyOTPVM.verifyOTP(verifyOTPReqModel: request)
    }
}
