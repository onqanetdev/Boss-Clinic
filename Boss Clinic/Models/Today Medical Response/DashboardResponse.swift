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
    let nextMedication: NextMedication
    let todaySchedule: [TodaySchedule]
    let refillReminders: [RefillReminder]
    let summary: DashboardSummary

    enum CodingKeys: String, CodingKey {
        case nextMedication = "next_medication"
        case todaySchedule = "today_schedule"
        case refillReminders = "refill_reminders"
        case summary
    }
}

// MARK: - Next Medication
struct NextMedication: Codable, Equatable {
    let medicineId: String
    let name: String
    let strength: String
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
struct TodaySchedule: Codable, Identifiable , Equatable{
    
    var id: String {
            "\(time)-\(medicineName)"
        }
    
    let time: String
    let medicineName: String
    let strength: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case time
        case medicineName = "medicine_name"
        case strength
        case status
    }
}

// MARK: - Refill Reminder
struct RefillReminder: Codable, Equatable {
    let medicineName: String
    let remainingStock: Int
    let daysLeft: Int
    let buttonText: String

    enum CodingKeys: String, CodingKey {
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


