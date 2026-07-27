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
    let title: String
    let message: String
    let data: NotificationReferenceData
    let isRead: Bool
    let readAt: String?
    let notificationCategory: String
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

struct NotificationReferenceData: Codable, Equatable {

    let medicationLogId: String
    let medicationId: String
    let scheduledDate: String
    let scheduledTime: String

    enum CodingKeys: String, CodingKey {
        case medicationLogId = "medication_log_id"
        case medicationId = "medication_id"
        case scheduledDate = "scheduled_date"
        case scheduledTime = "scheduled_time"
    }
}



