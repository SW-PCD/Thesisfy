//
//  ThesisView.swift
//  Thesisfy
//
//  Created by KKM on 12/5/24.
//

import Foundation

class ThesisViewModel: ObservableObject {
    @Published var articleDetail: ArticleDetail? // 논문 상세 데이터
    @Published var isLoading = false            // 로딩 상태
    @Published var errorMessage: String?        // 에러 메시지
    @Published var isBookmarked = false         // 북마크 상태

    // 논문 상세 데이터 로드
    func loadArticleDetail(articleId: String) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.fetchArticleDetail(articleId: articleId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let articleDetail):
                    self.articleDetail = articleDetail
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
