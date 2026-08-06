//
//  NotificationSettingsViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 17/07/26.
//

import Foundation



final class NotificationSettingsViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var notificationSettingsResponse: NotificationSettingsResponse?
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false   // NEW
    
    func fetchNotificationSettings() {
        
        isLoading = true
        errorMessage = nil
        isOffline = false   // NEW
        
        NotificationSettingsAPICaller.shared.fetchNotificationSettings { [weak self] result in
            
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
                
            case .success(let response):
                
                self.notificationSettingsResponse = response
                
                print("✅ Notification Settings Loaded Successfully")
                print("🔔 Push Notifications: \(response.data.pushNotifications)")
                print("📧 Email Notifications: \(response.data.emailNotifications)")
                print("💊 Medication Reminders: \(response.data.medicationReminders)")
                
            case .failure(let error):
                
                // self.errorMessage = error.localizedDescription
                
                if case .noInternet = error {      // NEW
                    self.isOffline = true
                } else {
                    self.errorMessage = error.localizedDescription
                }
                print("❌ Notification Settings Error: \(error.localizedDescription)")
            }
        }
    }
}

