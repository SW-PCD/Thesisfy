//
//  SecondTipsViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct SecondTipsViewController: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // 추가된 섹션
                VStack(alignment: .leading, spacing: 12) {
                    Text("맞춤형 추천과 요약 + 핵심 기능 활용")
                        .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightBold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 8) {
                                Text("🎯") // 관심 주제 설정에 맞는 이모티콘
                                    .font(.system(size: Constants.fontSizeL))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("관심 주제 설정하기")
                                        .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                                        .foregroundColor(Constants.GrayColorGray900)
                                        .padding(.bottom, 12)
                                    
                                    Text("""
                                    회원가입 시 관심 분야를 선택하면, 맞춤형 추천 시스템이 관련 자료를 자동으로 추천해줍니다.
                                    학술 자료를 즐겨찾기에 추가하면 더 많은 관련 논문이 추천됩니다.
                                    """)
                                    .font(.system(size: Constants.fontSizeM))
                                    .foregroundColor(Constants.GrayColorGray800)
                                    .lineSpacing(4)
                                    .padding(.bottom, 48)
                                }
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Text("⏱️") // 시간 절약에 맞는 이모티콘
                                    .font(.system(size: Constants.fontSizeL))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("논문 요약으로 시간 절약")
                                        .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                                        .foregroundColor(Constants.GrayColorGray900)
                                        .padding(.bottom, 12)
                                    
                                    Text("""
                                    AI가 긴 논문의 핵심 내용을 요약해 제공합니다.
                                    중요한 정보만 빠르게 확인하고, 필요할 경우 전문 열람으로 이어질 수 있습니다.
                                    """)
                                    .font(.system(size: Constants.fontSizeM))
                                    .foregroundColor(Constants.GrayColorGray800)
                                    .lineSpacing(4)
                                    .padding(.bottom, 48)
                                }
                            }

                            HStack(alignment: .top, spacing: 8) {
                                Text("🗂️") // 논문 관리에 맞는 이모티콘
                                    .font(.system(size: Constants.fontSizeL))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("작성 중인 논문 관리")
                                        .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                                        .foregroundColor(Constants.GrayColorGray900)
                                        .padding(.bottom, 12)
                                    
                                    Text("""
                                    작성 중인 논문을 PDF 형식으로 앱에 업로드하여 진행 상황을 시각적으로 관리할 수 있습니다.
                                    OpenAI를 활용한 논문 분석으로 맞춤법 교정, 문체 교정, 표절 검사 등 다양한 기능을 제공합니다.
                                    작성 중인 논문에 대한 피드백을 통해 논문의 완성도를 높일 수 있습니다.
                                    """)
                                    .font(.system(size: Constants.fontSizeM))
                                    .foregroundColor(Constants.GrayColorGray800)
                                    .lineSpacing(4)
                                    .padding(.bottom, 48)
                                }
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Text("🔍") // 검색에 맞는 이모티콘
                                    .font(.system(size: Constants.fontSizeL))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("논문 검색과 상세 보기")
                                        .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                                        .foregroundColor(Constants.GrayColorGray900)
                                        .padding(.bottom, 12)
                                    
                                    Text("""
                                    한국학술지인용색인(KCI) API와 연동하여 주요 논문과 관련 정보를 검색할 수 있습니다.
                                    검색된 논문은 열람, 요약 내용, 인용 정보를 한눈에 확인할 수 있어 편리합니다.
                                    연구 분야, 동향, 기관 정보 등 심화 검색 기능을 활용하면 더 나은 결과를 얻을 수 있습니다.
                                    """)
                                    .font(.system(size: Constants.fontSizeM))
                                    .foregroundColor(Constants.GrayColorGray800)
                                    .lineSpacing(4)
                                    .padding(.bottom, 48)
                                }
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Text("🤖") // AI 지원에 맞는 이모티콘
                                    .font(.system(size: Constants.fontSizeL))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("AI 기반 논문 작성 지원")
                                        .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                                        .foregroundColor(Constants.GrayColorGray900)
                                        .padding(.bottom, 12)
                                    
                                    Text("""
                                    AI 기반 챗봇이 논문 작성과 관련된 질문에 대해 실시간으로 답변을 제공합니다.
                                    연구 방법론, 데이터 분석, 학술적 글쓰기 등 다양한 주제에 대해 도움을 받을 수 있습니다.
                                    관련 논문 추천과 참고자료 제공을 통해 효율적인 논문 작성을 지원합니다.
                                    """)
                                    .font(.system(size: Constants.fontSizeM))
                                    .foregroundColor(Constants.GrayColorGray800)
                                    .lineSpacing(4)
                                    .padding(.bottom, 48)
                                }
                            }
                            
                            Text("💡 이 기능들을 활용하면 논문 검색과 관리, 작성이 훨씬 간편하고 효율적입니다! 마지막 페이지에서는 알림과 보안 팁을 확인하세요.")
                                .font(.system(size: Constants.fontSizeS))
                                .foregroundColor(Constants.PrimaryColorPrimary500)
                                .padding(.top, 8)
                        }
                        // 다음 페이지 버튼
                        NavigationLink(destination: ThirdTipsViewController()) {
                            NextButtonView()
                        }
                    }
                    .padding()
                    .background(Constants.GrayColorGray50)
                    .cornerRadius(8)
                }
            }
            .navigationTitle(Text("💡두번째 팁"))
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
    }
}

struct PreviousActivateButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("이전으로")
                .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
                .foregroundColor(Constants.GrayColorWhite)
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeM)
                .frame(maxWidth: .infinity)
                .background(Constants.PrimaryColorPrimary500)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                )
        }
    }
}

#Preview {
    SecondTipsViewController()
}
