//
//  DeleteAccountScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import SwiftUI

struct DeleteAccountScreen: View {

    var body: some View {

        WebView(
            url: URL(string: "https://onqanet.net/dev_waqueel01/bossclinic/public/delete-account")!
        )
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    NavigationStack {
        DeleteAccountScreen()
    }
}

