//
//  NotificationSettingsUpdateViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 17/07/26.
//

import Foundation



final class NotificationSettingsUpdateViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var updateResponse: NotificationSettingUpdateModel?
    @Published var errorMessage: String?

    func updateNotificationSettings(
        medicationReminders: Bool,
        refillReminders: Bool,
        sound: Bool,
        vibration: Bool
    ) {

        isLoading = true
        errorMessage = nil

        NotificationSettingsUpdateAPICaller.shared.updateNotificationSettings(
            medicationReminders: medicationReminders,
            refillReminders: refillReminders,
            sound: sound,
            vibration: vibration
        ) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):

                self.updateResponse = response

                print("✅ Notification Settings Updated Successfully")
                print("💊 Medication Reminders: \(response.data.medicationReminders)")
                print("💊 Refill Reminders: \(response.data.refillReminders)")
                print("🔊 Sound: \(response.data.sound)")
                print("📳 Vibration: \(response.data.vibration)")

            case .failure(let error):

                self.errorMessage = error.localizedDescription

                print("❌ Update Notification Settings Error: \(error.localizedDescription)")
            }
        }
    }
}

