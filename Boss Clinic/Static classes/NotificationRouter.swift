//
//  NotificationRouter.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 09/07/26.
//

import Foundation




/// Bridges UIKit-land (AppDelegate's notification delegate methods) into SwiftUI.
/// AppDelegate sets `pendingDoseReminder` when a dose-reminder notification is tapped;
/// your root view observes this object and presents a full-screen cover when it's non-nil.
final class NotificationRouter: ObservableObject {

   static let shared = NotificationRouter()

   @Published var pendingDoseReminder: DoseReminder?

   private init() {}

   /// Call this from AppDelegate's `didReceive response:` handler.
   func handleNotificationTap(userInfo: [AnyHashable: Any]) {
       guard let type = userInfo["type"] as? String else { return }

       switch type {
       case "dose_reminder":
           guard
               let medicationId = userInfo["medicationId"] as? String,
               let medicationName = userInfo["medicationName"] as? String
           else { return }

           let dosageText = userInfo["dosageText"] as? String ?? ""
           let scheduledTime = userInfo["scheduledTime"] as? String ?? ""

           DispatchQueue.main.async {
               self.pendingDoseReminder = DoseReminder(
                   id: medicationId,
                   medicationName: medicationName,
                   dosageText: dosageText,
                   scheduledTime: scheduledTime
               )
           }

       case "refill_reminder":
           // TODO: route to Medications tab instead, if you want different
           // handling for refill vs. dose-time notifications.
           break

       default:
           break
       }
   }
}

