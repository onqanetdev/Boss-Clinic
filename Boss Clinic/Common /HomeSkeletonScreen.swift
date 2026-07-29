//
//  HomeSkeletonScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 29/07/26.
//

import SwiftUI

struct HomeSkeletonScreen: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 24) {

                // MARK: Header

                HStack {

                    SkeletonBlock(height: 32, width: 220)

                    Spacer()

                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 28, height: 28)
                        .shimmering()
                }

                // MARK: Next Medication Card

                VStack(alignment: .leading, spacing: 18) {

                    SkeletonBlock(height: 18, width: 150)

                    SkeletonBlock(height: 30, width: 180)

                    Spacer()

                    HStack {

                        SkeletonBlock(height: 22, width: 100)

                        Spacer()

                        SkeletonBlock(
                            height: 54,
                            cornerRadius: 27,
                            width: 170
                        )
                    }
                }
                .padding(20)
                .frame(height: 210)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                )

                // MARK: Today's Schedule

                VStack(alignment: .leading, spacing: 22) {

                    SkeletonBlock(height: 30, width: 200)

                    ForEach(0..<3, id: \.self) { _ in

                        HStack {

                            SkeletonBlock(height: 20, width: 60)

                            SkeletonBlock(
                                height: 42,
                                cornerRadius: 10,
                                width: 42
                            )

                            SkeletonBlock(height: 22, width: 110)

                            Spacer()

                            SkeletonBlock(height: 18, width: 80)
                        }
                    }
                }

                // MARK: Refill Reminder

                VStack(spacing: 18) {

                    ForEach(0..<2, id: \.self) { _ in

                        HStack(spacing: 15) {

                            SkeletonBlock(
                                height: 72,
                                cornerRadius: 12,
                                width: 72
                            )

                            VStack(alignment: .leading, spacing: 12) {

                                SkeletonBlock(height: 18, width: 120)

                                SkeletonBlock(height: 28, width: 100)

                                SkeletonBlock(height: 18, width: 80)
                            }

                            Spacer()

                            SkeletonBlock(
                                height: 50,
                                cornerRadius: 25,
                                width: 140
                            )
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                        )
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    HomeSkeletonScreen()
}


