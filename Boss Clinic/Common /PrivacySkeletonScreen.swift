//
//  PrivacySkeletonScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 31/07/26.
//

import SwiftUI

struct PrivacySkeletonScreen: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 24) {

                // Title
                SkeletonBlock(
                    height: 34,
                    cornerRadius: 8,
                    width: 220
                )

                // Last Updated
                VStack(alignment: .leading, spacing: 10) {

                    SkeletonBlock(
                        height: 18,
                        cornerRadius: 6,
                        width: 120
                    )

                    SkeletonBlock(
                        height: 18,
                        cornerRadius: 6,
                        width: 220
                    )
                }

                // Content
                VStack(alignment: .leading, spacing: 14) {

                    ForEach(0..<14, id: \.self) { index in

                        SkeletonBlock(
                            height: 16,
                            cornerRadius: 5,
                            width: lineWidth(for: index)
                        )
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(20)
        }
        .background(Color.black)
    }

    private func lineWidth(for index: Int) -> CGFloat {

        let widths: [CGFloat] = [
            340,
            310,
            330,
            285,
            345,
            300,
            325,
            340,
            280,
            335,
            310,
            345,
            290,
            220
        ]

        return widths[index % widths.count]
    }
}

#Preview {

    NavigationStack {

        ZStack {

            Color.black
                .ignoresSafeArea()

            PrivacySkeletonScreen()
        }
    }
}


