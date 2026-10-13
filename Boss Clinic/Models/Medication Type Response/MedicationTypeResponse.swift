//
//  MedicationTypeResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/10/26.
//

import Foundation



struct MedicationTypeResponse: Codable {
    let success: Bool
    let message: String
    let data: [MedicationTypeOption]

    enum CodingKeys: String, CodingKey {
        case success, message, data
    }

    // The app is receiving `data` as an object, not the array Postman shows.
    // Accept all likely shapes so the screen doesn't break:
    //   1. [ { value, label } ]                    → array (Postman)
    //   2. { "data": [ { value, label } ] }        → nested / paginated
    //   3. { "CAPSULES": "CAPSULES", ... }         → key-value map
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        success = (try? container.decode(Bool.self, forKey: .success)) ?? false
        message = (try? container.decode(String.self, forKey: .message)) ?? ""

        if let array = try? container.decode([MedicationTypeOption].self, forKey: .data) {
            data = array
        } else if let nested = try? container.decode(NestedData.self, forKey: .data) {
            data = nested.data
        } else if let map = try? container.decode([String: String].self, forKey: .data) {
            data = map
                .map { MedicationTypeOption(value: $0.key, label: $0.value) }
                .sorted { $0.label < $1.label }
        } else {
            data = []
        }
    }

    private struct NestedData: Codable {
        let data: [MedicationTypeOption]
    }
}

// MARK: - Medication Type Option

struct MedicationTypeOption: Codable, Identifiable, Hashable {
    let value: String   // sent to the API, e.g. "CAPSULES"
    let label: String   // shown in the dropdown

    var id: String { value }
}


