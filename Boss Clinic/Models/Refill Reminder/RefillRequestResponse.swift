//
//  RefillRequestResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import Foundation



// MARK: - Refill Request Response
struct RefillRequestResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: RefillRequestData
}

// MARK: - Refill Request Data
struct RefillRequestData: Codable, Equatable {
    let refillId: String
    let medicationId: String
    let medicineName: String
    let remainingDays: Int
    let schedule: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case refillId = "refill_id"
        case medicationId = "medication_id"
        case medicineName = "medicine_name"
        case remainingDays = "remaining_days"
        case schedule
        case status
    }
}



