//
//  NotificationSkeletonScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 30/07/26.
//

import SwiftUI


struct NotificationSkeletonScreen: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            LazyVStack(spacing: 18) {

                ForEach(0..<6, id: \.self) { _ in
                    NotificationSkeletonRow()
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
        .background(Color.black)
    }
}

struct NotificationSkeletonRow: View {

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            SkeletonBlock(
                height: 22,
                cornerRadius: 6,
                width: 190
            )

            SkeletonBlock(
                height: 18,
                cornerRadius: 6,
                width: 240
            )
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.08))
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NotificationSkeletonScreen()
            .padding()
    }
}
