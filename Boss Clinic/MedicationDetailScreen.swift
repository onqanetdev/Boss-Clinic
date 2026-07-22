//
//  MedicationDetailScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import SwiftUI

struct MedicationDetailScreen: View {

    let medication: ActiveMedication

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 24) {

                    header

                    medicineCard

                    medicationInformation

                    stockInformation

                    reminderInformation

                    if !medication.notes.orEmpty.isEmpty {
                        notesSection
                    }

                    if !medication.instructions.orEmpty.isEmpty {
                        instructionSection
                    }

                    Spacer(minLength: 30)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}



private extension MedicationDetailScreen {

    var header: some View {

        HStack {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }

            Text("Medication Details")
                .font(.custom("Inter24pt-Bold", size: 24))
                .foregroundColor(.white)

            Spacer()
        }
    }
}

private extension MedicationDetailScreen {

    var medicineCard: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Image(systemName: "pills.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)

                VStack(alignment: .leading) {

                    Text(medication.name)
                        .font(.custom("Inter18pt-SemiBold", size: 22))
                        .foregroundColor(.white)

                    Text(medication.medicineType.capitalized)
                        .foregroundColor(.gray)
                }

                Spacer()
            }

            Divider()

            HStack {

                detailItem(title: "Strength", value: medication.strength)

                Spacer()

                detailItem(title: "Dose", value: medication.dose)
            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


private extension MedicationDetailScreen {

    var medicationInformation: some View {

        VStack(alignment: .leading, spacing: 18) {

            sectionTitle("Medication")

            infoRow("Frequency", medication.frequency)

            infoRow("Start Date", medication.startDate)

            infoRow("End Date", medication.endDate)

            infoRow("Status", medication.status.capitalized)

            infoRow("Times", medication.time.joined(separator: ", "))
        }
    }
}


private extension MedicationDetailScreen {

    var stockInformation: some View {

        VStack(alignment: .leading, spacing: 18) {

            sectionTitle("Stock")

            infoRow("Remaining", "\(medication.remainingStock)")

            infoRow("Today's Stock", "\(medication.totalDayStock)")

            infoRow("Taken Today", "\(medication.takenDayStock)")

            infoRow("Refill Quantity", "\(medication.refillQuantity)")

            infoRow("Refill Threshold", "\(medication.refillThreshold)")
        }
    }
}


private extension MedicationDetailScreen {

    var reminderInformation: some View {

        VStack(alignment: .leading, spacing: 18) {

            sectionTitle("Reminder")

            infoRow(
                "Reminder",
                medication.isRefillReminderEnabled ? "Enabled" : "Disabled"
            )
        }
    }
}


private extension MedicationDetailScreen {

    var notesSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Notes")

            Text(medication.notes ?? "")
                .foregroundColor(.white.opacity(0.8))
        }
    }

    var instructionSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Instructions")

            Text(medication.instructions ?? "")
                .foregroundColor(.white.opacity(0.8))
        }
    }
}



private extension MedicationDetailScreen {

    func sectionTitle(_ title: String) -> some View {

        Text(title)
            .font(.custom("Inter18pt-SemiBold", size: 18))
            .foregroundColor(.white)
    }

    func infoRow(_ title: String, _ value: String) -> some View {

        HStack {

            Text(title)
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .foregroundColor(.white)
        }
    }

    func detailItem(title: String, value: String) -> some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(title)
                .foregroundColor(.gray)

            Text(value)
                .foregroundColor(.white)
        }
    }
}




extension Optional where Wrapped == String {

    var orEmpty: String {
        self ?? ""
    }
}
