//
//  LogoutResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import Foundation



// MARK: - Logout Response
struct LogoutResponse: Codable, Equatable {
   let success: Bool
   let message: String
   let data: EmptyData?
}

/// Placeholder type for API responses where "data" is always null.
struct EmptyData: Codable, Equatable {}
