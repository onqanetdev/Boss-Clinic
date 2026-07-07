//
//  ProfileScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 30/06/26.
//

import SwiftUI

enum ProfileRoute: Hashable {
    case myProfile
    case notificationSettings
    case reminderSettings
    case helpSupport
    case privacyPolicy
}

struct ProfileScreen: View {

    @Binding var path: NavigationPath

    // Replace these with your real user model / view model
    let userName: String = "John Doe"
    let userEmail: String = "john.doe@email.com"

    @State private var showLogoutConfirm = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: Title
                Text("Profile")
                    .font(.custom("Inter24pt-SemiBold", size: 23))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                // MARK: Avatar + Name + Email
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 78, height: 78)

                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(userName)
                            .font(.custom("Inter24pt-Bold", size: 20))
                            .foregroundColor(.white)

                        Text(userEmail)
                            .font(.custom("Inter18pt-Regular", size: 13))
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                .padding(.bottom, 8)

                // MARK: Options
                VStack(spacing: 16) {

                    ProfileRow(icon: .system("person"), title: "My Profile") {
                        path.append(ProfileRoute.myProfile)
                    }

                    ProfileRow(icon: .system("bell"), title: "Notification Settings") {
                        path.append(ProfileRoute.notificationSettings)
                    }

                    ProfileRow(icon: .system("clock.arrow.circlepath"), title: "Reminder Settings") {
                        path.append(ProfileRoute.reminderSettings)
                    }

                    ProfileRow(icon: .system("questionmark.circle"), title: "Help & Support") {
                        path.append(ProfileRoute.helpSupport)
                    }

                    // MARK: Now using your asset catalog image — replace "privacy_policy_icon" with your actual asset name
                    ProfileRow(icon: .asset("privacy_policy"), title: "Privacy Policy") {
                        path.append(ProfileRoute.privacyPolicy)
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
        .navigationDestination(for: ProfileRoute.self) { route in
            switch route {
            case .myProfile:
                Text("My Profile")
                    .foregroundColor(.white)
                    .background(Color.black.ignoresSafeArea())
            case .notificationSettings:
                Text("Notification Settings")
                    .foregroundColor(.white)
                    .background(Color.black.ignoresSafeArea())
            case .reminderSettings:
                Text("Reminder Settings")
                    .foregroundColor(.white)
                    .background(Color.black.ignoresSafeArea())
            case .helpSupport:
                Text("Help & Support")
                    .foregroundColor(.white)
                    .background(Color.black.ignoresSafeArea())
            case .privacyPolicy:
                Text("Privacy Policy")
                    .foregroundColor(.white)
                    .background(Color.black.ignoresSafeArea())
            }
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
        ProfileScreen(path: .constant(NavigationPath()))
    }
}
