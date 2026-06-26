//
//  FirstOnboardingView.swift
//  Boss Clinic
//
//  Created by Onqanet on 25/06/26.
//

import SwiftUI

struct FirstOnboardingView: View {
    var body: some View {
        VStack {
            //1st HStack for Text Changing
            VStack(alignment: .leading, spacing: 8) {

                Text("Stay on track with your medications")
                    .font(.custom("Inter24pt-Bold", size: 24))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text("Get reminders, track progress and never miss a dose")
                   // .font(.system(size: 13, weight: .medium))
                    .font(.custom("Inter18pt-Regular", size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(.white)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //2nd HStack for Image Arranging
            HStack(alignment: .top) {
                Image("onboardlady_one")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 300, alignment: .leading)
                    .clipped()
            
                    
                VStack(spacing: 40) {
                    Image("onboard_first")
                        .resizable()
                        .scaledToFill()
                        .frame(width:45, height: 45, alignment: .trailing)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                   
                    Image("onboard_first_pill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45, alignment: .trailing)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                               .overlay(
                                   RoundedRectangle(cornerRadius: 16)
                                       .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                               )
                       
                }.padding(.top, 20)
                
            }
                        
        }.frame(maxWidth: .infinity, alignment: .top)
            .frame(height: 600)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    FirstOnboardingView()
}
