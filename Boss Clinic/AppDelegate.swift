//
//  AppDelegate.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 08/07/26.
//

import Foundation

import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import SwiftUI



final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let fcmViewModel = FCMViewModel()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            print("Notification permission granted: \(granted)")
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}
 
// MARK: - MessagingDelegate
 
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        print("FCM registration token: \(fcmToken)")
        
        print("📱 FCM Token: \(fcmToken)")
        
        fcmViewModel.saveFCMToken(fcmToken)
        
        NotificationTokenManager.shared.saveTokenIfPossible(fcmToken)
        
        
    }
}
 
// MARK: - UNUserNotificationCenterDelegate
 

extension AppDelegate: UNUserNotificationCenterDelegate {
 
    /// Called when a push arrives WHILE THE APP IS OPEN (foreground).
    /// Prints title/body/subtitle plus the custom "data" payload your
    /// Laravel backend attaches (medication_log_id, medication_id, type).
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        printNotificationDetails(from: notification.request.content, context: "FOREGROUND (willPresent)")
 
        completionHandler([.banner, .list, .sound, .badge])
    }
 
    /// Called when the user TAPS a notification (app was backgrounded or
    /// not running). Same detail print, plus the action identifier.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        printNotificationDetails(from: response.notification.request.content, context: "TAPPED (didReceive)")
        print("Action identifier: \(response.actionIdentifier)")
 
        let userInfo = response.notification.request.content.userInfo
        NotificationRouter.shared.handleNotificationTap(userInfo: userInfo)
 
        completionHandler()
    }
 
    /// Pulls apart the notification content and prints it in a readable
    /// block: standard fields (title/body/subtitle/sound/badge) plus
    /// whatever custom key/value pairs came through in "data" (everything
    /// FCM puts outside the "notification" block lands directly in
    /// userInfo as top-level string keys).
    private func printNotificationDetails(from content: UNNotificationContent, context: String) {
        print("========== 📩 NOTIFICATION [\(context)] ==========")
        print("Content type: \(type(of: content))")
        print("Title:    \(content.title)")
        print("Subtitle: \(content.subtitle)")
        print("Body:     \(content.body)")
        print("Badge:    \(content.badge?.stringValue ?? "nil")")
        print("Sound:    \(String(describing: content.sound))")
 
        let userInfo = content.userInfo
        print("--- Full userInfo (includes custom data payload) ---")
        for (key, value) in userInfo {
            print("  \(key): \(value)")
        }
 
        // FCM nests some values under "aps" (the raw APNs payload) and
        // "gcm.notification.*" / "google.c.*" internal keys — filter those
        // out to isolate just YOUR custom data fields (medication_log_id,
        // medication_id, type, etc. from SendMedicationPushNotificationsJob).
        let customDataKeys = userInfo.keys.filter { key in
            let k = "\(key)"
            return !k.hasPrefix("aps")
                && !k.hasPrefix("gcm.")
                && !k.hasPrefix("google.")
        }
        if !customDataKeys.isEmpty {
            print("--- Custom data fields only ---")
            for key in customDataKeys {
                print("  \(key): \(userInfo[key] ?? "nil")")
            }
        }
        print("=====================================================")
    }
}

 
// MARK: - Token persistence
 
/// Saves the FCM token to Firestore under the current user, so your
/// Cloud Function knows which device to send refill reminders to.
///
/// The FCM token can arrive *before* the user has logged in (e.g. right at
/// app launch), so we cache it and flush it to Firestore as soon as a
/// userId becomes available. Call `saveTokenIfPossible` again right after
/// your login flow completes, in case the token already arrived earlier.
final class NotificationTokenManager {
    
    static let shared = NotificationTokenManager()
    
    private var pendingToken: String?
    
    private init() {}
    
    /// TODO: Wire this up to however your app identifies the logged-in user
    /// today (e.g. the phone number / user id you get back from your OTP
    /// login API), not necessarily Firebase Auth.
    var currentUserId: String? {
        UserDefaults.standard.string(forKey: "currentUserId")
    }
    
    func saveTokenIfPossible(_ token: String? = nil) {
        if let token {
            pendingToken = token
        }
        
        guard let tokenToSave = pendingToken, let userId = currentUserId else {
            return // will retry once both a token and a logged-in user exist
        }
        
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .setData(["fcmToken": tokenToSave], merge: true) { error in
                if let error {
                    print("Failed to save FCM token: \(error.localizedDescription)")
                } else {
                    print("Saved FCM token for user \(userId)")
                }
            }
    }
}

