
//
//  AIRecommendView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/22/24.
//

import SwiftUI

struct AIRecommendView: View {
    @State private var isExpanded = false  // 리스트 확장 여부를 저장하는 상태 변수
    @Binding var path: [Route]  // 네비게이션 경로를 바인딩으로 받아옴

    var body: some View {
            VStack(spacing: 0) {
                SetTopView()
                    .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
                
                Spacer()
                    .frame(height: 24)
                
                paperListView(path: $path, isExpanded: $isExpanded)  // 바인딩 변수 전달
                
                Spacer()
                    .frame(height: 32)
                
                if !isExpanded {  // 리스트가 확장되지 않았을 때만 버튼 표시
                    showMoreButton(isExpanded: $isExpanded)  // 바인딩 변수 전달
                        .padding(.top, 16)
                } else {
                    // 버튼이 없어도 같은 높이를 유지하기 위해 빈 공간 추가
                    Color.clear
                        .frame(height: 52)  // ShowMoreButton과 동일한 높이 설정
                }
                
                Spacer(minLength: 12)  // 화면 하단에 일정한 여백 확보
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)  // 전체 화면을 채우되 위쪽 정렬
            .background(Color.white)
            .ignoresSafeArea(.container, edges: .bottom) // 하단 여백 문제 방지
        }
    }

struct SetTopView: View {
    @Environment(\.dismiss) var dismiss // dismiss 환경 변수를 선언
    
    var body: some View {
        HStack {
            // 사용자 정의 back 버튼
            Button(action: {
                dismiss() // 버튼 클릭 시 이전 화면으로 돌아감
            }) {
                Image("backArrow")
                    .frame(width: 48, height: 48)
            }
            
            Spacer()
            
            Text("AI 추천 논문")
              .font(
                Font.custom("Pretendard", size: Constants.fontSizeXl)
                  .weight(Constants.fontWeightSemibold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Constants.GrayColorGray900)
              .padding(.leading, -47) //@@ 위치 강제로 맞춘거 나중에 수정
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Constants.GrayColorWhite)
    }
}

struct paperListView: View {
    @Binding var path: [Route]  // 네비게이션 경로를 바인딩으로 받아옴
    @Binding var isExpanded: Bool  // 리스트 확장 여부를 바인딩으로 수정
    
    let totalPapers = 20  // 예시 데이터 총 개수
    let papersToShowInitially = 5  // 초기 표시 개수

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Text("인공지능 검색결과")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeS)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray800)
                
                Text("\(totalPapers)건")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeS)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.PrimaryColorPrimary600)
            }
            
            // 버튼이 있을 때와 없을 때의 간격을 동일하게 유지
            .padding(.bottom, isExpanded ? 12 : 28)  // 확장 여부에 따라 간격 조정
            
            if isExpanded {
                // 확장된 상태에서는 ScrollView로 모든 논문 표시
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(0..<totalPapers, id: \.self) { _ in
                            paperRowView(path: $path)
                        }
                    }
                    .padding(.bottom, 24) // 하단 여백 추가
                }
                .frame(maxHeight: .infinity) // 화면 아래까지 확장
            } else {
                // 확장되지 않은 상태에서는 ScrollView 없이 5개의 논문만 표시
                VStack(spacing: 8) {
                    ForEach(0..<papersToShowInitially, id: \.self) { _ in
                        paperRowView(path: $path)
                    }
                }
                .frame(maxHeight: CGFloat(5 * 100))  // 초기 5개의 논문만 표시
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)  // 상단 정렬
                .background(Color.white)  // 배경색 설정
    }
}

// PaperRowView로 리스트의 각 항목을 분리하여 깔끔하게 유지
struct paperRowView: View {
    @Binding var path: [Route]  // 네비게이션 경로를 바인딩으로 받아옴
    
    var body: some View {
        Button(action: {
            path.append(.thesisView) // ThesisView로 이동
        }) {
            HStack {
                Image("logo image")
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
                        Text("인공지능")
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
                    
                    Text("인공지능과 딥러닝")
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
                        
                        Text("홍길동 학생")
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

struct showMoreButton: View {
    @Binding var isExpanded: Bool  // 버튼에서 확장 여부를 변경할 수 있도록 바인딩 변수로 설정

    var body: some View {
        Button(action: {
            isExpanded.toggle()  // 버튼을 누를 때 확장 여부 토글
        }) {
            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                Text("논문 정보 더보기")  // 상태와 상관없이 동일한 텍스트 사용
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray600)
                
                Image("downArrow")
                    .frame(width: Constants.fontSizeXs, height: Constants.fontSizeXs)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(width: 140)
            .frame(height: 36)
            .background(Constants.GrayColorWhite)
            .cornerRadius(999)
            .overlay(
                RoundedRectangle(cornerRadius: 999)
                    .inset(by: 0.5)
                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
            )
        }
    }
}

#Preview {
    AIRecommendView(path: .constant([]))
}
