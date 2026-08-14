//
//  TodaysScheduleView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI



struct TodaysScheduleView: View {

    let schedules: [TodaySchedule]

    @State private var showAllSchedules = false

    /// Capped once, up front, instead of recomputing `schedules.prefix(3)`
    /// inline inside the ForEach expression.
    private var visibleSchedules: [TodaySchedule] {
        Array(schedules.prefix(3))
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            scheduleListView
        }
        .padding(10)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .navigationDestination(isPresented: $showAllSchedules) {
            TodaysScheduleListScreen(schedules: schedules)
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            Text("Today's Schedule")
                .font(.custom("Inter18pt-Bold", size: 17))
                .foregroundColor(.white)

            Spacer()

            if schedules.count > 3 {
                Button("View all") {
                    showAllSchedules = true
                }
                .font(.custom("Inter18pt-Regular", size: 16))
                .foregroundColor(.white)
            }
        }
        .padding(.bottom, 20)
    }

    private var scheduleListView: some View {
        ForEach(visibleSchedules.indices, id: \.self) { index in
            scheduleRow(for: visibleSchedules[index], at: index)
        }
    }

    @ViewBuilder
    private func scheduleRow(for schedule: TodaySchedule, at index: Int) -> some View {
        ScheduleRowView(schedule: schedule)

        if index != visibleSchedules.count - 1 {
            Divider()
                .background(Color.white.opacity(0.15))
        }
    }
}
