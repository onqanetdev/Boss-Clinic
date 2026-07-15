//
//  Contact_us_model.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation



struct ContactUsModel: Codable {
    let success: Bool
    let message: String
    let data: ContactUsData
}

struct ContactUsData: Codable {
    let id: String
    let name: String
    let email: String
    let message: String
    let readAt: String?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case message
        case readAt = "read_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

