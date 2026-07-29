//
//  CustomDropdown.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 28/07/26.
//

import Foundation
import SwiftUI


struct CustomDropdown: View {
    @Binding var selection: String
    let placeholder: String
    let options: [String]

    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? placeholder : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .white)
                        .font(.custom("Inter18pt-Regular", size: 16))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 20)
                .frame(height: 64)
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
            }

            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selection = option
                            withAnimation {
                                isExpanded = false
                            }
                        } label: {
                            HStack {
                                Text(option)
                                    .foregroundColor(.white)
                                    .font(.custom("Inter18pt-Regular", size: 16))
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 50)
                        }

                        if option != options.last {
                            Divider().background(Color.gray.opacity(0.3))
                        }
                    }
                }
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.top, 4)
            }
        }
    }
}
