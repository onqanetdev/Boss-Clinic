//
//  DashboardObserversModifier.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/08/26.
//

import Foundation
import SwiftUI



struct DashboardObserversModifier: ViewModifier {

    @ObservedObject var dashboardVM: DashboardViewModel
    @ObservedObject var reminderTakenVM: ReminderTakenViewModel
    @ObservedObject var requestRefillVM: RefillRequestViewModel
    @ObservedObject var notificationCountVM: NotificationCountViewModel
    @ObservedObject var newsletterVM: NewsletterViewModel

    let onOfflineChange: (Bool) -> Void
    let onDashboardResponse: (DashboardResponse?) -> Void
    let onReminderTakenResponse: (MedicationTakenResponse?) -> Void
    let onReminderError: (String?) -> Void
    let onRefillResponse: (RefillRequestResponse?) -> Void
    let onNotificationCountResponse: (NotificationCountResponse?) -> Void
    let onNewsletterResponse: (NewsletterResponse?) -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: dashboardVM.dashboardResponse, perform: onDashboardResponse)
            .onChange(of: dashboardVM.isOffline, perform: onOfflineChange)
            .onChange(of: reminderTakenVM.reminderTakenResponse, perform: onReminderTakenResponse)
            .onChange(of: reminderTakenVM.errorMessage, perform: onReminderError)
            .onChange(of: reminderTakenVM.isOffline, perform: onOfflineChange)
            .onChange(of: requestRefillVM.refillRequestResponse, perform: onRefillResponse)
            .onChange(of: requestRefillVM.isOffline, perform: onOfflineChange)
            .onChange(of: notificationCountVM.notificationCountResponse, perform: onNotificationCountResponse)
            .onChange(of: notificationCountVM.isOffline, perform: onOfflineChange)
            .onChange(of: newsletterVM.newsletterResponse, perform: onNewsletterResponse)
            .onChange(of: newsletterVM.isOffline, perform: onOfflineChange)
    }
}





