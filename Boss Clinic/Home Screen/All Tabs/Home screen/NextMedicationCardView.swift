//
//  NextMedicationCardView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 01/07/26.
//

import SwiftUI

struct NextMedicationCardView: View {
    
    var receiveNextMedication: NextMedication?
    let onMarkAsTaken: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Next Medication")
                .font(.custom("Inter18pt-Regular", size: 13))
                .foregroundColor(Color.white.opacity(0.75))

            Text("Today," + String(receiveNextMedication?.time ?? ""))
                .font(.custom("Inter24pt-Bold", size: 16))
                .foregroundColor(.white)

            HStack(alignment: .center) {

                Text(receiveNextMedication?.name ?? "")
                    .font(.custom("Inter18pt-Regular", size: 13))
                    .foregroundColor(.white)

                Spacer()

                Button {

                    //print("Medication Taken")
                    onMarkAsTaken()
                } label: {

                    Text("Mark as Taken")
                        .font(.custom("Inter18pt-SemiBold", size: 13))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(red: 7/255, green: 7/255, blue: 6/255)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.15), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}




