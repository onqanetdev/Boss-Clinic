//
//  ProfileScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 30/06/26.
//

import SwiftUI



struct ProfileScreen: View {

   // Replace these with your real user model / view model
   let userName: String = "John Doe"
   let userEmail: String = "john.doe@email.com"

   @State private var showMyProfile = false
   @State private var showNotificationSettings = false
   @State private var showReminderSettings = false
   @State private var showHelpSupport = false
   @State private var showPrivacyPolicy = false

   @State private var showLogoutConfirm = false

   var body: some View {
       ScrollView(showsIndicators: false) {
           VStack(alignment: .leading, spacing: 24) {

               // MARK: Title
               Text("Profile")
                   .font(.custom("Inter24pt-Bold", size: 28))
                   .foregroundColor(.white)
                   .padding(.top, 20)

               // MARK: Avatar + Name + Email
               HStack(spacing: 16) {
                   ZStack {
                       Circle()
                           .fill(Color.white)
                           .frame(width: 88, height: 88)

                       Image(systemName: "person.fill")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 40, height: 40)
                           .foregroundColor(.black)
                   }

                   VStack(alignment: .leading, spacing: 4) {
                       Text(userName)
                           .font(.custom("Inter24pt-Bold", size: 22))
                           .foregroundColor(.white)

                       Text(userEmail)
                           .font(.custom("Inter18pt-Regular", size: 15))
                           .foregroundColor(Color.white.opacity(0.6))
                   }
               }
               .padding(.bottom, 8)

               // MARK: Options
               VStack(spacing: 16) {

                   ProfileRow(icon: .system("person"), title: "My Profile") {
                       showMyProfile = true
                   }

                   ProfileRow(icon: .system("bell"), title: "Notification Settings") {
                       showNotificationSettings = true
                   }

                   ProfileRow(icon: .system("clock.arrow.circlepath"), title: "Reminder Settings") {
                       showReminderSettings = true
                   }

                   ProfileRow(icon: .system("questionmark.circle"), title: "Help & Support") {
                       showHelpSupport = true
                   }

                   // MARK: Now using your asset catalog image — replace "privacy_policy" with your actual asset name
                   ProfileRow(icon: .asset("privacy_policy"), title: "Privacy Policy") {
                       showPrivacyPolicy = true
                   }

                   // MARK: Now using your asset catalog image — replace "logout_icon" with your actual asset name
                   ProfileRow(icon: .asset("logout_icon"), title: "Log Out") {
                       showLogoutConfirm = true
                   }
               }

               Spacer(minLength: 40)
           }
           .padding(.horizontal, 20)
       }
       .background(Color.black.ignoresSafeArea())
       .navigationBarBackButtonHidden(true)
       .navigationDestination(isPresented: $showMyProfile) {
           MyProfileScreen()
       }
       .navigationDestination(isPresented: $showNotificationSettings) {
           NotificationScreen()
       }
       .navigationDestination(isPresented: $showReminderSettings) {
           ReminderScreen()
       }
       .navigationDestination(isPresented: $showHelpSupport) {
           Text("Help & Support")
               .foregroundColor(.white)
               .background(Color.black.ignoresSafeArea())
       }
       .navigationDestination(isPresented: $showPrivacyPolicy) {
           Text("Privacy Policy")
               .foregroundColor(.white)
               .background(Color.black.ignoresSafeArea())
       }
       .confirmationDialog(
           "Are you sure you want to log out?",
           isPresented: $showLogoutConfirm,
           titleVisibility: .visible
       ) {
           Button("Log Out", role: .destructive) {
               // TODO: Hook up your real logout logic here
               print("User logged out")
           }
           Button("Cancel", role: .cancel) { }
       }
   }
}

// MARK: - Icon source (SF Symbol vs. Asset Catalog image)

private enum RowIcon {
   case system(String)   // SF Symbol name
   case asset(String)    // Asset catalog image name
}

// MARK: - Reusable row

private struct ProfileRow: View {

   let icon: RowIcon
   let title: String
   let action: () -> Void

   var body: some View {
       Button(action: action) {
           HStack(spacing: 16) {
               iconView
                   .frame(width: 20, height: 20)
                   .foregroundColor(.white)

               Text(title)
                   .font(.custom("Inter18pt-SemiBold", size: 16))
                   .foregroundColor(.white)

               Spacer()

               Image(systemName: "chevron.right")
                   .font(.system(size: 15, weight: .semibold))
                   .foregroundColor(.white)
           }
           .padding(.vertical, 18)
           .padding(.horizontal, 16)
           .background(
               RoundedRectangle(cornerRadius: 14)
                   .stroke(Color.white.opacity(0.25), lineWidth: 1)
           )
       }
       .buttonStyle(.plain)
   }

   @ViewBuilder
   private var iconView: some View {
       switch icon {
       case .system(let name):
           Image(systemName: name)
               .resizable()
               .scaledToFit()
       case .asset(let name):
           Image(name)
               .renderingMode(.template) // lets .foregroundColor tint the asset white
               .resizable()
               .scaledToFit()
       }
   }
}

#Preview {
   NavigationStack {
       ProfileScreen()
   }
}
