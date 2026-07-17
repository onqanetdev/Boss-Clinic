//
//  NotificationSettingUpdateModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 17/07/26.
//

import Foundation



// MARK: - Response

struct NotificationSettingUpdateModel: Codable {
    let success: Bool
    let message: String
    let data: NotificationSettingUpdateData
}

// MARK: - Data

struct NotificationSettingUpdateData: Codable {

    let id: String
    let userId: String

    let medicationReminders: Bool
    let refillReminders: Bool
    let appointmentReminders: Bool

    let emailNotifications: Bool
    let pushNotifications: Bool
    let smsNotifications: Bool

    let sound: Bool
    let vibration: Bool

    let refillReminderTime: String?
    let appointmentReminderTime: String?

    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"

        case medicationReminders = "medication_reminders"
        case refillReminders = "refill_reminders"
        case appointmentReminders = "appointment_reminders"

        case emailNotifications = "email_notifications"
        case pushNotifications = "push_notifications"
        case smsNotifications = "sms_notifications"

        case sound
        case vibration

        case refillReminderTime = "refill_reminder_time"
        case appointmentReminderTime = "appointment_reminder_time"

        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



