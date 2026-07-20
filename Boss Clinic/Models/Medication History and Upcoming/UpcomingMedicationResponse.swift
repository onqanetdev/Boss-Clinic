//
//  UpcomingMedicationResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/07/26.
//

import Foundation



// MARK: - Root Response
struct UpcomingMedicationResponse: Codable,Equatable {
    let success: Bool
    let message: String
    let data: UpcomingMedicationData
}

// MARK: - Data
struct UpcomingMedicationData: Codable,Equatable {
    let type: String
    let dates: [UpcomingMedicationDate]
    let meta: PaginationMetaData
}

// MARK: - Date Section
struct UpcomingMedicationDate: Codable, Identifiable, Equatable {
    var id: String { date }

    let date: String
    let day: String
    let total: Int
    let logs: [UpcomingMedication]
}

// MARK: - Medication Log
struct UpcomingMedication: Codable, Identifiable, Equatable {
    var id: String { medicationID + "_" + time }

    let time: String
    let medicationName: String
    let strength: String
    let status: String
    let medicationID: String

    enum CodingKeys: String, CodingKey {
        case time
        case medicationName = "medication_name"
        case strength
        case status
        case medicationID = "medication_id"
    }
}

// MARK: - Pagination
struct PaginationMetaData: Codable, Equatable {
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
