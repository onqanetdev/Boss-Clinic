//
//  ReminderSkeletonScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 29/07/26.
//

import SwiftUI

struct ReminderSkeletonScreen: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 24) {

                // MARK: Title

                SkeletonBlock(height: 42, width: 220)
                    .padding(.top, 25)

                // MARK: Segmented Control

                HStack(spacing: 0) {

                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 52)
                        .overlay(
                            SkeletonBlock(height: 20, cornerRadius: 6, width: 120)
                        )

                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.clear)
                        .frame(height: 52)
                        .overlay(
                            SkeletonBlock(height: 20, cornerRadius: 6, width: 90)
                        )
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )

                // MARK: First Date Section

                ReminderDateSectionSkeleton(rows: 2)

                // MARK: Second Date Section

                ReminderDateSectionSkeleton(rows: 6)

                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.black.ignoresSafeArea())
    }
}


struct ReminderDateSectionSkeleton: View {

    let rows: Int

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            SkeletonBlock(height: 28, width: 250)
                .padding(.bottom, 18)

            ForEach(0..<rows, id: \.self) { _ in

                ReminderRowSkeleton()

                Divider()
                    .background(Color.white.opacity(0.08))
            }
        }
    }
}


struct ReminderRowSkeleton: View {

    var body: some View {

        HStack(alignment: .center) {

            // Time
            SkeletonBlock(height: 20, width: 55)

            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 1, height: 62)
                .padding(.horizontal, 18)

            VStack(alignment: .leading, spacing: 10) {

                SkeletonBlock(height: 22, width: 130)

                SkeletonBlock(height: 18, width: 40)
            }

            Spacer()

            SkeletonBlock(
                height: 40,
                cornerRadius: 20,
                width: 110
            )
        }
        .padding(.vertical, 16)
    }
}



#Preview {
    ReminderSkeletonScreen()
}
