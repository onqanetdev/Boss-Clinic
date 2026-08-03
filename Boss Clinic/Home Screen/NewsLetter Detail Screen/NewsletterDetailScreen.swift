//
//  NewsletterDetailScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 03/08/26.
//


import SwiftUI


struct NewsletterDetailScreen: View {

    let newsletter: Newsletter

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {

                AsyncImage(url: URL(string: newsletter.image ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    default:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 8) {
                    Text(newsletter.subject ?? "Newsletter")
                        .font(.custom("Inter18pt-SemiBold", size: 20))
                        .foregroundColor(.white)

                    Text(formattedDate)
                        .font(.custom("Inter18pt-Regular", size: 13))
                        .foregroundColor(.gray)

                    Text(newsletter.message ?? "")
                        .font(.custom("Inter18pt-Regular", size: 15))
                        .foregroundColor(.white.opacity(0.85))
                        .lineSpacing(4)
                }
                .padding(.horizontal, 4)
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Newsletter")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Formats sentAt/createdAt ("2026-07-28T...") into "Jul 28, 2026"
    private var formattedDate: String {
        let rawDate = newsletter.sentAt ?? newsletter.createdAt
        guard let rawDate else { return "" }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let date = isoFormatter.date(from: rawDate)
            ?? ISO8601DateFormatter().date(from: rawDate)

        guard let date else { return rawDate }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy"
        return displayFormatter.string(from: date)
    }
}

#Preview {
    NewsletterDetailScreen(
        newsletter: Newsletter(
            id: "1",
            userId: "1",
            subject: "Boss Clinic",
            message: "Simply dummy text of the printing and typesetting industry.",
            image: nil,
            recipientType: nil,
            recipientIds: nil,
            status: nil,
            sentAt: "2026-07-28T10:00:00.000Z",
            createdAt: nil,
            updatedAt: nil,
            deletedAt: nil
        )
    )
}

