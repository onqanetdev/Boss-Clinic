//
//  AppointmentStatusViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 25/08/26.
//

import Foundation



final class AppointmentStatusViewModel: ObservableObject {

    // MARK: - Published state

    @Published var isUpdating: Bool = false
    @Published var isOffline: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Dependencies

    private let apiCaller: AppointmentStatusAPICaller

    init(apiCaller: AppointmentStatusAPICaller = .shared) {
        self.apiCaller = apiCaller
    }

    // MARK: - Update status

    /// Cancels, confirms, reschedules, or requests a call back for an appointment.
    /// - Parameters:
    ///   - appointmentId: The appointment's `id`.
    ///   - type: `.cancel`, `.confirm`, `.reschedule`, or `.call`.
    ///   - notes: Optional note — required for `.reschedule`, ignored/omitted for `.call`.
    ///   - onSuccess: Called with the updated appointment detail on success,
    ///     so the caller can update its local list/state without a full refetch.
    func updateStatus(
        appointmentId: String,
        type: AppointmentActionType,
        notes: String? = nil,
        onSuccess: ((AppointmentStatusDetail) -> Void)? = nil
    ) {

        // Reschedule requires a reason — never hit the API with empty notes.
        if type == .reschedule {
            let trimmed = notes?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !trimmed.isEmpty else {
                errorMessage = "Please add a note before rescheduling."
                return
            }
        }

        // Guard against double-taps firing duplicate requests.
        guard !isUpdating else { return }

        isUpdating = true
        errorMessage = nil

        apiCaller.updateAppointmentStatus(
            appointmentId: appointmentId,
            type: type,
            notes: notes
        ) { [weak self] result in

            guard let self else { return }

            self.isUpdating = false

            switch result {

            case .success(let response):
                onSuccess?(response.data)

            case .failure(let error):
                self.handle(error)
            }
        }
    }

    // MARK: - Error handling

    private func handle(_ error: NetworkError) {

        switch error {

        case .noInternet:
            isOffline = true

        case .urlError:
            errorMessage = "Something went wrong. Please try again."

        case .serverError:
            errorMessage = "Something went wrong. Please try again."

        case .responsErr:
            errorMessage = "Something went wrong. Please try again."

        case .decodingError:
            errorMessage = "Unable to process the response."

        case .unauthorized:
            // SessionManager.shared.logout() is already triggered by the
            // API caller on 401 — just surface the message here.
            errorMessage = "Session expired. Please login again."

        case .validationError(let message):
            errorMessage = message
        }
    }
}
