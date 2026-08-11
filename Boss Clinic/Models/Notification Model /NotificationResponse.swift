//
//  NotificationResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import Foundation


struct NotificationResponse: Codable, Equatable {
    let status: Int
    let message: String
    let data: [NotificationItem]?
}
 
// MARK: - Notification Item
struct NotificationItem: Codable, Equatable, Identifiable, Hashable {
 
    let id: String
    let userId: String
    let type: String
 
    // These three arrive as `null` for some notification types (confirmed
    // in the actual response: every "App\Notifications\MissedMedicationNotification"
    // entry has title/message/notification_category all null — the real
    // text lives inside `data.message` instead for those).
    let title: String?
    let message: String?
    let notificationCategory: String?
 
    let data: NotificationData?
    let isRead: Bool
    let readAt: String?
    let actionURL: String?
    let createdAt: String
    let updatedAt: String
    let datetime: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type
        case title
        case message
        case data
        case isRead = "is_read"
        case readAt = "read_at"
        case notificationCategory = "notification_category"
        case actionURL = "action_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case datetime
    }
 
    /// Convenience: the text to actually display, regardless of which
    /// notification shape this is. Falls back to data.message (where the
    /// MissedMedicationNotification puts its text) when the top-level
    /// message is null.
    var displayTitle: String {
        title ?? fallbackTitle
    }
 
    var displayMessage: String {
        message ?? data?.message ?? ""
    }
 
    private var fallbackTitle: String {
        switch data?.notificationDataType ?? type {
        case "medication_reminder":
            return "Medication Reminder"
        default:
            if type.contains("MissedMedicationNotification") {
                return "Missed Medication"
            }
            return "Notification"
        }
    }
}
 
// MARK: - Notification Data
/// Permissive union of every `data` shape actually seen in the API
/// response — medication reminders, appointment notifications (both
/// "appointment_created" and "appointment_reminder_3h_before"), and
/// missed-medication notifications. All fields are optional since no
/// single notification type populates all of them; use the fields
/// relevant to `type` / `notificationDataType`.
struct NotificationData: Codable, Equatable, Hashable {
 
    // Present on most shapes
    let id: String?
    let type: String?
 
    // Medication reminder shape
    let medicationLogId: String?
    let medicationId: String?
    let scheduledDate: String?
    let scheduledTime: String?
 
    // Missed medication shape
    let medicationName: String?
    let message: String?
 
    // Appointment shape
    let status: String?
    let appointmentId: String?
    let doctorName: String?
    let appointmentDate: String?
    let appointmentTime: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case medicationLogId = "medication_log_id"
        case medicationId = "medication_id"
        case scheduledDate = "scheduled_date"
        case scheduledTime = "scheduled_time"
        case medicationName = "medication_name"
        case message
        case status
        case appointmentId = "appointment_id"
        case doctorName = "doctor_name"
        case appointmentDate = "appointment_date"
        case appointmentTime = "appointment_time"
    }
 
    /// `type` inside `data` is the clean category ("appointment") when
    /// present; missed-medication entries don't include it at all, so
    /// this infers it from which fields ARE present instead.
    var notificationDataType: String {
        if let type { return type }
        if medicationLogId != nil { return "medication_reminder" }
        return "unknown"
    }
}


