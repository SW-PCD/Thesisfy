//
//  TipsViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct FirstTipsViewController: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // 추가된 섹션
                VStack(alignment: .leading, spacing: 12) {
                    Text("효율적인 검색 방법")
                        .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightBold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 8) {
                            Text("📌")
                                .font(.system(size: Constants.fontSizeL))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("자연어로 질문하기")
                                    .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                                    .foregroundColor(Constants.GrayColorGray900)
                                    .padding(.bottom, 12)
                                
                                Text("""
                                검색창에 **“암 연구에 대한 최신 논문 추천해줘”**처럼 질문을 입력하면 AI가 의도를 파악해 관련 자료를 추천합니다.
                                키워드보다 구체적인 문장을 입력하면 원하는 결과를 더 정확하게 찾을 수 있습니다.
                                """)
                                    .font(.system(size: Constants.fontSizeM))
                                    .foregroundColor(Constants.GrayColorGray800)
                                    .lineSpacing(4)
                                    .padding(.bottom, 48)
                            }
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("📌")
                                .font(.system(size: Constants.fontSizeL))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("키워드 조합 활용하기")
                                    .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                                    .foregroundColor(Constants.GrayColorGray900)
                                    .padding(.bottom, 12)

                                
                                Text("""
                                키워드를 조합하거나 관련된 단어를 추가해보세요.
                                예: "암 치료", "면역 요법" 같이 구체적인 단어를 함께 사용하면 더 나은 결과를 얻을 수 있습니다.
                                """)
                                .font(.system(size: Constants.fontSizeM))
                                .foregroundColor(Constants.GrayColorGray800)
                                .lineSpacing(4)
                                .padding(.bottom, 48)
                            }
                        }
                        
                        Text("💡 다음 페이지에서 추천과 요약 기능에 대해 알아보세요.")
                            .font(.system(size: Constants.fontSizeS))
                            .foregroundColor(Constants.PrimaryColorPrimary500)
                            .padding(.top, 8)
                    }
                    .padding()
                    .background(Constants.GrayColorGray50)
                    .cornerRadius(8)
                }
                
                Spacer()
                
                // 다음 페이지 버튼
                NavigationLink(destination: SecondTipsViewController()) {
                    NextButtonView()
                }
            }
            .navigationTitle(Text("💡첫번째 팁"))
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
    }
}


struct PreviousButtonView: View {
    var body: some View {
        Text("이전으로")
            .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
            .foregroundColor(Constants.GrayColorWhite)
            .padding(.horizontal, Constants.fontSizeXs)
            .padding(.vertical, Constants.fontSizeM)
            .frame(maxWidth: .infinity)
            .background(Constants.PrimaryColorPrimary100)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
            )
    }
}


#Preview {
    FirstTipsViewController()
}
