//
//  LoginScreen.swift
//  Boss Clinic
//
//  Created by Onqanet on 26/06/26.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var phone = ""
    @State private var otp = ""
    
    @State private var showOTPField = false
    @State private var isPhoneEditable = true
    
    @State private var navigateToHome = false
    
    @State private var showPhoneError = false
    
    @State private var isSignUp = false
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    
    @StateObject private var registerVM = RegisterViewModel()
    
    //Sign Up Error
    @State private var signUpPhoneError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    
    
    
    var body: some View {
        
        ZStack {
            ScrollView(showsIndicators: false)
            {
                VStack(alignment: .center) {

                    Image("boss_clinic_icon_img")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .clipped()
                        .padding(.bottom, 50)

                    // Welcome
                    VStack(alignment: .leading, spacing: 10) {

                        Text(isSignUp ? "Create Account" : "Welcome back")
                            .font(.custom("Inter24pt-Bold", size: 24))

                        Text(isSignUp
                             ? "Create your account to get started."
                             : "Log in to continue to your account.")
                            .font(.custom("Inter18pt-Regular", size: 14))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)

                    // Form
                    VStack(alignment: .leading) {
                        
                        if isSignUp {

                            // MARK: Full Name
                            Text("Full Name")
                                .font(.custom("Inter18pt-SemiBold", size: 16))
                                .foregroundColor(Color.white)
                                .padding(.bottom, 5)

                            CustomTextField(
                                text: $fullName,
                                placeholder: "Enter your full name",
                                prefixImage: "person"
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
                                prefixImage: "email",
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

                            // MARK: Password
                            Text("Password")
                                .font(.custom("Inter18pt-SemiBold", size: 16))
                                .foregroundColor(Color.white)
                                .padding(.bottom, 5)

                            CustomTextField(
                                text: $password,
                                placeholder: "Enter your password",
                                prefixImage: "password",
                                keyboardType: .default,
                                textContentType: .password
                            )
                            .padding(.bottom, 5)
                            
                            if let passwordError {
                                Text(passwordError)
                                    .font(.custom("Inter18pt-Regular", size: 12))
                                    .foregroundColor(.red)
                                    .padding(.top, 2)
                            }
                            
                            //MARK: Confirm Password
                            
                            Text("Confirm Password")
                                .font(.custom("Inter18pt-SemiBold", size: 16))
                                .foregroundColor(Color.white)
                                .padding(.bottom, 5)

                            CustomTextField(
                                text: $confirmPassword,
                                placeholder: "Confirm password",
                                prefixImage: "password",
                                keyboardType: .default,
                                textContentType: .password
                            )
                            .padding(.bottom, 20)
                            
                            if let confirmPasswordError {
                                Text(confirmPasswordError)
                                    .font(.custom("Inter18pt-Regular", size: 12))
                                    .foregroundColor(.red)
                                    .padding(.top, 2)
                            }
                            

                        } else {

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
                            .onChange(of: phone) { newValue in
                                phone = String(newValue.filter(\.isNumber).prefix(10))

                                if phone.count == 10 {
                                    showPhoneError = false
                                }
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

                                Text("OTP")
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
                        }

                        PrimaryButton(
                            title: isSignUp
                                ? "Sign Up"
                                : (showOTPField ? "Verify OTP" : "Submit")
                        ) {

                            if isSignUp {
                                //print("Sign Up API")
                                
                                // Clear previous validation errors
                                    signUpPhoneError = nil
                                    emailError = nil
                                    passwordError = nil
                                    confirmPasswordError = nil
                                
                                guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
                                    registerVM.errorMessage = "Please enter your full name."
                                    return
                                }

                                guard isValidPhone(phone) else {
                                    //registerVM.errorMessage = "Please enter a valid 10-digit phone number."
                                    signUpPhoneError = "Phone number must be 10 digits."
                                    return
                                }

                                guard isValidEmail(email) else {
                                    //registerVM.errorMessage = "Please enter a valid email address."
                                    emailError = "Please enter a valid email address."
                                    return
                                }

                                guard password.count >= 8 else {
                                    //registerVM.errorMessage = "Password must be at least 8 characters long."
                                    passwordError = "Password must be at least 8 characters."
                                    return
                                }

                                guard password == confirmPassword else {
                                    //registerVM.errorMessage = "Passwords do not match."
                                    confirmPasswordError = "Passwords do not match."
                                    return
                                }
                                
                                
                                let request = RegisterReqModel(
                                       name: fullName,
                                       email: email,
                                       phone: phone,
                                       password: password,
                                       confirmPassword: confirmPassword
                                   )

                                   registerVM.registerNewUser(registerReqModel: request)
                                
                            } else {

                                if !showOTPField {

                                    guard phone.count == 10 else {
                                        showPhoneError = true
                                        return
                                    }

                                    showPhoneError = false

                                    withAnimation {
                                        showOTPField = true
                                    }

                                } else {
                                    navigateToHome = true
                                }
                            }
                        }
                        .padding(.top, 20)

                    }
                    .padding(.horizontal, 20)

                    HStack {
                        Text(isSignUp
                             ? "Already have an account?"
                             : "Don't have an account?")
                            .font(.custom("Inter18pt-Regular", size: 14))
                            .foregroundColor(.white)

                        Button(isSignUp ? "Sign In" : "Sign Up") {
                            withAnimation(.easeInOut) {
                                isSignUp.toggle()

                                // Reset the OTP state when switching modes
                                showOTPField = false
                                phone = ""
                                otp = ""
                                showPhoneError = false
                            }
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    }
                    .padding(.top, 20)

                    // Extra space so the last control can scroll above the keyboard
                    Spacer()
                        .frame(height: 40)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            }
            .scrollDismissesKeyboard(.interactively)   // iOS 16+

            
            // Loader Overlay
            if registerVM.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
            
        }
        .background(Color.black.ignoresSafeArea())
            .onChange(of: registerVM.isRegistrationSuccessful) { success in
                if success {
                    navigateToHome = true
                }
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
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToHome) {
                MainTabView()
            }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
            .evaluate(with: email)
    }

    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            .evaluate(with: phone)
    }
}

#Preview {
    LoginScreen()
}

