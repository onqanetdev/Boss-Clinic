//
//  HomeScreen.swift
//  Boss Clinic
//
//  Created by Onqanet on 26/06/26.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var isScheduled: Bool = true
    @State var isTodaySchedule: Bool = true
    @StateObject private var dashboardVM = DashboardViewModel()
    
    @StateObject private var reminderTakenVM = ReminderTakenViewModel()
    
    
    @State private var schedules: [TodaySchedule] = []
    @State var nextMedication: NextMedication?
    @State var refillReminder: [RefillReminder] = []
    
    
    var body: some View {
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    HStack {
                        Text("Hello, Jhon 👋🏽")
                            .font(.custom("Inter18pt-SemiBold", size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                        
                        Button {
                            print("Notification tapped")
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                
                                Image(systemName: "bell")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .offset(x: -2, y: -3)
                            }
                        }
                    }
                    // NextMedicationCardView()
                    
                    if isScheduled {
                        NextMedicationCardView(
                            receiveNextMedication: nextMedication
                        ) {

                            guard let medication = nextMedication else { return }

                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"

                            let today = formatter.string(from: Date())

                            reminderTakenVM.markReminderAsTaken(
                                medicationID: medication.medicineId,
                                time: medication.time,
                                scheduledDate: today
                            )
                        }
                    } else {
                        NoMedicationCardView()
                    }
                    
                    if isTodaySchedule {
                        TodaysScheduleView(schedules: schedules)
                    } else {
                        EmptyTodayScheduleView()
                    }
                    
                    refillSection
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            // Loader
            if dashboardVM.isLoading || reminderTakenVM.isLoading  {
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.5)
            }
            
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear {

            dashboardVM.fetchDashboard()
        }
        
        .onChange(of: dashboardVM.dashboardResponse) { response in

            guard let response else { return }

            schedules = response.data.todaySchedule
            
            nextMedication = response.data.nextMedication
            
            refillReminder = response.data.refillReminders
            
            if nextMedication != nil {
                isScheduled = true
            } else {
                isScheduled = false
            }

            if schedules.count == 0 {
                isTodaySchedule = false
            } else {
                isTodaySchedule = true
            }
        }
        
        .onChange(of: reminderTakenVM.reminderTakenResponse) { response in

            guard let response else { return }

            print(response.message)

            dashboardVM.fetchDashboard()
        }
        
        .onChange(of: reminderTakenVM.errorMessage) { error in

            guard let error else { return }

            print(error)
        }
    }
    
    
    
    private var refillSection: some View {
        ForEach(refillReminder) { medication in
            RefillReminderCardView(
                medication: medication,
                onTappedRefill: {
                    print("Hellow")
                }
            )
        }
    }

}

#Preview {
    HomeScreen()
}

