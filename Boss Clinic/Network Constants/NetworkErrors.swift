//
//  NetworkErrors.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation
import Network



enum NetworkError: LocalizedError {
    case urlError
    case decodingError
    case serverError
    case responsErr
    case noInternet
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
        case .noInternet:
            return "No Internet Connection"
//        case .couponAlreadyApplied(let res):
//            return res.message
        }
    }
    
    
}


enum NotificationScreenType {
    case notification
    case coupon
}




final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}



enum MedicationTypeAPIError: LocalizedError {
    case offline
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .offline:
            return "No internet connection."
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid response from server."
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .serverError(let code):
            return "Something went wrong (\(code)). Please try again."
        }
    }
}
