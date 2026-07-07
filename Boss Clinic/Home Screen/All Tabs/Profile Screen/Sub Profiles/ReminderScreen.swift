//
//  ReminderScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 07/07/26.
//

import SwiftUI

struct ReminderScreen: View {

    var body: some View {

        ZStack {
            Color.black.ignoresSafeArea()

            Text("Reminder Settings")
                .foregroundColor(.white)
        }
        .navigationTitle("Reminder Settings")
    }
}

#Preview {
    ReminderScreen()
}
