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
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    SearchFieldView(path: $path, inputSearch: $inputSearch) //inputSearch 전달
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                    
                    // 검색 결과 목록
                    if let searchResponse = networkManager.searchResponse { // 검색 결과 연결
                        PaperListView(
                            path: $path,
                            isExpanded: $isExpanded,
                            searchResponse: searchResponse,
                            query: inputSearch // 검색어 전달
                        )
                    } else {
                        Text("검색 결과가 없습니다.")
                            .foregroundColor(Constants.GrayColorGray600)
                            .padding(.top, 20)
                    }
                    
                    Spacer(minLength: 12)
                }
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white.ignoresSafeArea())
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
            
            Spacer()
            
            Spacer()
            
            Button(action: { // 검색 버튼 클릭 시 API 호출
                let searchRequest = Search(query: inputSearch)
                NetworkManager.shared.paperSearchBtnTapped(with: searchRequest)
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
                Text("\(query) 검색결과") //@@@@@ 검색어 표시
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                    .foregroundColor(Constants.GrayColorGray800)
                
                //@@@ JSON에서 total 값 대신 records.count 사용
                Text("\(searchResponse.records.count)건")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightSemibold))
                    .foregroundColor(Constants.PrimaryColorPrimary600)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    // 확장 여부에 따라 표시할 레코드 수 조정
                    let recordsToShow = isExpanded ? searchResponse.records : Array(searchResponse.records.prefix(5))
                    ForEach(recordsToShow, id: \.title) { record in
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
    
    var body: some View {
        Button(action: {
            path.append(.thesisView) // 버튼 클릭 시 `thesisView`로 이동
        }) {
            HStack {
                Image("SNU")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Constants.GrayColorWhite))
                    .overlay(
                        Circle()
                            .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                    )
                    .clipShape(Circle())
                    .padding(.leading, 16)
                
                Spacer()
                    .frame(width: 12)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                        Text(record.category)//@@@@@ 논문 카테고리
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
                    
                    Spacer()
                        .frame(height: 7)
                    
                    Text(record.title) //@@@@@ 논문 제목
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    HStack {
                        Text("서울대학교 인공지능학부")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.GrayColorGray800)
                        
                        Text(record.authors.joined(separator: ", ")) //논문저자
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(Constants.GrayColorGray600)
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
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
