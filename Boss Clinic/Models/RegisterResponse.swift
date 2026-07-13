//
//  RegisterResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation


struct RegisterResponse: Codable {
    let success: Bool
    let message: String
    let data: RegisterData
}

// MARK: - Register Data
struct RegisterData: Codable {
    let user: User
    let token: String
}

// MARK: - User
struct User: Codable {
    let name: String
    let email: String
    let phone: String
    let isActive: Bool
    let id: String
    let updatedAt: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case isActive = "is_active"
        case id
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}
