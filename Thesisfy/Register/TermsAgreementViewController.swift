//
//  TermsAgreementViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct TermsAgreementViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showModal = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 헤더
                headerView
                
                Divider()
                
                // 약관 내용
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        sectionView(
                            title: "[필수] 서비스 이용 약관 동의",
                            content: """
                            본 서비스는 개인 및 비상업적 목적으로만 제공됩니다. 상업적 이용은 금지됩니다.

                            사용자의 의무:
                            - 허위 정보 입력 금지
                            - 불법적 사용 및 안정성 저해 행위 금지

                            서비스 변경 및 종료:
                            - 운영 필요에 따라 사전 고지 후 변경 또는 중단될 수 있습니다.

                            책임 제한:
                            - 학술 정보의 정확성이나 완전성에 대한 법적 책임은 제한됩니다.
                            """
                        )
                        
                        sectionView(
                            title: "[필수] 개인정보 처리 방침 동의",
                            content: """
                            수집 및 이용 목적:
                            - 회원가입, 서비스 제공, 맞춤형 추천

                            수집 항목:
                            - 필수: 이름, 이메일, 비밀번호
                            - 선택: 관심 학술 분야, 검색 기록

                            보관 기간:
                            - 이용 기간 동안만 보관하며, 탈퇴 시 삭제됩니다.

                            제3자 제공:
                            - 사용자 동의 없이는 제공되지 않습니다.

                            이용자의 권리:
                            - 정보 열람, 수정, 삭제 요청 가능
                            """
                        )
                        
                        sectionView(
                            title: "[필수] 맞춤형 서비스 및 광고 수신 동의",
                            content: """
                            목적:
                            - 관심 분야에 기반한 학술 자료와 광고 정보 제공

                            수신 정보:
                            - 이메일: 최신 연구 동향, 추천 논문
                            - 알림: 맞춤형 서비스 업데이트

                            동의 철회:
                            - 철회 후에도 서비스 이용에는 제한이 없습니다.
                            """
                        )
                        
                        sectionView(
                            title: "[필수] 이메일 및 알림 수신 동의",
                            content: """
                            목적:
                            - 관심 분야 기반의 학술 자료, 서비스 업데이트 소식 제공

                            수신 정보:
                            - 이메일: 학술 자료 추천, 연구 트렌드 업데이트
                            - 알림: 새로운 자료 추가

                            동의 항목:
                            - 서비스 이용 약관 및 개인정보 처리 방침에 동의합니다.
                            - 맞춤형 서비스 및 광고 수신에 동의합니다.
                            - 이메일 및 알림 수신에 동의합니다.
                            """
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
                
                Spacer()
                
                // 동의 버튼
                Button {
                    showModal = true
                } label: {
                    AgreeButtonView()
                }
                .sheet(isPresented: $showModal) {
                    FirstTipsViewController()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    // 헤더 뷰
    private var headerView: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("회원가입")
                .font(.system(size: Constants.fontSizeXl, weight: Constants.fontWeightSemibold))
                .foregroundColor(Constants.GrayColorGray900)
            
            Spacer()
            
            Image("") // 오른쪽 여백 균형을 위해
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
    }
    
    // 섹션 뷰
    @ViewBuilder
    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightBold))
                .foregroundColor(Constants.GrayColorGray900)
            
            Text(content)
                .font(.system(size: Constants.fontSizeM))
                .foregroundColor(Constants.GrayColorGray800)
                .lineSpacing(6)
        }
    }
}

struct AgreeButtonView: View {
    var title: String = "약관동의 및 다음으로" // 기본값 설정
    
    var body: some View {
        Text(title)
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

#Preview {
    TermsAgreementViewController()
}
