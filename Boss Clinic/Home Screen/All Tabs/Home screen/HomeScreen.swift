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
    
    
    @State private var schedules: [TodaySchedule] = []
    
    
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
//            .background(Color.black.ignoresSafeArea())
//            .navigationBarBackButtonHidden(true)
//            .background()
            
            //Scroll View Ending
            
            // Loader
            if dashboardVM.isLoading {
                
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

            if schedules.count == 0 {
                isTodaySchedule = false
            } else {
                isTodaySchedule = true
            }
        }
    }
    
}

#Preview {
    HomeScreen()
}

