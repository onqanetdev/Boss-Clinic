//
//  BookAppointmentResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 31/07/26.
//

import Foundation



struct BookAppointmentResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: BookAppointmentData
}

// MARK: - Appointment Data

struct BookAppointmentData: Codable, Identifiable, Equatable {

    let id: String
    let userId: String
    let doctorId: String?
    let doctorName: String?
    let appointmentDate: String
    let appointmentTime: String
    let reason: String
    let notes: String?
    let status: String
    let location: String?
    let reminderSent: Bool?
    let createdAt: String
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
}


