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
    
    
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
 
        // Unselected tab items
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]
 
        // Selected tab item
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
 
        // Apply to both the normal state and the "scrolled to edge" state —
        // this is the part that stops it reverting to white when switching tabs.
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
 
    
    

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


            NotificationScreen()
                .tabItem {
                    Image(selectedTab == .notification ? "notification_selected" : "notification")
                        .imageScale(.small)
                    Text("Reminders")
                }
                .tag(Tab.notification)

            ProfileScreen()
                .tabItem {
                    Image(selectedTab == .profile ? "profile_selected" : "profile")
                        .imageScale(.small)
                    Text("Profile")
                }
                .tag(Tab.profile)
        }
        .toolbarBackground(Color.black, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .preferredColorScheme(.dark)
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
    }
}



