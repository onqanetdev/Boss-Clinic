//
//  AppointmentListResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/08/26.
//

import Foundation



struct AppointmentListResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: [Appointment]
}

// MARK: - Appointment Status

enum AppointmentStatus: String, Codable {
    case scheduled
    case rescheduled
    case completed
    case cancelled
}

// MARK: - Appointment

struct Appointment: Codable, Identifiable, Equatable {

    // No "id" field is present in the JSON, so this is synthesized from
    // stable fields to give SwiftUI something unique per row. If the
    // backend later adds a real "id", swap this out for a decoded field.
    var id: String {
        "\(userID)_\(appointmentDate)_\(appointmentTime)"
    }

    let userID: String
    let username: String
    let appointmentDate: String
    let appointmentTime: String
    let reason: String
    let status: AppointmentStatus

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username
        case appointmentDate = "appointment_date"
        case appointmentTime = "appointment_time"
        case reason
        case status
    }
}
