//
//  SearchView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/23/24.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack {
            setTopSearchView()
                .padding(.top, 12)
                .navigationBarBackButtonHidden(true)
            
            Spacer()
                .frame(height: 24)
            
            ScrollView(showsIndicators: false) {
                SearchField()
            }
            
            Spacer()
        }
    }
}

struct setTopSearchView: View {
    @Environment(\.dismiss) var dismiss // dismiss 환경 변수를 선언
    
    var body: some View {
        HStack {
            // 사용자 정의 back 버튼
            Button(action: {
                dismiss() // 버튼 클릭 시 이전 화면으로 돌아감
            }) {
                Image("backArrow")
                    .frame(width: 48, height: 48)
                    .padding(.leading, 16)
            }
            
            Spacer()
                .frame(width: 2)
            
            SearchBarView()
                .padding(.trailing, 24)
        }
    }
}

struct SearchBarView: View {
    @State private var searchText: String = "" // 텍스트 필드의 상태 변수
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                TextField("Thesisfy 검색", text: $searchText) // Text를 TextField로 변경
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeS)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                    .padding(.leading, 12)
            }
            
            Spacer()
            
            // 삭제 버튼
            if !searchText.isEmpty { // 텍스트가 있을 때만 표시
                Button(action: {
                    searchText = "" // 텍스트 초기화
                }) {
                    Image("delete")
                        .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                }
                .buttonStyle(PlainButtonStyle()) // 버튼 스타일을 평범하게 설정
            }
              }
        .padding(.horizontal, Constants.fontSizeXs)
        .padding(.vertical, Constants.fontSizeS)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Constants.GrayColorGray50)
        .cornerRadius(6)
    }
}

struct SearchField: View {
    var body: some View {
        ForEach(0..<7) { _ in
            VStack {
                HStack {
                    Image("search")
                        .resizable() // 이미지 크기를 사이즈 조정 가능하도록 변경
                        .frame(width: 25, height: 25) // 아이콘 크기 설정
                    
                    Spacer()
                        .frame(width: 40)
                    
                    Text("인공지능")
                        .font(
                            Font.custom("Pretendard", size: 17)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.left")
                        .resizable() // 이미지 크기를 사이즈 조정 가능하도록 변경
                        .frame(width: 15, height: 15) // 아이콘 크기 설정
                }
                .padding(.top, 5)
                .padding(.trailing, 24)
                .padding(.leading, 30)
            }
            Spacer()
                .frame(height: 15)
            
            Divider()
        }
    }
}

#Preview {
    SearchView()
}
