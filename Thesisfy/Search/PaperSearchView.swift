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
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                SearchFieldView(path: $path)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                
                PaperListView(path: $path, isExpanded: $isExpanded)
                
                Spacer(minLength: 12)
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
    
    var body: some View {
        Button(action: {
            path.append(.searchView)
        }) {
            HStack {
                Text("궁금한 주제를 검색해보세요")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                    .foregroundColor(Constants.GrayColorGray400)
                    .padding(.leading, 12)
                
                Spacer()
                
                Image("search")
                    .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                    .padding(.trailing, 12)
            }
            .padding(.horizontal, Constants.fontSizeXs)
            .padding(.vertical, Constants.fontSizeS)
            .background(Constants.GrayColorGray50)
            .cornerRadius(6)
        }
    }
}

// MARK: - PaperListView
struct PaperListView: View {
    @Binding var path: [Route]
    @Binding var isExpanded: Bool
    let totalPapers = 20
    let papersToShowInitially = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 제목과 논문 개수
            HStack {
                Text("인공지능 검색결과")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                    .foregroundColor(Constants.GrayColorGray800)
                
                Text("\(totalPapers)건")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightSemibold))
                    .foregroundColor(Constants.PrimaryColorPrimary600)
            }
            
            // 논문 리스트
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // 확장 여부에 따라 표시할 논문 개수 조정
                    let papersToShow = isExpanded ? totalPapers : papersToShowInitially
                    ForEach(0..<papersToShow, id: \.self) { _ in
                        PaperRowView(path: $path)
                    }
                    
                    // 논문 정보 더보기 버튼
                    if !isExpanded {
                        ShowMoreButton(isExpanded: $isExpanded)
                            .padding(.top, 16)
                    }
                }
            }
            .frame(maxHeight: isExpanded ? .infinity : CGFloat(papersToShowInitially * 120)) // 확장 여부에 따라 높이 조정
            .animation(.easeInOut, value: isExpanded)
        }
    }
}

// MARK: - PaperRowView
struct PaperRowView: View {
    @Binding var path: [Route]
    
    var body: some View {
        Button(action: {
            path.append(.thesisView)
        }) {
            HStack(spacing: 12) {
                Image("SNU")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Constants.BorderColorBorder1, lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("인공지능과 딥러닝")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightSemibold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Text("서울대학교 인공지능학부")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeXxs).weight(Constants.fontWeightMedium))
                        .foregroundColor(Constants.GrayColorGray800)
                    
                    Text("홍길동 학생")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeXxs).weight(Constants.fontWeightRegular))
                        .foregroundColor(Constants.GrayColorGray600)
                }
                
                Spacer()
            }
            .padding()
            .background(Constants.GrayColorGray50)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Constants.BorderColorBorder1, lineWidth: 1))
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
