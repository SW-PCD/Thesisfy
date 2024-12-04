//
//  PaperSearchView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/8/24.
//

import SwiftUI

struct PaperSearchView: View {
    @State private var path: [Route] = []  // NavigationStack 경로
    @ObservedObject var networkManager = NetworkManager.shared // NetworkManager 연결
    @State private var inputSearch: String = "" // 사용자 입력 검색어 상태

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("Cone")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .opacity(0.1)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) { // 각 항목 간 간격을 16으로 설정
                        SearchFieldView(path: $path, inputSearch: $inputSearch)
                            .padding(.top, 12)

                        if let searchResponse = networkManager.searchResponse {
                            PaperListView(
                                path: $path,
                                searchResponse: searchResponse,
                                query: inputSearch
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .background(Color.white.ignoresSafeArea()) // 배경색 설정
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .thesisView(let articleId):
                    ThesisView(articleId: articleId ?? "") // 논문 ID를 ThesisView로 전달
                default:
                    EmptyView()
                }
            }
        }
    }
}


// MARK: - SearchFieldView
struct SearchFieldView: View {
    @Binding var path: [Route]
    @Binding var inputSearch: String // 검색어 전달받음
    
    var body: some View {
        HStack {
            TextField("검색어 입력", text: $inputSearch)
                .font(.custom("Pretendard", size: Constants.fontSizeS))
                .fontWeight(Constants.fontWeightMedium)
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.leading, 12)
                .onSubmit { // 키보드에서 Return을 눌렀을 때
                    performSearch()
                }
            
            Spacer()
            
            Button(action: { // 검색 버튼 클릭 시 API 호출
                performSearch()
            }) {
                Image("search")
                    .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                    .padding(.trailing, 12)
            }
        }
        .padding(.horizontal, Constants.fontSizeXs)
        .padding(.vertical, Constants.fontSizeS)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Constants.GrayColorGray50)
        .cornerRadius(6)
    }
    
    // 검색 로직 공통 함수
    private func performSearch() {
        if !inputSearch.isEmpty {
            NetworkManager.shared.searchResponse = nil // 기존 검색 결과 초기화
            NetworkManager.shared.paperSearchBtnTapped(query: inputSearch)
            UIApplication.shared.endEditing() // 키보드 닫기
        }
    }
}

// MARK: - Helper Extension
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - PaperListView
struct PaperListView: View {
    @Binding var path: [Route]
    var searchResponse: SearchResponse
    var query: String
    
    // 이미지 배열
    private let universityLogos = ["YSU", "SNU", "KU", "KAIST", "POSTECH", "HSU", "SKKU", "HYU"]
    
    // 랜덤 이미지 선택
    private var randomLogo: String {
        universityLogos.randomElement() ?? "defaultLogo"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 검색 결과 건수 표시
            Text("\(query) 검색결과 \(searchResponse.total)건")
                .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                .foregroundColor(Constants.GrayColorGray800)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            
            ScrollView { // 스크롤 가능하도록 ScrollView 추가
                VStack(spacing: 10) { // 각 항목 간 간격을 넓힘
                    ForEach(searchResponse.records, id: \.url) { record in
                        PaperRowView(path: $path, record: record)
                    }
                }
            }
        }
    }
    
    func extractArticleId(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url) else { return nil }
        return urlComponents.queryItems?.first { $0.name == "sereArticleSearchBean.artiId" }?.value
    }
}

// MARK: - PaperRowView
struct PaperRowView: View {
    @Binding var path: [Route]
    let record: SearchResponse.Record
    
    // 이미지 배열
    private let universityLogos = ["YSU", "SNU", "KU", "KAIST", "POSTECH", "HSU", "SKKU", "HYU"]
    
    // 랜덤 이미지 선택
    private var randomLogo: String {
        universityLogos.randomElement() ?? "defaultLogo"
    }

    var body: some View {
        Button(action: {
            if let articleId = extractArticleId(from: record.url) {
                path.append(.thesisView(articleId: articleId)) // 버튼 클릭 시 `thesisView`로 이동
            }
        }) {
            HStack(alignment: .top, spacing: 12) {
                Image(randomLogo) // 랜덤 이미지 적용
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 43)
                    .background(Circle().fill(Constants.GrayColorWhite))
                    .padding(.leading, 16)
                
                VStack(alignment: .leading, spacing: 7) { // 텍스트 정렬
                    // 카테고리 표시
                    Text(record.category)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.PrimaryColorPrimary600)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Constants.PrimaryColorPrimary50)
                        .cornerRadius(6)
                    
                    // 논문 제목 표시
                    Text(record.localizedTitle)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                        .lineLimit(1) // 한 줄로 제한
                        .truncationMode(.tail) // 초과 텍스트를 "..."으로 표시
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 100)
            .background(Constants.GrayColorGray50)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .inset(by: 0.5)
                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
            )
        }
    }
    
    func extractArticleId(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url) else { return nil }
        return urlComponents.queryItems?.first { $0.name == "sereArticleSearchBean.artiId" }?.value
    }
}

// MARK: - ShowMoreButton
struct ShowMoreButton: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button(action: {
            isExpanded.toggle()
        }) {
            HStack {
                Text("논문 정보 더보기")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeXs).weight(Constants.fontWeightMedium))
                    .foregroundColor(Constants.GrayColorGray600)
                
                Image("downArrow")
                    .resizable()
                    .frame(width: 12, height: 12)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Constants.GrayColorWhite)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Constants.BorderColorBorder1, lineWidth: 1))
        }
    }
}

#Preview {
    PaperSearchView()
}
