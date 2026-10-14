//
//  DashboardResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation



// MARK: - Dashboard Response
struct DashboardResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: DashboardData
}

// MARK: - Dashboard Data
struct DashboardData: Codable, Equatable {
    let nextMedication: NextMedication?
    let todaySchedule: [TodaySchedule]
    let refillReminders: [RefillReminder]
    let summary: DashboardSummary
    let meta: DashboardMeta?

    enum CodingKeys: String, CodingKey {
        case nextMedication = "next_medication"
        case todaySchedule = "today_schedule"
        case refillReminders = "refill_reminders"
        case summary
        case meta
    }
}

// MARK: - Next Medication
struct NextMedication: Codable, Equatable {
    let medicineId: String
    let name: String
    let strength: String?          // ⚠️ can be null
    let time: String
    let status: String
    let logId: String?
    let buttonText: String

    enum CodingKeys: String, CodingKey {
        case medicineId = "medicine_id"
        case name
        case strength
        case time
        case status
        case logId = "log_id"
        case buttonText = "button_text"
    }
}

// MARK: - Today's Schedule
struct TodaySchedule: Codable, Identifiable, Equatable {

    // The same medicine can appear more than once at the same time
    // (e.g. FOAM at 08:00 three times), so each row gets its own ID.
    // Not part of CodingKeys, so it isn't decoded from the API.
    var id = UUID()

    let time: String
    let medicineName: String
    let strength: String?          // ⚠️ can be null
    let status: String

    enum CodingKeys: String, CodingKey {
        case time
        case medicineName = "medicine_name"
        case strength
        case status
    }

    // Compare the API data only, not the generated ID
    static func == (lhs: TodaySchedule, rhs: TodaySchedule) -> Bool {
        lhs.time == rhs.time &&
        lhs.medicineName == rhs.medicineName &&
        lhs.strength == rhs.strength &&
        lhs.status == rhs.status
    }
}

// MARK: - Refill Reminder
struct RefillReminder: Codable, Equatable, Identifiable {
    let medicineId: String
    let medicineName: String
    let remainingStock: Int
    let daysLeft: Int
    let buttonText: String

    var id: String { medicineId }

    enum CodingKeys: String, CodingKey {
        case medicineId = "medication_id"
        case medicineName = "medicine_name"
        case remainingStock = "remaining_stock"
        case daysLeft = "days_left"
        case buttonText = "button_text"
    }
}

// MARK: - Dashboard Summary
struct DashboardSummary: Codable, Equatable {
    let todayTotal: Int
    let taken: Int
    let pending: Int
    let upcoming: Int
    let missed: Int

    enum CodingKeys: String, CodingKey {
        case todayTotal = "today_total"
        case taken
        case pending
        case upcoming
        case missed
    }
}

// MARK: - Pagination Meta
struct DashboardMeta: Codable, Equatable {
    let currentPage: Int
    let lastPage: Int
    let perPage: Int
    let total: Int
    let from: Int?                 // null when the list is empty
    let to: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total
        case from
        case to
    }
}


