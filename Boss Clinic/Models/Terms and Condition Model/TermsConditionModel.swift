//
//  TermsConditionModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation


struct TermsConditionModel: Codable, Equatable {
    
    let success: Bool
    let message: String
    let data: TermsConditionData
}

// MARK: - Terms & Condition Data

struct TermsConditionData: Codable, Equatable {
    
    let title: String
    let lastUpdated: String
    let appName: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case lastUpdated = "last_updated"
        case appName = "app_name"
        case content
    }
}

