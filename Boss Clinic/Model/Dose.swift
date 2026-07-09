//
//  Dose.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 09/07/26.
//

import Foundation


struct DoseReminder: Identifiable {
    let id: String            // medicationId, also used as Identifiable id for fullScreenCover(item:)
    let medicationName: String
    let dosageText: String    // e.g. "1 Tablet"
    let scheduledTime: String // e.g. "10:00 AM" — already formatted, ready to display
}

