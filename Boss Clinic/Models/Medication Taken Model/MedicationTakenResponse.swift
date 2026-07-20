//
//  MedicationTakenResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/07/26.
//

import Foundation




struct MedicationTakenResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: MedicationTakenData
}

// MARK: - Data

struct MedicationTakenData: Codable, Equatable {
    let id: String
    let medicationID: String
    let userID: String
    let scheduleID: String?
    let scheduledDate: String
    let scheduledTime: String
    let actualTakenTime: String?
    let status: String
    let differenceMinutes: Int?
    let notes: String?
    let takenBy: String?
    let skippedReason: String?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case medicationID = "medication_id"
        case userID = "user_id"
        case scheduleID = "schedule_id"
        case scheduledDate = "scheduled_date"
        case scheduledTime = "scheduled_time"
        case actualTakenTime = "actual_taken_time"
        case status
        case differenceMinutes = "difference_minutes"
        case notes
        case takenBy = "taken_by"
        case skippedReason = "skipped_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

