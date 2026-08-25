//
//  AppointmentStatusUpdateResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 24/08/26.
//

import Foundation



struct AppointmentStatusUpdateResponse: Decodable {
    let success: Bool
    let message: String
    let data: AppointmentStatusDetail
}
 
// MARK: - Data payload
 
struct AppointmentStatusDetail: Decodable {
 
    let id: String
    let userId: String
    let doctorId: String?
    let doctorName: String?
    let appointmentDate: String   // "yyyy-MM-dd" — different format from the list endpoint's "dd-MM-yyyy"
    let appointmentTime: String   // "HH:mm:ss"
    let reason: String
    let notes: String?
    var status: AppointmentStatus
    let location: String?
    let reminderSent: Bool
    let createdAt: String         // ISO 8601, e.g. "2026-08-19T11:53:38.000000Z"
    let updatedAt: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case doctorId = "doctor_id"
        case doctorName = "doctor_name"
        case appointmentDate = "appointment_date"
        case appointmentTime = "appointment_time"
        case reason
        case notes
        case status
        case location
        case reminderSent = "reminder_sent"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
 
    // Defensive decoding: the API has previously sent `null` for fields
    // typed as non-optional elsewhere in this codebase (see the medication
    // `medication` field crash), so scalars here are decoded with fallbacks
    // rather than trusting the API's non-optional contract.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
 
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        doctorId = try container.decodeIfPresent(String.self, forKey: .doctorId)
        doctorName = try container.decodeIfPresent(String.self, forKey: .doctorName)
        appointmentDate = try container.decode(String.self, forKey: .appointmentDate)
        appointmentTime = try container.decode(String.self, forKey: .appointmentTime)
        reason = try container.decode(String.self, forKey: .reason)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        status = try container.decode(AppointmentStatus.self, forKey: .status)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        reminderSent = try container.decodeIfPresent(Bool.self, forKey: .reminderSent) ?? false
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
}
