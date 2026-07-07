//
//  MainTabView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 30/06/26.
//

import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: Tab = .home
    
    @State private var path = NavigationPath()

    var body: some View {

        TabView(selection: $selectedTab) {

            HomeScreen()
                .tabItem {
                    Image(selectedTab == .home ? "home_selected" : "home")
                        .imageScale(.small)
                    Text("Home")
                }
                .tag(Tab.home)

            AppointmentScreen()
                .tabItem {
                    Image(selectedTab == .appointments ? "appointment_selected" : "appointment")
                        .imageScale(.small)
                    Text("Medications")
                }
                .tag(Tab.appointments)

//            ReportsScreen()
//                .tabItem {
//                    Image(selectedTab == .reports ? "reports_selected" : "reports")
//                        .imageScale(.small)
//                    Text("Reports")
//                }
//                .tag(Tab.reports)

            NotificationScreen()
                .tabItem {
                    Image(selectedTab == .notification ? "notification_selected" : "notification")
                        .imageScale(.small)
                    Text("Reminders")
                }
                .tag(Tab.notification)

            ProfileScreen(path: $path)
                .tabItem {
                    Image(selectedTab == .profile ? "profile_selected" : "profile")
                        .imageScale(.small)
                    Text("Profile")
                }
                .tag(Tab.profile)
        }
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
    }
}
