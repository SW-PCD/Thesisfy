//
//  ThirdTipsViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct ThirdTipsViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showLoginView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // 추가된 섹션
                VStack(alignment: .leading, spacing: 12) {
                    Text("알림 및 보안 팁")
                        .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightBold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            tipSection(
                                emoji: "🔒",
                                title: "안전한 로그인 관리",
                                description: """
                                Thesisfy는 안전한 로그인 시스템을 지원합니다. 개인 정보를 보호하기 위해 강력한 비밀번호를 설정하고, 2단계 인증을 활성화하세요.
                                비밀번호는 정기적으로 변경하는 것이 권장됩니다.
                                """
                            )
                            
                            tipSection(
                                emoji: "📢",
                                title: "알림 설정",
                                description: """
                                알림을 활성화하면 최신 연구 동향과 개인화된 추천 정보를 받을 수 있습니다.
                                필요하지 않은 알림은 설정에서 비활성화하여 집중력을 높일 수 있습니다.
                                """
                            )
                            
                            tipSection(
                                emoji: "📁",
                                title: "논문 데이터 보호",
                                description: """
                                업로드된 논문은 안전하게 암호화되어 저장됩니다.
                                공유 기능을 사용할 경우, 링크와 액세스 권한을 신중히 관리하세요.
                                """
                            )
                            
                            tipSection(
                                emoji: "⚙️",
                                title: "앱 설정 활용하기",
                                description: """
                                설정 메뉴에서 언어, 테마, 알림 빈도 등 사용자 환경을 맞춤화할 수 있습니다.
                                Thesisfy를 자신의 작업 스타일에 맞게 조정하세요.
                                """
                            )
                            
                            Text("💡 이 팁들을 따라 Thesisfy를 더욱 안전하고 효율적으로 활용하세요!")
                                .font(.system(size: Constants.fontSizeS))
                                .foregroundColor(Constants.PrimaryColorPrimary500)
                                .padding(.top, 8)
                        }
                        .padding()
                        .background(Constants.GrayColorGray50)
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                // 로그인하러 가기 버튼
                Button {
                    presentationMode.wrappedValue.dismiss() // 모달을 닫기
                    showLoginView = true // LoginView로 이동
                } label: {
                    NextButtonView(title: "로그인하러가기")
                }
                .fullScreenCover(isPresented: $showLoginView) {
                    LoginViewController()
                }
            }
            .navigationTitle(Text("💡세번째 팁"))
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
    }
}

extension ThirdTipsViewController {
    func tipSection(emoji: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(emoji)
                .font(.system(size: Constants.fontSizeL))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: Constants.fontSizeXxl, weight: Constants.fontWeightBold))
                    .foregroundColor(Constants.GrayColorGray900)
                    .padding(.bottom, 12)
                
                Text(description)
                    .font(.system(size: Constants.fontSizeM))
                    .foregroundColor(Constants.GrayColorGray800)
                    .lineSpacing(4)
                    .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    ThirdTipsViewController()
}
