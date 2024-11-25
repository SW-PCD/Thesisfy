//
//  CompletedThesisView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/23/24.
//

import SwiftUI

struct CompleteThesisView: View {
    @State private var IsShowEditPopup = false // 로그아웃 팝업 상태 변수
    @Binding var path: [Route] // 네비게이션 경로 바인딩 추가
    
    var body: some View {
        VStack {
            SetTopCompleteThesisView(isShowEditPopup: $IsShowEditPopup)
                .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
            
            Spacer()
                .frame(height: 12.15)
            
            Divider()
            
            Spacer()
                .frame(height: 24)
            
            ScrollView(showsIndicators: false) {
                titleView()
                
                Spacer()
                    .frame(height: 24)
                
                myThesisView()
                
                Spacer()
                    .frame(height: 24)
                
                aiRecommendThesisView(onMoreTap: { // 더보기 버튼 클릭 시
                    path.append(.aiRecommendView)
                }, path: $path) // 여기서 path를 전달
                
                Spacer()
                    .frame(height: 24)
                
                memoView()
            }
            thesisButton()
        }
        // 편집 팝업
        .popup(isPresented: $IsShowEditPopup) {
            editView(IsShowEditPopup: $IsShowEditPopup)
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

struct SetTopCompleteThesisView: View {
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
struct editView: View {
    @Binding var IsShowEditPopup: Bool
    
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
                    
                    Text("작성중인 논문을 삭제하시면 복구하기 어려워요. 그래도 삭제 할까요?")
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
                        IsShowEditPopup = false // 팝업 닫기
                    }) {
                        Text("삭제")
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
                        IsShowEditPopup = false // 팝업 닫기
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

struct titleView: View {
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

struct myThesisView: View {
    var body: some View {
        VStack {
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

struct aiRecommendThesisView: View {
    let onMoreTap: () -> Void // 클로저 매개변수 추가
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
                
                Button(action: onMoreTap) {
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

struct memoView: View {
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

struct thesisButton: View {
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
    CompleteThesisView(path: .constant([]))
}
