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
    //@State private var selectedMedication: ActiveMedication?
    
   // @State private var expandedMedicationID: ActiveMedication?
    
    @State private var selectedMedication: ActiveMedication?
    
    @StateObject private var medicationVM = MedicationListViewModel()
 
    @State private var medications: [ActiveMedication] = []
    
    var body: some View {
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
     
                    // MARK: Title + Add button
                    HStack {
                        Text("All Medications")
                            .font(.custom("Inter24pt-Bold", size: 23 ))
                            .foregroundColor(.white)
     
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 16)
     
                    Divider()
                        .background(Color.white.opacity(0.2))
     
                    // MARK: Medication list
                    if medications.isEmpty {
                        emptyState
                    } else {
                        
                        ForEach(medications) { medication in
                            MedicationRow(medication: medication) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedMedication = medication
                                }
                            }

                            Divider()
                                .background(Color.white.opacity(0.2))
                        }
                        //For Each Ending
                        
                    }
     
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }

            
            if medicationVM.isLoading {

                
                MedicationSkeletonScreen()
                
            }
            
            
            // MARK: Popup overlay
                if let medication = selectedMedication {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedMedication = nil
                            }
                        }
                        .transition(.opacity)

                    MedicationDetailCard(medication: medication) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedMedication = nil
                        }
                    }
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showAddMedication) {
            Text("Add Medication")
                .foregroundColor(.white)
                .background(Color.black.ignoresSafeArea())
        }
        .onAppear {
            medicationVM.fetchMedicationList()
            
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                    print("✅ Access Token: \(accessToken)")
                } else {
                    print("❌ Access Token not found")
                }
        }
        .onChange(of: medicationVM.medicationResponse) { response in

            guard let response else { return }

            medications = response.data
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

    let medication: ActiveMedication
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                icon(size: 56, iconSize: 26)

                VStack(alignment: .leading, spacing: 4) {
                    Text(medication.name)
                        .font(.custom("Inter18pt-SemiBold", size: 14))
                        .foregroundColor(.white)

                    Text(subtitle)
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

    private var subtitle: String {
        "\(medication.dose ?? "") \(medication.medicineType ?? "") • \(medication.frequency ?? "")"
    }

    private func icon(size: CGFloat, iconSize: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: size, height: size)

            Image(systemName: "pills.fill")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(.white)
        }
    }
}


private struct MedicationDetailCard: View {

    let medication: ActiveMedication
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            HStack(alignment: .top) {
                HStack(spacing: 16) {
                    icon

                    VStack(alignment: .leading, spacing: 6) {
                        Text(medication.name)
                            .font(.custom("Inter18pt-SemiBold", size: 18))
                            .foregroundColor(.white)

                        statusBadge
                    }
                }

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    statBox(title: "Dose", value: medication.dose ?? "-")
                    statBox(title: "Type", value: (medication.medicineType ?? "-").capitalized)
                }
                HStack(spacing: 12) {
                    statBox(title: "Frequency", value: medication.frequency ?? "-")
                    statBox(title: "Remaining Stock", value: "\(medication.remainingStock ?? 0) / \(medication.totalDayStock ?? 0)")
                }
            }

            detailRow(title: "Scheduled Times", value: medication.time.joined(separator: ", "))

            HStack {
                detailColumn(title: "Start Date", value: medication.startDate ?? "-")
                Spacer()
                detailColumn(title: "End Date", value: medication.endDate ?? "-")
            }

            if !medication.instructions.orEmpty.isEmpty {
                detailRow(title: "Instructions", value: medication.instructions ?? "")
            }

            if !medication.notes.orEmpty.isEmpty {
                detailRow(title: "Notes", value: medication.notes ?? "")
            }
        }
        .padding(20)
        .background(Color(red: 0.11, green: 0.11, blue: 0.11))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.4), radius: 20, y: 10)
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 48, height: 48)

            Image(systemName: "pills.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.white)
        }
    }

    private var statusBadge: some View {
        Text(medication.status.capitalized)
            .font(.custom("Inter18pt-SemiBold", size: 12))
            .foregroundColor(statusColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.15))
            .clipShape(Capsule())
    }

    private var statusColor: Color {
        medication.status.lowercased() == "active" ? .green : .orange
    }

    private func statBox(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Inter18pt-Regular", size: 12))
                .foregroundColor(.gray)

            Text(value)
                .font(.custom("Inter18pt-SemiBold", size: 16))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Inter18pt-Regular", size: 13))
                .foregroundColor(.gray)

            Text(value)
                .font(.custom("Inter18pt-Regular", size: 14))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func detailColumn(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Inter18pt-Regular", size: 13))
                .foregroundColor(.gray)

            Text(value)
                .font(.custom("Inter18pt-Regular", size: 14))
                .foregroundColor(.white)
        }
    }
}



#Preview {
    NavigationStack {
        AppointmentScreen()
    }
}



