//
//  SearchModel.swift
//  Thesisfy
//
//  Created by KKM on 12/5/24.
//

import Foundation

// PaperSearchResponse: 논문 검색 결과를 나타내는 구조체
struct PaperSearchResponse: Codable {
    let documents: [PaperDocument]  // 논문 정보 배열
    
    struct PaperDocument: Codable, Identifiable {
        let id: String         // 논문 고유 ID
        let title: String      // 논문 제목
        let authors: [String]  // 저자 목록
        let source: String     // 출처 (예: 저널명 또는 출판사)
        let url: String        // 논문 URL (상세 페이지)
        
        // Codable 프로토콜을 사용하기 위한 맞춤형 초기화 (필요한 경우)
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case authors
            case source
            case url
        }
    }
}
