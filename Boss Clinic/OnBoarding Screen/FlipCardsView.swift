//
//  FlipCardsView.swift
//  Boss Clinic
//
//  Created by Onqanet on 24/06/26.
//

import SwiftUI


struct FlipCardsView: View {
    @State private var angle: Double = 0
    let pages: [AnyView] = [
        AnyView(FirstOnboardingView()),
        AnyView(SecondOnboardingView()),
        AnyView(ThirdOnboardingView()),
    ]
    @State private var currentPage: Int = 0
 
    @State private var navigateToLogin = false
 
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
 
    var body: some View {
        VStack {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        pages[index]
                            .frame(maxWidth: .infinity)
                            .frame(height: 600)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                            .rotation3DEffect(
                                Angle(degrees: angle),
                                axis: (x: 0, y: 1.0, z: 1)
                            )
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
 
                PrimaryButton(title: "Get Started") {
                    goToLogin()
                }
                .padding(.horizontal, 30)
 
                HStack {
                    Text("Already have an account?")
                        .font(.custom("Inter18pt-Regular", size: 14))
                        .foregroundColor(.white)
 
                    Button("Log in") {
                        goToLogin()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                }.padding(.top, 20)
 
            }.frame(maxHeight: 600)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginScreen()
            }
    }
 
    private func goToLogin() {
        // Any future app launch (or logout) skips onboarding and goes
        // straight to LoginScreen via RootView.
        hasSeenOnboarding = true
        navigateToLogin = true
    }
}
 


#Preview {
    NavigationStack {
        FlipCardsView()
    }
}

