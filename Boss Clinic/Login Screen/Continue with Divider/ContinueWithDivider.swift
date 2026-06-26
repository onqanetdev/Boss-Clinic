//
//  ContinueWithDivider.swift
//  Boss Clinic
//
//  Created by Onqanet on 26/06/26.
//

import SwiftUI

struct ContinueWithDivider: View {
    
    var title: String = "or continue with"

    var body: some View {
        HStack(spacing: 16) {

            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 1)

            Text(title)
                .font(.custom("Inter18pt-Regular", size: 14))
                .foregroundColor(.white)
                .fixedSize()

            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 1)
        }
    }
}

#Preview {
    ContinueWithDivider()
}
