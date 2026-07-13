//
//  NetworkErrors.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation



enum NetworkError: LocalizedError {
    case urlError
    case decodingError
    case serverError
    case responsErr
    case validationError(String)
    case unauthorized
   // case couponAlreadyApplied(CouponAlreadyAppliedResModel)
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "Invalid URL"
        case .decodingError:
            return "Failed to decode response"
        case .serverError:
            return "Server returned an error"
        case .responsErr:
            return "Response is not getting fetched"
        case .unauthorized:
            return "Access Token is Invalid"
        case .validationError(let msg):
            return msg
//        case .couponAlreadyApplied(let res):
//            return res.message
        }
    }
    
    
}


enum NotificationScreenType {
    case notification
    case coupon
}


