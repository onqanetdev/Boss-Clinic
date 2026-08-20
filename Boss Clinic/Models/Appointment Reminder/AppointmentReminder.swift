//
//  AppointmentReminder.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 11/08/26.
//

import Foundation




/// Mirrors DoseReminder's shape/role — populated from the "appointment"
/// notification's data payload by NotificationRouter, and presented via
/// RootView's `.fullScreenCover(item: $notificationRouter.pendingAppointment)`.
struct AppointmentReminder: Identifiable, Equatable {
    let id: String
    let doctorName: String
    let appointmentDate: String
    let appointmentTime: String
 
    /// The notification's actual alert body text (e.g. "Your appointment
    /// Scheduled at (Tuesday, August 11, 2026 at 17:29)."). This is often
    /// more complete than the structured fields alone — doctor_name can
    /// arrive empty depending on the notification type (booked vs.
    /// reminder), but the body text is always fully composed server-side.
    let bodyMessage: String
    let status: String 
}

