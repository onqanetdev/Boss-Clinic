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
    case called
    case confirmed
    case unknown
}

// MARK: - Appointment

struct Appointment: Codable, Identifiable, Equatable {

    // The API does include a real "id" field, so this is decoded
    // directly rather than synthesized.
    let id: String
    let userID: String
    let username: String
    var appointmentDate: String   // "yyyy-MM-dd"
    var appointmentTime: String   // "HH:mm:ss"
    let reason: String
    var notes: String?
    var status: AppointmentStatus

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case username
        case appointmentDate = "appointment_date"
        case appointmentTime = "appointment_time"
        case reason
        case notes
        case status
    }
}
