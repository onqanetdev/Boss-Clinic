//
//  MedicationHistoryResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/07/26.
//

import Foundation

struct MedicationHistoryResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: MedicationHistoryData
}

// MARK: - Data
struct MedicationHistoryData: Codable, Equatable {
    let type: String
    let history: [MedicationHistory]
    let meta: PaginationMeta
}

// MARK: - History
struct MedicationHistory: Codable, Identifiable, Equatable {
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
    let medication: MedicationData
    let schedule: ScheduleData?
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
        case medication
        case schedule
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Medication
struct MedicationData: Codable, Identifiable, Equatable {
    let id: String
    let userID: String
    let name: String
    let medicineType: String
    let strength: String
    let dose: String
    let frequency: String
    let time: [String]
    let durationDays: Int?
    let startDate: String
    let endDate: String
    let notes: String?
    let instructions: String?
    let doctorName: String?
    let pharmacy: String?
    let prescriptionImage: String?
    let refillQuantity: Int
    let refillThreshold: Int
    let remainingStock: Int
    let totalDayStock: Int
    let takenDayStock: Int
    let isRefillReminderEnabled: Bool
    let status: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case medicineType = "medicine_type"
        case strength
        case dose
        case frequency
        case time
        case durationDays = "duration_days"
        case startDate = "start_date"
        case endDate = "end_date"
        case notes
        case instructions
        case doctorName = "doctor_name"
        case pharmacy
        case prescriptionImage = "prescription_image"
        case refillQuantity = "refill_quantity"
        case refillThreshold = "refill_threshold"
        case remainingStock = "remaining_stock"
        case totalDayStock = "total_day_stock"
        case takenDayStock = "taken_day_stock"
        case isRefillReminderEnabled = "is_refill_reminder_enabled"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//// MARK: - Schedule
struct ScheduleData: Codable, Equatable {
    // API currently returns null.
    // Add properties here if the backend starts sending schedule details.
}

// MARK: - Pagination
struct PaginationMeta: Codable, Equatable {
    let currentPage: Int
    let lastPage: Int
    let perPage: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total
    }
}
