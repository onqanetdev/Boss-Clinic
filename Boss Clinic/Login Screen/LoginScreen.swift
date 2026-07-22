//
//  LoginScreen.swift
//  Boss Clinic
//
//  Created by Onqanet on 26/06/26.
//

import SwiftUI


struct LoginScreen: View {

   @State private var isSignUp = false

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
               Group {
                   if isSignUp {
                       SignUpView {
                           // Registration + OTP verified — tell SessionManager,
                           // RootView will swap to MainTabView automatically.
                           SessionManager.shared.login()
                       }
                   } else {
                       LoginView {
                           SessionManager.shared.login()
                       }
                   }
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
       .background(Color.black.ignoresSafeArea())
       .navigationBarBackButtonHidden(true)
       // NOTE: no local navigateToHome / navigationDestination to MainTabView
       // anymore — RootView owns that transition based on SessionManager.
   }
}
 
#Preview {
    LoginScreen()
}
