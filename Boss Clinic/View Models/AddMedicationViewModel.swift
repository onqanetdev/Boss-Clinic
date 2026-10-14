//
//  AddMedicationViewModel.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/10/26.
//

import Foundation


class AddMedicationViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var isOffline = false
    @Published var errorMessage: String?
    @Published var addResponse: AddMedicationResponse?

    // API expects "2026-10-16"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func addMedications(entries: [AddMedicationEntry]) {

        guard !isLoading else { return }

        isLoading = true
        isOffline = false
        errorMessage = nil

        let medicines: [[String: Any]] = entries.map { entry in
            [
                "name": entry.type,                              // no name field — API uses the type as the name
                "medicine_type": entry.type,
                "dose": "\(entry.dosesPerDay)",                  // number of timings per day
                "frequency": entry.frequency,
                "times": entry.times.map(\.requestValue),        // ["08:00 AM", "02:00 PM", ...]
                "start_date": dateFormatter.string(from: entry.startDate),
                "end_date": entry.endDate.map { dateFormatter.string(from: $0) } ?? "",
                "taken_day_stock": entry.takenDosesValue
            ]
        }

        AddMedicationAPICaller.shared.addMedications(medicines: medicines) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let response):
                self.addResponse = response

            case .failure(let error):
                switch error {
                case .noInternet:
                    self.isOffline = true
                case .validationError(let message):
                    self.errorMessage = message
                default:
                    self.errorMessage = "Something went wrong. Please try again."
                }
            }
        }
    }
}

