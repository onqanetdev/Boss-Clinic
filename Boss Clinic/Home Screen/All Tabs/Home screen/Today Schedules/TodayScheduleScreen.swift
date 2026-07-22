//
//  TodayScheduleScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import Foundation
import SwiftUI

//
//struct TodayScheduleScreen: View {
//
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var schedules: [TodayScheduleItem] = [
//        .init(time: "09:32", medicine: "Teneligliptin 20mh", status: .missed),
//        .init(time: "09:33", medicine: "Metformin 500mg", status: .missed),
//        .init(time: "10:20", medicine: "tab1 10mg", status: .missed),
//        .init(time: "14:30", medicine: "Sitadapa M\n100/10/1000 Tablet 10...", status: .missed),
//        .init(time: "14:50", medicine: "waqtab 120", status: .missed),
//        .init(time: "15:30", medicine: "tab1 10mg", status: .missed),
//        .init(time: "17:20", medicine: "test 500mg", status: .upcoming),
//        .init(time: "17:25", medicine: "test 500mg", status: .upcoming),
//        .init(time: "20:25", medicine: "tab1 10mg", status: .upcoming),
//        .init(time: "21:21", medicine: "Sitadapa M", status: .upcoming)
//    ]
//
//    var body: some View {
//
//        ZStack {
//
//            Color.black
//                .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//
//                header
//
//                ScrollView(showsIndicators: false) {
//
//                    LazyVStack(spacing: 0) {
//
//                        ForEach(Array(schedules.enumerated()), id: \.element.id) { index, item in
//
//                            TodayScheduleRow(schedule: item)
//
//                            if index != schedules.count - 1 {
//
//                                Divider()
//                                    .background(Color.white.opacity(0.15))
//                                    .padding(.leading, 90)
//                            }
//                        }
//                    }
//                    .padding(.top, 24)
//                }
//            }
//        }
//        .navigationBarHidden(true)
//    }
//
//    private var header: some View {
//
//        HStack(spacing: 18) {
//
//            Button {
//
//                dismiss()
//
//            } label: {
//
//                Image(systemName: "chevron.left")
//                    .font(.system(size: 24, weight: .medium))
//                    .foregroundColor(.white)
//            }
//
//            Text("Today's Schedule")
//                .font(.custom("Inter24pt-Regular", size: 24))
//                .foregroundColor(.white)
//
//            Spacer()
//        }
//        .padding(.horizontal)
//        .padding(.top, 10)
//    }
//}
//
//#Preview {
//    NavigationStack {
//        TodayScheduleScreen()
//    }
//}
//
//
//
//

