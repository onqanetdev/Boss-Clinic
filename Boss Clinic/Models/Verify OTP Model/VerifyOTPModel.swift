//
//  VerifyOTPModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation


struct LoginResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: LoginData
}

// MARK: - Login Data

struct LoginData: Codable, Equatable {
    let user: LoginUser
    let token: String
}

// MARK: - Login User

struct LoginUser: Codable, Identifiable, Equatable {

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
    let emailVerifiedAt: String?
    let isActive: Bool
   // let isProfileComplete: Bool?
    let lastLoginAt: String?
    let fcmToken: String?
    //let timezone: String
    //let language: String
    //let darkMode: Bool
    let deletedAt: String?
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
        case emailVerifiedAt = "email_verified_at"
        case isActive = "is_active"
        //case isProfileComplete = "is_profile_complete"
        case lastLoginAt = "last_login_at"
        case fcmToken = "fcm_token"
        //case timezone
        //case language
        //case darkMode = "dark_mode"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


