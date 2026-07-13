//
//  RegisterReqModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation



struct RegisterReqModel: Codable {
    var name: String
    var email: String
    var phone: String
    var password: String
    var confirmPassword: String
}

