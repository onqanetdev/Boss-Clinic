//
//  ActiveMedicationResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation


struct ActiveMedicationResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: [ActiveMedication]
}

// MARK: - Medication

struct ActiveMedication: Codable,Hashable {
    let id: String
    let userId: String
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
    let schedules: [MedicationSchedule]
    let medicationLogs: [MedicationLog]
    let refills: [MedicationRefill]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
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
        case schedules
        case medicationLogs = "medication_logs"
        case refills
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - Medication Log

struct MedicationLog: Codable, Hashable {
    let id: String
    let medicationId: String
    let userId: String
    let scheduleId: String?
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
        case medicationId = "medication_id"
        case userId = "user_id"
        case scheduleId = "schedule_id"
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


// MARK: - Schedule

struct MedicationSchedule: Codable, Hashable {
}

struct MedicationRefill: Codable, Hashable {
}
