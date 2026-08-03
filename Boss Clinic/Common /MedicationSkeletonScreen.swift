//
//  MedicationSkeletonScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 29/07/26.
//

import SwiftUI

struct MedicationSkeletonScreen: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 0) {

                // MARK: Title

                SkeletonBlock(height: 38, width: 240)
                    .padding(.top, 30)
                    .padding(.bottom, 30)

                Divider()
                    .background(Color.white.opacity(0.12))
                    .padding(.bottom, 10)

                // MARK: Medication Rows

                VStack(spacing: 0) {

                    ForEach(0..<5, id: \.self) { _ in

                        MedicationSkeletonRow()

                        Divider()
                            .background(Color.white.opacity(0.12))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color.black.ignoresSafeArea())
    }
}



struct MedicationSkeletonRow: View {

    var body: some View {

        HStack(spacing: 16) {

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 46, height: 46)
                .shimmering()

            VStack(alignment: .leading, spacing: 12) {

                SkeletonBlock(height: 22, width: 130)

                SkeletonBlock(height: 18, width: 170)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white.opacity(0.15))
        }
        .padding(.vertical, 18)
    }
}





#Preview {
    MedicationSkeletonScreen()
}
