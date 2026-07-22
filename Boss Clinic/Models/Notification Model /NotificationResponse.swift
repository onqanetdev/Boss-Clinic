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
struct NotificationItem: Codable, Equatable, Identifiable {
    let id: String
    let userId: String
    let type: String
    let title: String
    let message: String
    let data: NotificationData
    let isRead: Bool
    let readAt: String?
    let notificationCategory: String
    let actionURL: String
    let createdAt: String
    let updatedAt: String
    let datetime: String

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
}

// MARK: - Notification Data
struct NotificationData: Codable, Equatable {
    let referenceId: String

    enum CodingKeys: String, CodingKey {
        case referenceId = "reference_id"
    }
}
