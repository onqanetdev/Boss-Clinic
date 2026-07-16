//
//  ScheduleRowView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI

struct ScheduleRowView: View {

    let schedule: TodaySchedule

    var body: some View {

        HStack(spacing: 10) {

            Text(schedule.time)
                .font(.custom("Inter18pt-SemiBold", size: 13))
                .foregroundColor(.white)
                .frame(alignment: .leading)

            Image("medicine")
                .resizable()
                .frame(width: 18, height: 23, alignment: .leading)
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.15), lineWidth: 2)
                )

            Text(schedule.medicineName)
                .font(.custom("Inter18pt-Regular", size: 11))
                .foregroundColor(.white)
            

            Spacer()

            Text(schedule.status)
                .font(.custom("Inter18pt-Regular", size: 11))
                //.foregroundColor(Color.gray)
                .foregroundColor(schedule.status.color)
        }
        .padding(.vertical, 18)
    }
}
