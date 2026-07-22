//
//  RegisterResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation


// MARK: - Register Response
struct RegisterResponse: Codable {
    let success: Bool
    let message: String
    let data: RegisterData
}

// MARK: - Register Data
struct RegisterData: Codable {
    let message: String
    let phone: String
    let otp: String
}



