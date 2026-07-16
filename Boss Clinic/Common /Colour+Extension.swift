//
//  Colour+Extension.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation
import SwiftUI


extension String {

    var color: Color {

        switch self.lowercased() {

        case "taken":
            return .green

        case "missed":
            return .red

        case "upcoming":
            return .yellow

        default:
            return .gray
        }
    }
}
