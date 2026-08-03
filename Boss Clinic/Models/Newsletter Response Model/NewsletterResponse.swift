//
//  NewsletterResponse.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 03/08/26.
//

import Foundation



struct NewsletterResponse: Codable, Equatable {
    let success: Bool?
    let message: String?
    let data: NewsletterPagination?
}

// MARK: - Pagination

struct NewsletterPagination: Codable, Equatable {
    let currentPage: Int?
    let data: [Newsletter]?
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let links: [NewsletterLink]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
        case total
    }
}

// MARK: - Newsletter

struct Newsletter: Codable, Identifiable, Equatable {

    let id: String?
    let userId: String?
    let subject: String?
    let message: String?
    let image: String?
    let recipientType: String?
    let recipientIds: [String]?
    let status: String?
    let sentAt: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case subject
        case message
        case image
        case recipientType = "recipient_type"
        case recipientIds = "recipient_ids"
        case status
        case sentAt = "sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

// MARK: - Pagination Link

struct NewsletterLink: Codable, Equatable {

    let url: String?
    let label: String?
    let page: Int?
    let active: Bool?
}





