//
//  Schedule.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import Foundation
import SwiftUI


struct Schedule: Identifiable {
    let id = UUID()
    let time: String
    let medicineName: String
    let status: ScheduleStatus
}

enum ScheduleStatus {
    case taken
    case upcoming

    var title: String {
        switch self {
        case .taken:
            return "Taken"
        case .upcoming:
            return "Upcoming"
        }
    }

    var color: Color {
        switch self {
        case .taken:
            return .green
        case .upcoming:
            return Color.gray
        }
    }
}


