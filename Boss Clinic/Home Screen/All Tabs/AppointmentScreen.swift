//
//  AppointmentScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 30/06/26.
//


import SwiftUI
 
// MARK: - Model
 
struct Medication: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subtitle: String
}
 
// MARK: - Screen
 
struct AppointmentScreen: View {
 
    @State private var showAddMedication = false
    @State private var selectedMedication: Medication?
 
    // TODO: Replace with real data from your view model / API
    @State private var medications: [Medication] = [
          Medication(name: "Amoxicillin 500 mg", subtitle: "1 Tablet • Everyday"),
          Medication(name: "Metformin 500 mg", subtitle: "1 Tablet • Everyday"),
          Medication(name: "Atorvastatin 20 mg", subtitle: "1 Tablet • Everyday"),
          Medication(name: "Lisinopril 10 mg", subtitle: "1 Tablet • Everyday")
      ]
 
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
 
                // MARK: Title + Add button
                HStack {
                    Text("All Medications")
                        .font(.custom("Inter24pt-Bold", size: 23 ))
                        .foregroundColor(.white)
 
                    Spacer()
 
//                    Button {
//                        showAddMedication = true
//                    } label: {
//                        Image(systemName: "plus")
//                            .font(.system(size: 22, weight: .semibold))
//                            .foregroundColor(.white)
//                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
 
                Divider()
                    .background(Color.white.opacity(0.2))
 
                // MARK: Medication list
                if medications.isEmpty {
                    emptyState
                } else {
                    ForEach(Array(medications.enumerated()), id: \.element.id) { index, medication in
                        MedicationRow(medication: medication) {
                            selectedMedication = medication
                        }
 
                        Divider()
                            .background(Color.white.opacity(0.2))
                    }
                }
 
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showAddMedication) {
            Text("Add Medication")
                .foregroundColor(.white)
                .background(Color.black.ignoresSafeArea())
        }
        .navigationDestination(item: $selectedMedication) { medication in
            Text(medication.name)
                .foregroundColor(.white)
                .background(Color.black.ignoresSafeArea())
        }
    }
 
    // MARK: - Empty state
 
    private var emptyState: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 72, height: 72)
 
                Image(systemName: "pills")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.bottom, 4)
 
            Text("No medications yet")
                .font(.custom("Inter18pt-SemiBold", size: 17))
                .foregroundColor(.white)
 
            Text("Tap the + button above to add your first medication.")
                .font(.custom("Inter18pt-Regular", size: 14))
                .foregroundColor(Color.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
 
// MARK: - Row
 
private struct MedicationRow: View {
 
    let medication: Medication
    let action: () -> Void
 
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 56, height: 56)
 
                    Image(systemName: "pills.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                }
 
                VStack(alignment: .leading, spacing: 4) {
                    Text(medication.name)
                        .font(.custom("Inter18pt-SemiBold", size: 14))
                        .foregroundColor(.white)
 
                    Text(medication.subtitle)
                        .font(.custom("Inter18pt-Regular", size: 13))
                        .foregroundColor(Color.white.opacity(0.5))
                }
 
                Spacer()
 
                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}
 
#Preview {
    NavigationStack {
        AppointmentScreen()
    }
}


