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
//final class NotificationRouter: ObservableObject {
//
//   static let shared = NotificationRouter()
//
//   @Published var pendingDoseReminder: DoseReminder?
//
//   private init() {}
//
//   /// Call this from AppDelegate's `didReceive response:` handler.
//   func handleNotificationTap(userInfo: [AnyHashable: Any]) {
//       guard let type = userInfo["type"] as? String else { return }
//
//       switch type {
//       case "dose_reminder":
//           guard
//               let medicationId = userInfo["medicationId"] as? String,
//               let medicationName = userInfo["medicationName"] as? String
//           else { return }
//
//           let dosageText = userInfo["dosageText"] as? String ?? ""
//           let scheduledTime = userInfo["scheduledTime"] as? String ?? ""
//
//           DispatchQueue.main.async {
//               self.pendingDoseReminder = DoseReminder(
//                   id: medicationId,
//                   medicationName: medicationName,
//                   dosageText: dosageText,
//                   scheduledTime: scheduledTime
//               )
//           }
//
//       case "refill_reminder":
//           // TODO: route to Medications tab instead, if you want different
//           // handling for refill vs. dose-time notifications.
//           break
//
//       default:
//           break
//       }
//   }
//}

//import Foundation
 
 

/// Bridges UIKit-land (AppDelegate's notification delegate methods) into SwiftUI.
/// AppDelegate sets `pendingDoseReminder` when a dose-reminder notification is tapped;
/// your root view observes this object and presents a full-screen cover when it's non-nil.
final class NotificationRouter: ObservableObject {
 
    static let shared = NotificationRouter()
 
    @Published var pendingDoseReminder: DoseReminder?
 
    private init() {}
 
    /// Call this from AppDelegate's `didReceive response:` handler.
    func handleNotificationTap(userInfo: [AnyHashable: Any]) {
 
        guard let type = stringValue(userInfo["type"]) else { return }
 
        switch type {
 
        case "medication_reminder":
 
            // Backend only sends medication_id as structured data — the
            // actual name/dose live in the notification body text:
            // "Time to take {name} ({dose})" or "Time to take {name}"
            guard let medicationId = stringValue(userInfo["medication_id"]) else { return }
 
            let scheduledTime = stringValue(userInfo["scheduled_time"])
                ?? stringValue(userInfo["time"])
                ?? ""
 
            let (medicationName, dosageText) = parseNameAndDose(from: userInfo)
 
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
 
    /// FCM data payloads can arrive with values as String OR NSNumber
    /// depending on the backend/library, even for things PHP treated as
    /// integers (e.g. medication_id). This normalizes either case to String.
    private func stringValue(_ raw: Any?) -> String? {
        if let string = raw as? String {
            return string
        }
        if let number = raw as? NSNumber {
            return number.stringValue
        }
        return nil
    }
 
    /// Pulls the notification's alert body out of the raw push payload.
    /// Handles both the plain-string alert shape and the {title, body} shape.
    private func alertBody(from userInfo: [AnyHashable: Any]) -> String? {
        guard let aps = userInfo["aps"] as? [String: Any] else { return nil }
 
        if let alert = aps["alert"] as? String {
            return alert
        }
        if let alert = aps["alert"] as? [String: Any],
           let body = alert["body"] as? String {
            return body
        }
        return nil
    }
 
    /// Parses "Time to take {name} ({dose})" or "Time to take {name}"
    /// out of the notification body text.
    private func parseNameAndDose(from userInfo: [AnyHashable: Any]) -> (name: String, dose: String) {
 
        guard let body = alertBody(from: userInfo) else {
            return ("Your medication", "")
        }
 
        let prefix = "Time to take "
        var remainder = body
 
        if remainder.hasPrefix(prefix) {
            remainder = String(remainder.dropFirst(prefix.count))
        }
 
        // remainder is now e.g. "Amoxicillin 500 mg (1 Tablet)" or "Amoxicillin 500 mg"
        if let openParen = remainder.range(of: " ("),
           remainder.hasSuffix(")") {
 
            let name = String(remainder[remainder.startIndex..<openParen.lowerBound])
            let doseStart = remainder.index(openParen.upperBound, offsetBy: 0)
            let dose = String(remainder[doseStart..<remainder.index(before: remainder.endIndex)])
 
            return (name.trimmingCharacters(in: .whitespaces), dose.trimmingCharacters(in: .whitespaces))
        }
 
        return (remainder.trimmingCharacters(in: .whitespaces), "")
    }
}
