//
//  RegisterErrorModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation


struct RegisterErrorModel:Codable {
    let status : Int?
    let message : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent([String].self, forKey: .message)
    }

}


struct GeneralErrorModel:Codable {
    let status : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}




struct APIErrorResponse: Codable {
    let message: String?
    let errors: APIErrors?
}

struct APIErrors: Codable {
    let email: [String]?
    let phone: [String]?
    let name: [String]?
    let password: [String]?
    let otp: [String]?
}

