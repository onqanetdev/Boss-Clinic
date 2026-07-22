//
//  Validator.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import Foundation

enum Validators {
 
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
            .evaluate(with: email)
    }
 
    static func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            .evaluate(with: phone)
    }
}
 
