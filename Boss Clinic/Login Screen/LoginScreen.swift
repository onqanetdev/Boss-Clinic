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
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                        .padding(.bottom, 20)

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
                            print("Sign Up API")
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
        .background(Color.black.ignoresSafeArea())
        .scrollDismissesKeyboard(.interactively)   // iOS 16+
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToHome) {
            MainTabView()
        }
    }
}

#Preview {
    LoginScreen()
}

