//
//  MainTabView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 30/06/26.
//

//import SwiftUI
//
//struct MainTabView: View {
//
//    @State private var selectedTab: Tab = .home
//    
//    @State private var path = NavigationPath()
//    
//    init() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.black
// 
//        // Unselected tab items
//        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
//            .foregroundColor: UIColor.gray
//        ]
// 
//        // Selected tab item
//        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
//            .foregroundColor: UIColor.white
//        ]
// 
//        // Apply to both the normal state and the "scrolled to edge" state —
//        // this is the part that stops it reverting to white when switching tabs.
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
// 
//    var body: some View {
//
//        TabView(selection: $selectedTab) {
//
//            HomeScreen()
//                .tabItem {
//                    Image(selectedTab == .home ? "home_selected" : "home")
//                        .imageScale(.small)
//                    Text("Home")
//                }
//                .tag(Tab.home)
//
//            AppointmentScreen()
//                .tabItem {
//                    Image(selectedTab == .appointments ? "appointment_selected" : "appointment")
//                        .imageScale(.small)
//                    Text("Medications")
//                }
//                .tag(Tab.appointments)
//
//
//            NotificationScreen()
//                .tabItem {
//                    Image(selectedTab == .notification ? "notification_selected" : "notification")
//                        .imageScale(.small)
//                    Text("Reminders")
//                }
//                .tag(Tab.notification)
//
//            ProfileScreen()
//                .tabItem {
//                    Image(selectedTab == .profile ? "profile_selected" : "profile")
//                        .imageScale(.small)
//                    Text("Profile")
//                }
//                .tag(Tab.profile)
//        }
//        .toolbarBackground(Color.black, for: .tabBar)
//        .toolbarBackground(.visible, for: .tabBar)
//        .preferredColorScheme(.dark)
//        .accentColor(.white)
//        .navigationBarBackButtonHidden(true)
//    }
//}


import SwiftUI
 
struct MainTabView: View {
 
    @State private var selectedTab: Tab = .home
 
    @State private var path = NavigationPath()
 
    init() {
        // Hide the native tab bar globally — we're drawing our own below,
        // so this app is immune to whatever iOS does to system tab bars
        // (Liquid Glass floating capsule, or anything future OS versions add).
        UITabBar.appearance().isHidden = true
    }
 
    var body: some View {
        ZStack(alignment: .bottom) {
 
            TabView(selection: $selectedTab) {
 
                HomeScreen()
                    .tag(Tab.home)
 
                AppointmentScreen()
                    .tag(Tab.appointments)
 
                NotificationScreen()
                    .tag(Tab.notification)
 
                ProfileScreen()
                    .tag(Tab.profile)
            }
            // Belt-and-suspenders: also hide it at the SwiftUI level.
            .toolbar(.hidden, for: .tabBar)
 
            CustomTabBar(selectedTab: $selectedTab)
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }
}
 
// MARK: - Custom square tab bar
 
private struct CustomTabBar: View {
 
    @Binding var selectedTab: Tab
 
    private struct TabItem {
        let tab: Tab
        let title: String
        let icon: String          // unselected asset name
        let selectedIcon: String  // selected asset name
    }
 
    private let items: [TabItem] = [
        TabItem(tab: .home, title: "Home", icon: "home", selectedIcon: "home_selected"),
        TabItem(tab: .appointments, title: "Medications", icon: "appointment", selectedIcon: "appointment_selected"),
        TabItem(tab: .notification, title: "Reminders", icon: "notification", selectedIcon: "notification_selected"),
        TabItem(tab: .profile, title: "Profile", icon: "profile", selectedIcon: "profile_selected")
    ]
 
    var body: some View {
        VStack(spacing: 0) {
 
            // Thin top hairline, like the classic system tab bar
            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 0.5)
 
            HStack(spacing: 0) {
                ForEach(items, id: \.tab) { item in
                    Button {
                        selectedTab = item.tab
                    } label: {
                        VStack(spacing: 4) {
                            Image(selectedTab == item.tab ? item.selectedIcon : item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
 
                            Text(item.title)
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(selectedTab == item.tab ? .white : Color.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 6)
        }
        // Square, edge-to-edge, opaque black — extends under the home indicator.
        .background(
            Color.black
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
 
#Preview {
    MainTabView()
}
