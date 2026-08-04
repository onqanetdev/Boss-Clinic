//
//  String+Date_Formatter.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 04/08/26.
//



import Foundation

extension String {

    /// Converts "2026-07-29T05:05:14.000000Z" → "29 July 2026"
    var asFormattedDate: String {

        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(identifier: "UTC")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"

        guard let date = inputFormatter.date(from: self) else {
            return self   // fallback: show raw string if parsing fails
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        return outputFormatter.string(from: date)
    }
}
