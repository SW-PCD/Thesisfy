//
//  PaperDetailResponse.swift
//  Thesisfy
//
//  Created by KKM on 12/5/24.
//

// PaperDetailResponse.swift

import Foundation

struct PaperDetailResponse: Codable {
    let articleId: String
    let title: String
    let abstract: String
    let authors: [String]
    let institution: String
    let journalName: String
    let publisherName: String
    let pubYear: String
    let articleCategories: [String]
}
