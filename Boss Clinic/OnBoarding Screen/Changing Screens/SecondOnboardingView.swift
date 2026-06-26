//
//  SecondOnboardingView.swift
//  Boss Clinic
//
//  Created by Onqanet on 25/06/26.
//

import SwiftUI

struct SecondOnboardingView: View {
    var body: some View {
        VStack {
            //1st HStack for Text Changing
            VStack(alignment: .leading, spacing: 8) {

                Text("Track your progress with ease")
                    .font(.custom("Inter24pt-Bold", size: 24))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text("Log your medications, set schedules and see how consistent you are")
                    .font(.custom("Inter18pt-Regular", size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(.white)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //2nd HStack for Image Arranging
            ZStack(alignment: .top) {

            
                    
                VStack(alignment: .center) {
                    Image("onboarding_progress")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 200, alignment: .center)
                }.padding(.top, 20)
                    .padding(.leading, 180)
                
                Image("onboardlady_one")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 300, alignment: .leading)
                    .clipped()
                    .padding(.trailing, 140)
                
            }
                        
        }.frame(maxWidth: .infinity, alignment: .top)
            .frame(height: 600)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


#Preview {
    SecondOnboardingView()
}
