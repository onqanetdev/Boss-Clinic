//
//  TodaysScheduleListScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import SwiftUI

struct TodaysScheduleListScreen: View {
 
    let schedules: [TodaySchedule]
 
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
 
            // MARK: Header
            HStack(spacing: 16) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }
 
                Text("Today's Schedule")
                    .font(.custom("Inter24pt-Bold", size: 28))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
 
            // MARK: List
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
 
                    ForEach(Array(schedules.enumerated()), id: \.element.id) { index, schedule in
 
                        ScheduleRowView(schedule: schedule)
                            .padding(.vertical, 14)
 
                        if index != schedules.count - 1 {
                            Divider()
                                .background(Color.white.opacity(0.15))
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
 
#Preview {
    NavigationStack {
        TodaysScheduleListScreen(schedules: [])
    }
}
