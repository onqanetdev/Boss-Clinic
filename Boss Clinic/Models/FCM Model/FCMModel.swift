//
//  FCMModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation

// MARK: - FCM Model
struct FCMModel: Codable {
    let success: Bool
    let message: String
    let data: FCMUser
}

// MARK: - FCM User
struct FCMUser: Codable {
    let id: String
    let name: String
    let email: String
    let username: String?
    let phone: String
    let avatar: String?
    let gender: String?
    let dateOfBirth: String?
    let bloodGroup: String?
    let height: String?
    let weight: String?
    let emergencyContact: String?
    let medicalHistory: String?
    let isActive: Bool
    let isProfileComplete: Bool
    let timezone: String
    let language: String
    let darkMode: Bool
    let roles: [String]
    let permissions: [String]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case username
        case phone
        case avatar
        case gender
        case dateOfBirth = "date_of_birth"
        case bloodGroup = "blood_group"
        case height
        case weight
        case emergencyContact = "emergency_contact"
        case medicalHistory = "medical_history"
        case isActive = "is_active"
        case isProfileComplete = "is_profile_complete"
        case timezone
        case language
        case darkMode = "dark_mode"
        case roles
        case permissions
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



