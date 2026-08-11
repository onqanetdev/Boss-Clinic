//
//  NotificationReadResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 27/07/26.
//

import Foundation




struct NotificationReadResponse: Codable, Equatable {
    let status: Int
    let message: String
    let data: NotificationReadData
}
 
// MARK: - Notification Data
 
struct NotificationReadData: Codable, Equatable {
    let id: String
    let userId: String
    let type: String
 
    // Can arrive null for some notification types (e.g.
    // MissedMedicationNotification) — see NotificationItem for the
    // same issue on the list endpoint.
    let title: String?
    let message: String?
    let notificationCategory: String?
 
    let data: NotificationReferenceData?
    let isRead: Bool
    let readAt: String?
    let actionURL: String?
    let createdAt: String
    let updatedAt: String
 
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
    }
}
 
// MARK: - Reference Data
 
/// Same permissive union as NotificationData in NotificationResponse.swift
/// — covers medication reminder, appointment, and missed-medication
/// shapes. Keep these two in sync if the backend adds a new notification
/// type; consider consolidating into one shared type once both endpoints
/// are confirmed stable.
struct NotificationReferenceData: Codable, Equatable {
 
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
}

