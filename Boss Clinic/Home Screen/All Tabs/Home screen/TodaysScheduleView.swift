//
//  TodaysScheduleView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI

struct TodaysScheduleView: View {

    let schedules: [Schedule]

    var body: some View {

        VStack(spacing: 0) {

            HStack {

                Text("Today's Schedule")
                    .font(.custom("Inter18pt-Bold", size: 17))
                    .foregroundColor(.white)

                Spacer()

                if schedules.count > 3 {

                    Button("View all") {

                        print("Navigate")

                    }
                    .font(.custom("Inter18pt-Regular", size: 16))
                    .foregroundColor(.white)
                }
            }

            .padding(.bottom, 20)

            ForEach(Array(schedules.prefix(3).enumerated()), id: \.element.id) { index, schedule in

                ScheduleRowView(schedule: schedule)

                if index != min(2, schedules.count - 1) {

                    Divider()
                        .background(Color.white.opacity(0.15))
                }
            }
        }
        .padding(10)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

