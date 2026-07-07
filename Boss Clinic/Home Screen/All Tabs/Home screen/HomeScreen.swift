//
//  HomeScreen.swift
//  Boss Clinic
//
//  Created by Onqanet on 26/06/26.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var isScheduled: Bool = false
    @State var isTodaySchedule: Bool = false
    
    let schedules = [

            Schedule(
                time: "9:00 AM",
                medicineName: "Lisinopril 10 mg",
                status: .taken
            ),

            Schedule(
                time: "1:00 PM",
                medicineName: "Metformin 500 mg",
                status: .upcoming
            ),

            Schedule(
                time: "6:00 PM",
                medicineName: "Atorvastatin 20 mg",
                status: .upcoming
            ),

            Schedule(
                time: "10:00 PM",
                medicineName: "Vitamin D",
                status: .upcoming
            )
        ]
    
    
    var body: some View {
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
                    NextMedicationCardView()
                } else {
                    NoMedicationCardView()
                }
                
                if isTodaySchedule {
                    TodaysScheduleView(schedules: schedules)
                } else {
                    EmptyTodayScheduleView()
                }
                
                RefillReminderCardView()
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .background()
    }
}

#Preview {
    HomeScreen()
}

