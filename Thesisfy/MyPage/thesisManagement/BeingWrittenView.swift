
//  thesisManagementView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/21/24.
//

import SwiftUI
import ExytePopupView

struct BeingWrittenView: View {
    @Binding var path: [Route] //네비게이션 경로를 전달받기 위해 path 추가
    @State private var progress: Double = 0.3 // 논문 진행 상태
    @State private var isShowEditPopup = false // 편집 팝업 상태 변수
    
    var body: some View {
        VStack {
            setTopView(isShowEditPopup: $isShowEditPopup)
                .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
            
            Spacer()
                .frame(height: 12.15)
            
            Divider()
            
            Spacer()
                .frame(height: 24)
            
            ScrollView(showsIndicators: false) {
                TitleView()
                
                Spacer()
                    .frame(height: 24)
                
                MyThesisView()
                
                Spacer()
                    .frame(height: 24)
                
                progressBar(progress: $progress)
                
                Spacer()
                    .frame(height: 24)
                
                AiRecommendThesisView(onMoreTap: { // 더보기 버튼 클릭 시
                    path.append(.aiRecommendView)
                }, path: $path) // 여기서 path를 전달
                
                Spacer()
                    .frame(height: 24)
                
                MemoView()
                
                Spacer()
            }
            
            ThesisButton()
        }
        // 편집 팝업
        .popup(isPresented: $isShowEditPopup) {
            EditView(isShowEditPopup: $isShowEditPopup)
        } customize: {
            $0
                .type(.default)
                .position(.center)
                .animation(.easeInOut)
                .autohideIn(nil)
                .dragToDismiss(false)
                .closeOnTap(false) //내부 터치 방지
                .closeOnTapOutside(false) // 바깥 터치 방지
                .backgroundColor(.black.opacity(0.5))
                .isOpaque(true)
        }
    }
}

struct setTopView: View {
    @Binding var isShowEditPopup: Bool
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
            
            Button(action: {
                withAnimation {
                    isShowEditPopup = true // 편집 팝업 표시
                }
            }) {
                Image(systemName: "ellipsis")
                    .padding(.trailing, 30)
                    .foregroundColor(Color.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 0)
        .background(Constants.GrayColorWhite)
    }
}

//편집 팝업 뷰
struct EditView: View {
    @Binding var isShowEditPopup: Bool
    
    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .center) {
                    Text("편집")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Text("작성중인 논문을 완료하시면 복구하기 어려워요. 그래도 완료 할까요?")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray800)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 24)
                .allowsHitTesting(false) // 이 영역의 터치 이벤트 비활성화
                
                Spacer()
                    .frame(height: 28)
                
                HStack(spacing: 6) {
                    Button(action: {
                        isShowEditPopup = false // 팝업 닫기
                    }) {
                        Text("완료")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeM)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(Constants.GrayColorGray400)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Constants.GrayColorGray100)
                            .cornerRadius(8)
                    }
                    .allowsHitTesting(true) // 삭제 버튼 클릭 허용
                    
                    Button(action: {
                        isShowEditPopup = false // 팝업 닫기
                    }) {
                        Text("닫기")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeM)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.GrayColorWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Constants.PrimaryColorPrimary500)
                            .cornerRadius(8)
                    }
                    .allowsHitTesting(true) // 닫기 버튼 클릭 허용
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: 200)
        .background(Constants.GrayColorWhite)
        .cornerRadius(16)
        .padding(.horizontal, 48)
        .padding(.top, -10) // 전체 내용을 위로 10 포인트 이동
    }
}

struct TitleView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("한성대 서강준 황필호")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXxl)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
                    .frame(height: 7)
                
                HStack {
                    Text("컴퓨터공학>>인공지능")
                        .font(
                            Font.custom("Pretendard", size: 13)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.PrimaryColorPrimary600)
                }
            }
            Spacer()
        }
        .padding(.leading, 24)
    }
}

struct MyThesisView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("업데이트")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray400)
            }
            
            HStack {
                // 논문 이미지
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
                
                // 논문 제목 및 업데이트 정보
                VStack(alignment: .leading, spacing: 0) {
                    Text("한성대 차은우 황필호.PDF")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    HStack {
                        Text("업데이트")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.GrayColorGray800)
                        
                        Text("2024년 12월 6일 12시 03분")
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
        .padding(.horizontal, 24)
    }
}

struct progressBar: View {
    @Binding var progress: Double // 진행률
    
    var body: some View {
        HStack {
            Text("진행률")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeS)
                        .weight(Constants.fontWeightSemibold)
                )
                .foregroundColor(Constants.GrayColorGray900)
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                .frame(width: 260)
            
            Spacer()
                .frame(width: 5)
            
            Text("\(Int(progress * 100))%")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeS)
                        .weight(Constants.fontWeightSemibold)
                )
                .foregroundColor(Constants.GrayColorGray900)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
}

struct MemoView: View {
    var body: some View {
        VStack {
            HStack {
                Text("메모")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
            }
            
            TextEditor(text: .constant(""))
                .frame(height: 200) // 세로 길이 설정
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeS)
                .background(Constants.GrayColorWhite)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .inset(by: 0.5)
                        .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                )
        }
        .padding(.horizontal, 24)
    }
}

struct AiRecommendThesisView: View {
    let onMoreTap: () -> Void // 더보기 버튼 액션 추가
    @Binding var path: [Route] // 네비게이션 경로 바인딩 추가
    
    var body: some View {
        VStack {
            HStack {
                Text("AI 추천 논문")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.PrimaryColorPrimary600)
                
                Spacer()
                
                Button(action: onMoreTap) { // 더보기 클릭 시 액션 트리거
                    Text("더보기")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray400)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<6) { _ in // 각각의 논문 항목 생성
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
                            .frame(width: 382)
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
            }
        }
        .padding(.horizontal, 24)
    }
}

struct ThesisButton: View {
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                Text("챗봇 사용하기")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeM)
                            .weight(Constants.fontWeightBold)
                    )
                    .foregroundColor(Constants.GrayColorWhite)
            }
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
    }
}

#Preview {
    BeingWrittenView(path: .constant([]))
}

