//
//  Network Constants.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation


enum APIEndpoint: String {
    case register = "register"
    case login = "login"
    case verifyOTP = "verify-otp"
    case profile = "profile"
    case privacyPolicy = "privacy-policy"
    case terms = "terms"
    case contacts = "contacts"
    case fcmtoken = "fcmtoken"
    case dashboard = "dashboard/today"
    case medication = "medication"
    case notificationSettings = "settings/notifications"
    case medicationOverview = "medication-overview"
    case reminderTakenByTime = "reminders/take-by-time"
}


let baseURL = "https://onqanet.net/dev_waqueel01/bossclinic/public/api/"
