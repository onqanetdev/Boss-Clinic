//
//  Boss_ClinicApp.swift
//  Boss Clinic
//
//  Created by Onqanet on 24/06/26.
//

import SwiftUI
import FirebaseCore




@main
struct BossClinicApp: App {
 
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
 
    @StateObject private var notificationRouter = NotificationRouter.shared
 
    var body: some Scene {
        WindowGroup {
            //FlipCardsView()
            RootView()
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
}



