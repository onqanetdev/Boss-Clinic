//
//  MyProfileScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 07/07/26.
//

import SwiftUI

struct MyProfileScreen: View {
    
    var body: some View {

        ZStack {
            Color.black.ignoresSafeArea()

            Text("My Profile")
                .foregroundColor(.white)
        }
        .navigationTitle("My Profile")
    }
}
#Preview {
    MyProfileScreen()
}
