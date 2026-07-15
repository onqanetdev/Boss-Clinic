//
//  PrivacyScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import SwiftUI
 
struct PrivacyScreen: View {
 
    @StateObject private var privacyVM = PrivacyViewModel()
 
    var body: some View {
 
        ZStack {
 
            Color.black
                .ignoresSafeArea()
 
            ScrollView {
 
                VStack(alignment: .leading, spacing: 20) {
 
                    if let privacy = privacyVM.privacyResponse {
 
                        Text(privacy.data.title)
                            .font(.custom("Inter24pt-Bold", size: 24))
                            .foregroundColor(.white)
 
                        Text("Last Updated: \(privacy.data.lastUpdated)")
                            .font(.custom("Inter18pt-Regular", size: 14))
                            .foregroundColor(.gray)
 
                        HTMLAnalyserView(html: privacy.data.content)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
            }
 
            if privacyVM.isLoading {
 
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
 
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
 
            privacyVM.fetchPrivacyPolicy()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { privacyVM.errorMessage != nil },
                set: { _ in privacyVM.errorMessage = nil }
            )
        ) {
 
            Button("OK", role: .cancel) { }
 
        } message: {
 
            Text(privacyVM.errorMessage ?? "")
        }
    }
}
 
#Preview {
 
    NavigationStack {
 
        PrivacyScreen()
    }
}
 


