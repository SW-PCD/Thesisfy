// Route.swift
import Foundation

enum Route: Hashable {
    case myPage
    case beingWrittenView
    case aiRecommendView
    case completeThesisView
    case thesisView(articleId: String?) // 논문 ID를 연관 값으로 추가
    case profileManagementView
    case notificationView

    case searchView
    case paperSearchView
}
