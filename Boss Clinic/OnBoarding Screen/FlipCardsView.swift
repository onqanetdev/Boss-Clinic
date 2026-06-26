//
//  FlipCardsView.swift
//  Boss Clinic
//
//  Created by Onqanet on 24/06/26.
//

import SwiftUI

struct FlipCardsView: View {
    @State private var angle: Double = 0
    //let images: [String] = ["sceneryOne","sceneryTwo", "sceneryThree", "sceneryFour"]
    let pages: [AnyView] = [
        AnyView(FirstOnboardingView()),
        AnyView(SecondOnboardingView()),
        AnyView(ThirdOnboardingView()),
        ]
    @State private var currentPage: Int = 0
    
    @State private var navigateToLogin = false
    
    var body: some View {
        //At Most VStack
        NavigationStack {
            VStack {
                //2nd Most VStack
                VStack {
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count,id: \.self) { index in
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
                        navigateToLogin = true
                        print("Button Tapped")
                    }
                                .padding(.horizontal, 30)
                    
                    HStack {
                        Text("Already have an account?")
                            //.font(.system(size: 16, weight: .regular))
                            .font(.custom("Inter18pt-Regular", size: 14))
                            .foregroundColor(.white)
                        
                        Button("Log in") {
                            print("Tapped")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    }.padding(.top, 20)
                    
                }.frame(maxHeight: 600)
            }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color.black)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginScreen()
                        }
        }
    }
}




#Preview {
    FlipCardsView()
}

