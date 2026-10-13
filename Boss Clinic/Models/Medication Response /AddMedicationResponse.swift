//
//  AddMedicationResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/10/26.
//

import Foundation




struct AddMedicationResponse: Codable {
    let success: Bool
    let message: String
    let data: [AddedMedication]?
}

// MARK: - Added Medication
// Fields the API can send as null are optional so decoding never fails on them.

struct AddedMedication: Codable, Identifiable {
    let id: String
    let userID: String?
    let name: String?
    let medicineType: String?
    let strength: String?
    let dose: String?
    let frequency: String?
    let time: [String]?
    let startDate: String?
    let endDate: String?
    let remainingStock: Int?
    let totalDayStock: Int?
    let takenDayStock: Int?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case medicineType = "medicine_type"
        case strength
        case dose
        case frequency
        case time
        case startDate = "start_date"
        case endDate = "end_date"
        case remainingStock = "remaining_stock"
        case totalDayStock = "total_day_stock"
        case takenDayStock = "taken_day_stock"
        case status
    }
}

// MARK: - Notification

extension Notification.Name {
    static let medicationAdded = Notification.Name("medicationAdded")
}
