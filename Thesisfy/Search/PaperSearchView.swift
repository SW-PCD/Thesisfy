//
//  PaperSearchView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/8/24.
//

import SwiftUI

struct PaperSearchView: View {
    @State private var isExpanded = false  // 리스트 확장 여부를 저장하는 상태 변수
    @State private var path: [Route] = []  // NavigationStack 경로
    @ObservedObject var networkManager = NetworkManager.shared // NetworkManager 연결
    @State private var inputSearch: String = "" // 사용자 입력 검색어 상태
    @State private var searchTimeout = false // 검색 시간 초과 여부
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // 배경 이미지
                Image("Cone")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .opacity(0.1) // 반투명 효과
                    .ignoresSafeArea() // 화면 전체를 덮도록 설정
                
                // 메인 콘텐츠
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        SearchFieldView(path: $path, inputSearch: $inputSearch) //inputSearch 전달
                            .padding(.top, 12)
                            .padding(.bottom, 20)
                            .onChange(of: inputSearch) { newValue in
                                if !newValue.isEmpty {
                                    searchTimeout = false
                                    isExpanded = false // 새로운 검색 시 리스트 확장 상태 초기화
                                    startSearchTimeout() // 타이머 시작
                                }
                            }
                        
                        // 검색 결과 목록
                        if let searchResponse = networkManager.searchResponse { // 검색 결과 연결
                            PaperListView(
                                path: $path,
                                isExpanded: $isExpanded,
                                searchResponse: searchResponse,
                                query: inputSearch // 검색어 전달
                            )
                        } else if searchTimeout {
                            Text("검색 결과가 없습니다.")
                                .foregroundColor(Color.red.opacity(0.8))
                                .padding(.top, 20)
                        } else if !inputSearch.isEmpty { // 검색 중인 경우
                            Text("검색 중입니다...")
                                .foregroundColor(Constants.GrayColorGray600)
                                .padding(.top, 20)
                        }
                        
                        Spacer(minLength: 12)
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .background(Color.white.ignoresSafeArea()) // 배경색 설정
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .searchView:
                    SearchView()
                case .thesisView:
                    ThesisView()
                default:
                    EmptyView()
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func startSearchTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if networkManager.searchResponse == nil && !inputSearch.isEmpty {
                searchTimeout = true
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
    @Binding var isExpanded: Bool
    let searchResponse: SearchResponse // 검색 결과 전달받음
    let query: String // 검색어 전달받음
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 제목과 검색 결과 개수
            HStack {
                Text("\(query) 검색결과 \(searchResponse.records.count)건") // 검색어와 결과 개수 표시
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                    .foregroundColor(Constants.GrayColorGray800)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    // 확장 여부에 따라 표시할 레코드 수 조정
                    let recordsToShow = isExpanded ? searchResponse.records : Array(searchResponse.records.prefix(5))
                    ForEach(recordsToShow, id: \.url) { record in
                        PaperRowView(path: $path, record: record) //@@@ 레코드 뷰 생성
                    }
                    
                    if !isExpanded {
                        ShowMoreButton(isExpanded: $isExpanded)
                            .padding(.top, 16)
                    }
                }
            }
            .frame(maxHeight: isExpanded ? .infinity : CGFloat(5 * 120)) // 높이 조정
            .animation(.easeInOut, value: isExpanded)
        }
    }
}

// MARK: - PaperRowView
struct PaperRowView: View {
    @Binding var path: [Route]  // NavigationStack 경로
    let record: SearchResponse.Record // 논문 데이터 전달받음
    
    // 이미지 배열
    private let universityLogos = ["YSU", "SNU", "KU", "KAIST", "POSTECH", "HSU", "SKKU", "HYU"]
    
    // 랜덤 이미지 선택
    private var randomLogo: String {
        universityLogos.randomElement() ?? "defaultLogo"
    }
    
    var body: some View {
        Button(action: {
            path.append(.thesisView) // 버튼 클릭 시 `thesisView`로 이동
        }) {
            HStack(alignment: .top, spacing: 12) { // HStack 정렬과 간격 설정
                Image(randomLogo) // 랜덤 이미지 적용
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 43)
                    .background(Circle().fill(Constants.GrayColorWhite))
                    .padding(.leading, 16)
                
                VStack(alignment: .leading, spacing: 7) { // 텍스트 정렬
                    HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                        Text(record.category) // 논문 카테고리
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.PrimaryColorPrimary600)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Constants.PrimaryColorPrimary50)
                    .cornerRadius(6)
                    
                    Text(record.localizedTitle) // 적절한 언어의 논문 제목 표시
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                        .lineLimit(1) // 한 줄로 제한
                        .truncationMode(.tail) // 초과 텍스트를 "..."으로 표시
                        .frame(maxWidth: .infinity, alignment: .leading) // 명시적으로 왼쪽 정렬
                }
                .frame(maxWidth: .infinity, alignment: .leading) // 전체를 왼쪽 정렬
            }
            .frame(maxWidth: .infinity, alignment: .leading) // HStack 정렬
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
