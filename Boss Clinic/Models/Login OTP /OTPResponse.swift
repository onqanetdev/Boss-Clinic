//
//  OTPResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation


struct OTPResponse: Codable, Equatable {
    let success: Bool
    let message: String
    let data: OTPData
}

// MARK: - OTP Data
struct OTPData: Codable, Equatable {
    let message: String
    let phone: String
    let otp: String
}


