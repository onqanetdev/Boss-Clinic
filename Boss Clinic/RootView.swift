//
//  RootView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import Foundation
import SwiftUI


struct RootView: View {
 
    @StateObject private var session = SessionManager.shared
    @StateObject private var notificationRouter = NotificationRouter.shared
 
    /// Set to true once the user taps "Get Started"/"Log in" on FlipCardsView.
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
 
    var body: some View {
        Group {
            if session.isLoggedIn {
                NavigationStack {
                    MainTabView()
                }
 
            } else if hasSeenOnboarding {
                NavigationStack {
                    LoginScreen()
                }
 
            } else {
                NavigationStack {
                    FlipCardsView()
                }
            }
        }
        // Forces a full rebuild on login/logout, dismissing any leftover
        // pushed screens, sheets, or covers from the previous session.
        .id(session.isLoggedIn)
        .fullScreenCover(item: $notificationRouter.pendingDoseReminder) { reminder in
            MedicationReminderView(
                reminder: reminder,
                onTakeNow: {
                    // TODO: mark this dose as taken — e.g. decrement
                    // quantityRemaining in Firestore for this medication
                },
                onSnooze: {
                    // TODO: schedule a follow-up local notification a few
                    // minutes from now for the same medication
                }
            )
        }
    }
}
 
#Preview {
    RootView()
}
 
