//
//  NotificationCountResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 24/07/26.
//

import Foundation



struct NotificationCountResponse: Codable, Equatable {
    let status: Int
    let message: String
    let notificationCount: Int

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case notificationCount = "notification_count"
    }
}


