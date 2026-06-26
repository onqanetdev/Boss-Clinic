//
//  ThirdOnboardingView.swift
//  Boss Clinic
//
//  Created by Onqanet on 25/06/26.
//

import SwiftUI

struct ThirdOnboardingView: View {
    var body: some View {
        VStack {
            //1st HStack for Text Changing
            VStack(alignment: .leading, spacing: 8) {

                Text("Never miss a dose again")
                    .font(.custom("Inter24pt-Bold", size: 24))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text("Smart reminders and notifications help you stay on track, every day.")
                    .font(.custom("Inter18pt-Regular", size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 20)
            }
            .foregroundColor(.white)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //2nd HStack for Image Arranging
            ZStack(alignment: .top) {

                VStack(alignment: .center, spacing: 50) {
                    Image("onboard_first")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                    
                    Image("onboard_time_to_take_med")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 130, alignment: .center)
                        .padding(.leading, 50)
                    
                }.padding(.top, 20)
                    .padding(.leading, 180)
                
                Image("onboardlady_one")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 300, alignment: .leading)
                    .clipped()
                    .padding(.trailing, 160)
                
            }
                        
        }.frame(maxWidth: .infinity, alignment: .top)
            .frame(height: 600)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ThirdOnboardingView()
}

