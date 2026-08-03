//
//  NewsLetterCardView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 03/08/26.
//

import SwiftUI



struct NewsLetterCardView: View {
    let newsletter: Newsletter
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: newsletter.image ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty:
                        ProgressView()
                    default:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(newsletter.subject ?? "Newsletter")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    Text(newsletter.message ?? "")
                        .font(.custom("Inter18pt-Regular", size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
