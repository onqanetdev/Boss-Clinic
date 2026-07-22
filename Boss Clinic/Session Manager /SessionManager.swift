//
//  SessionManager.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import Foundation


final class SessionManager: ObservableObject {
 
    static let shared = SessionManager()
 
    @Published var isLoggedIn: Bool
 
    private init() {
        isLoggedIn = UserDefaults.standard.string(forKey: "accessToken") != nil
    }
 
    /// Call this whenever an API responds 401, or on a manual logout.
    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
 
        DispatchQueue.main.async {
            print("🔐 SessionManager.logout() called — isLoggedIn -> false")
            self.isLoggedIn = false
        }
    }
 
    /// Call this once VerifyOTP/Login succeeds and a token is saved.
    func login() {
        DispatchQueue.main.async {
            self.isLoggedIn = true
        }
    }
}
 
