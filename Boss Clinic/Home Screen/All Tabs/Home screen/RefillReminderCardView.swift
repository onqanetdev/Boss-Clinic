//
//  RefillReminderCardView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI




struct RefillReminderCardView: View {

    let medication: RefillReminder
    
   // TODO: Replace these with real data passed in from wherever this card is used
   let medicationName: String = "Lisinopril 10 mg"
   let daysLeft: Int = 3

   @State private var showRefillAlert = false
    
   let onTappedRefill: () -> Void?
    
   var body: some View {

       HStack(spacing: 15) {

           // Medicine Icon
           Image("med_okay")
               .resizable()
               .scaledToFill()
               .frame(width: 20, height: 20)
               .padding(10)
               .overlay(
                   RoundedRectangle(cornerRadius: 4)
                       .stroke(Color.white.opacity(0.15), lineWidth: 2)
               )



           // Reminder Details
           VStack(alignment: .leading, spacing: 10) {

               Text("Refill Reminder")
                   .font(.custom("Inter18pt-Regular", size: 13))
                   .foregroundColor(.gray)

               Text(medication.medicineName)
                   .font(.custom("Inter18pt-SemiBold", size: 15))
                   .foregroundColor(.white)

               Text("\(medication.daysLeft) days left")
                   .font(.custom("Inter18pt-Regular", size: 13))
                   .foregroundColor(.gray)
           }

           Spacer()

           // Button
           Button {
               showRefillAlert = true
           } label: {

               Text("Refill Now")
                   .font(.custom("Inter18pt-SemiBold", size: 10))
                   .foregroundColor(.white)
                   .frame(width: 80, height: 40)
                   .overlay(
                       RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.white.opacity(0.25), lineWidth: 1)
                   )
           }
       }
       .padding(10)
       .background(
           Color(red: 7/255, green: 7/255, blue: 6/255)
       )
       .overlay(
           RoundedRectangle(cornerRadius: 15)
               .stroke(Color.white.opacity(0.12), lineWidth: 2)
       )
       //.clipShape(RoundedRectangle(cornerRadius: 24))
       .fullScreenCover(isPresented: $showRefillAlert) {
           RefillAlertView(
               medicationName: medicationName,
               daysLeft: daysLeft,
               onRefillNow: {
                   // TODO: navigate to your actual refill flow / pharmacy integration
                   onTappedRefill()
               },
               onScheduleConsultation: {
                   // TODO: navigate to your consultation booking flow
               },
               onNotNow: {
                   // Nothing needed — dismiss() already handles closing
               }
           )
       }
   }
}

//#Preview {
//   ZStack {
//       Color.black
//           .ignoresSafeArea()
//
//       RefillReminderCardView()
//           .padding()
//   }
//}


