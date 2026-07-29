//
//  MyProfileSkeletonScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 28/07/26.
//

import SwiftUI

struct MyProfileSkeletonScreen: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                // Name
                SkeletonBlock(height: 18, width: 60)
                SkeletonBlock(height: 64)

                // Email
                SkeletonBlock(height: 18, width: 60)
                SkeletonBlock(height: 64)

                // Gender
                SkeletonBlock(height: 18, width: 70)
                SkeletonBlock(height: 64)

                // Address
                SkeletonBlock(height: 18, width: 80)
                SkeletonBlock(height: 64)

                // Phone
                SkeletonBlock(height: 18, width: 60)
                SkeletonBlock(height: 64)

                // Save button placeholder
                SkeletonBlock(height: 56, cornerRadius: 28)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 20)
            .padding(.vertical)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MyProfileSkeletonScreen()
    }
}
