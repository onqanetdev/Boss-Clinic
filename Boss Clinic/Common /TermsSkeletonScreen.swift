//
//  TermsSkeletonScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 31/07/26.
//

import SwiftUI

struct TermsSkeletonScreen: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 24) {

                // Title
                SkeletonBlock(
                    height: 34,
                    cornerRadius: 8,
                    width: 270
                )

                // Last Updated
                VStack(alignment: .leading, spacing: 10) {

                    SkeletonBlock(
                        height: 18,
                        cornerRadius: 6,
                        width: 130
                    )

                    SkeletonBlock(
                        height: 18,
                        cornerRadius: 6,
                        width: 230
                    )
                }

                // Body Content
                VStack(alignment: .leading, spacing: 14) {

                    ForEach(0..<18, id: \.self) { index in

                        SkeletonBlock(
                            height: 16,
                            cornerRadius: 5,
                            width: width(for: index)
                        )
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(20)
        }
        .background(Color.black)
    }

    private func width(for index: Int) -> CGFloat {

        let widths: [CGFloat] = [
            340,
            315,
            332,
            290,
            348,
            305,
            330,
            345,
            285,
            320,
            338,
            295,
            348,
            312,
            326,
            340,
            300,
            230
        ]

        return widths[index]
    }
}

#Preview {
    NavigationStack {
        ZStack {
            Color.black.ignoresSafeArea()
            TermsSkeletonScreen()
        }
    }
}
