//
//  HomeScreenAlertsModifier.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/08/26.
//

import Foundation
import SwiftUI



struct HomeScreenAlertsModifier: ViewModifier {

    @Binding var showSuccessAlert: Bool
    @Binding var showOfflineAlert: Bool
    let successMessage: String

    func body(content: Content) -> some View {
        content
            .modifier(SuccessAlertModifier(isPresented: $showSuccessAlert, message: successMessage))
            .modifier(OfflineAlertModifier(isPresented: $showOfflineAlert))
    }
}

private struct SuccessAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String

    func body(content: Content) -> some View {
        content.alert("Success", isPresented: $isPresented, actions: successActions) {
            Text(message)
        }
    }

    private func successActions() -> some View {
        Button("OK", role: .cancel) { }
    }
}

private struct OfflineAlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content.alert("No Internet Connection", isPresented: $isPresented, actions: offlineActions) {
            Text("Please check your internet connection and try again.")
        }
    }

    private func offlineActions() -> some View {
        Button("OK", role: .cancel) { }
    }
}

extension View {
    func homeScreenAlerts(
        showSuccessAlert: Binding<Bool>,
        showOfflineAlert: Binding<Bool>,
        successMessage: String
    ) -> some View {
        modifier(
            HomeScreenAlertsModifier(
                showSuccessAlert: showSuccessAlert,
                showOfflineAlert: showOfflineAlert,
                successMessage: successMessage
            )
        )
    }
}
