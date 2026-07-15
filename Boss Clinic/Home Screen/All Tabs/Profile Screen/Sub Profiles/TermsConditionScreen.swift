//
//  TermsConditionScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import SwiftUI


struct TermsConditionScreen: View {
 
    @StateObject private var termsVM = TermsConditionViewModel()
 
    var body: some View {
 
        ZStack {
 
            Color.black
                .ignoresSafeArea()
 
            ScrollView(showsIndicators: false) {
 
                VStack(alignment: .leading, spacing: 20) {
 
                    if let terms = termsVM.termsConditionResponse {
 
                        Text(terms.data.title)
                            .font(.custom("Inter24pt-Bold", size: 24))
                            .foregroundColor(.white)
 
                        Text("Last Updated: \(terms.data.lastUpdated)")
                            .font(.custom("Inter18pt-Regular", size: 14))
                            .foregroundColor(.gray)
 
                        HTMLAnalyserView(html: terms.data.content)
                    }
                }
                .padding(20)
            }
 
            // MARK: Loader
 
            if termsVM.isLoading {
 
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
 
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .navigationTitle("Terms & Conditions")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            termsVM.fetchTermsCondition()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { termsVM.errorMessage != nil },
                set: { _ in termsVM.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(termsVM.errorMessage ?? "")
        }
    }
}
 
#Preview {
    NavigationStack {
        TermsConditionScreen()
    }
}

