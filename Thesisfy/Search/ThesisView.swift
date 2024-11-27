//
//  ThesisView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/9/24.
//

import SwiftUI

struct ThesisView: View {
    var body: some View {
        VStack {
            setTopThesisView()
            
            Spacer()
                .frame(height: 0)
            
            Divider()
            
            Spacer()
                .frame(height: 0)
            
            ThesisTitleView()
            
            Spacer()
                .frame(height: 20)
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 430, height: 8)
              .background(Constants.GrayColorGray50)
            
            Spacer()
                .frame(height: 20)
            
            ThesisBottomView()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 백 버튼 숨기기
    }
}

struct setTopThesisView: View {
    @Environment(\.dismiss) var dismiss // dismiss 환경 변수를 선언
    
    var body: some View {
        HStack {
            // 사용자 정의 back 버튼
            Button(action: {
                dismiss()
            }) {
                Image("backArrow")
                    .frame(width: 48, height: 48)
                    .padding(.leading, 16)
            }
            
            Spacer()
                .frame(width: 92)
            
            Text("논문 상세보기")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeXl)
                        .weight(Constants.fontWeightSemibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.leading, -8) //@@ 위치 강제로 맞춘거 나중에 수정
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 0)
        .background(Constants.GrayColorWhite)
    }
}

struct ThesisTitleView: View {
    @State private var isBookmarked = false // 북마크 상태 변수 추가
    
    var body: some View {
        VStack {
            // 버튼제외 상단 뷰
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                        Text("인공지능")
                          .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                              .weight(Constants.fontWeightSemibold)
                          )
                          .foregroundColor(Constants.PrimaryColorPrimary600)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Constants.PrimaryColorPrimary50)
                    .cornerRadius(6)
                    
                    Spacer()
                        .frame(height: 11)
                    
                    Text("인공지능과 딥러닝")
                      .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                          .weight(Constants.fontWeightSemibold)
                      )
                      .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                        .frame(height: 6)
                    
                    HStack(spacing: 6) {
                        Text("서울대학교 인공지능학부")
                          .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                              .weight(Constants.fontWeightSemibold)
                          )
                          .foregroundColor(Constants.GrayColorGray800)
                        
                        Text("홍길동 학생")
                          .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                              .weight(Constants.fontWeightMedium)
                          )
                          .foregroundColor(Constants.GrayColorGray600)
                    }
                }
                Spacer()
                
                VStack {
                    Button(action: {
                        isBookmarked.toggle() // 버튼 클릭 시 상태 토글
                    }) {
                        Image(isBookmarked ? "bookMark" : "bookMark") // 상태에 따라 이미지 변경
                        // 추후 오른쪽 bookMarkOff로 변경 해야함
                            .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                    }
                    
                    Spacer()
            
                }
                .padding(.top, 24)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 28)
            
            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                Text("논문 전체 보기")
                  .font(
                    Font.custom("Pretendard", size: Constants.fontSizeM)
                      .weight(Constants.fontWeightBold)
                  )
                  .foregroundColor(Constants.GrayColorWhite)
            }
            .padding(.horizontal, Constants.fontSizeXs)
            .padding(.vertical, Constants.fontSizeM)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Constants.PrimaryColorPrimary500)
            .cornerRadius(Constants.fontSizeXs)
            .overlay(
              RoundedRectangle(cornerRadius: Constants.fontSizeXs)
                .inset(by: 0.5)
                .stroke(Constants.BorderColorBorder1, lineWidth: 1)
            )
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 195)
    }
}

struct ThesisBottomView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            //목차 하나 하나 hstack으로 묶음
            HStack {
                Text("목차")
                  .font(
                    Font.custom("Pretendard", size: Constants.fontSizeM)
                      .weight(Constants.fontWeightSemibold)
                  )
                  .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
            }
            
            HStack {
                Text("1. -")
                  .font(
                    Font.custom("Pretendard", size: Constants.fontSizeXs)
                      .weight(Constants.fontWeightSemibold)
                  )
                  .foregroundColor(Constants.GrayColorGray800)
                
                Spacer()
            }
            
            
            HStack {
                Text("• -")
                  .font(
                    Font.custom("Pretendard", size: Constants.fontSizeXs)
                      .weight(Constants.fontWeightSemibold)
                  )
                  .foregroundColor(Constants.GrayColorGray800)
                
                Spacer()
            }
            
            HStack {
                Text("1. -")
                  .font(
                    Font.custom("Pretendard", size: Constants.fontSizeXs)
                      .weight(Constants.fontWeightSemibold)
                  )
                  .foregroundColor(Constants.GrayColorGray800)
                
                Spacer()
            }
            
            
            HStack {
                Text("• -")
                  .font(
                    Font.custom("Pretendard", size: Constants.fontSizeXs)
                      .weight(Constants.fontWeightSemibold)
                  )
                  .foregroundColor(Constants.GrayColorGray800)
                
                Spacer()
            }
        }
        .padding(.leading, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 125)
        .background(Constants.GrayColorGray50)
        .cornerRadius(6)
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .inset(by: 0.5)
            .stroke(Constants.BorderColorBorder1, lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    ThesisView()
}
