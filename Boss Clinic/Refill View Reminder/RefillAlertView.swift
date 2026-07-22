//
//  RefillAlertView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 09/07/26.
//

import SwiftUI


struct RefillAlertView: View {

   let medicationName: String
   let daysLeft: Int

   var onRefillNow: () -> Void = {}
   var onScheduleConsultation: () -> Void = {}
   var onNotNow: () -> Void = {}

   @Environment(\.dismiss) private var dismiss

   var body: some View {
       ZStack {
           Color.black.ignoresSafeArea()

           VStack(spacing: 0) {

               // MARK: Close button
               HStack {
                   Spacer()
                   Button {
                       //onNotNow()
                       dismiss()
                   } label: {
                       Image(systemName: "xmark")
                           .font(.system(size: 20, weight: .semibold))
                           .foregroundColor(.white)
                   }
               }
               .padding(.top, 8)
               .padding(.bottom, 24)

               // MARK: Bottle icon
               ZStack {
                   Circle()
                       .fill(Color.white.opacity(0.08))
                       .frame(width: 120, height: 120)

                   Image(systemName: "cylinder.fill")
                       .resizable()
                       .scaledToFill()
                       .frame(width: 44, height: 44)
                       .foregroundColor(.white)
               }
               .padding(.bottom, 32)

               // MARK: Title
               Text("Your medication is\nrunning low")
                   .font(.custom("Inter24pt-Bold", size: 26))
                   .foregroundColor(.white)
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 16)

               // MARK: Subtitle
               Text("\(medicationName) will run out in\n\(daysLeft) day\(daysLeft == 1 ? "" : "s").")
                   .font(.custom("Inter18pt-Regular", size: 17))
                   .foregroundColor(Color.white.opacity(0.6))
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 40)

               // MARK: Refill Now
               Button {
                   onRefillNow()
                   dismiss()
               } label: {
                   Text("Refill Now")
                       .font(.custom("Inter18pt-SemiBold", size: 17))
                       .foregroundColor(.black)
                       .frame(maxWidth: .infinity)
                       .padding(.vertical, 16)
                       .background(
                           RoundedRectangle(cornerRadius: 14)
                               .fill(Color.white)
                       )
               }
               .padding(.bottom, 14)

               // MARK: Not Now
               Button {
                   onNotNow()
                   dismiss()
               } label: {
                   Text("Not Now")
                       .font(.custom("Inter18pt-SemiBold", size: 17))
                       .foregroundColor(.white)
                       .frame(maxWidth: .infinity)
                       .padding(.vertical, 16)
                       .background(
                           RoundedRectangle(cornerRadius: 14)
                               .stroke(Color.white.opacity(0.3), lineWidth: 1)
                       )
               }
           }
           .padding(.horizontal, 28)
           .padding(.top, 24)
           .padding(.bottom, 32)
           .background(
               RoundedRectangle(cornerRadius: 24)
                   .stroke(Color.white.opacity(0.2), lineWidth: 1)
           )
           .padding(.horizontal, 20)
       }
   }
}

#Preview {
   RefillAlertView(medicationName: "Lisinopril 10 mg", daysLeft: 2)
}
