//
//  MyPageViewController.swift
//  Thesisfy
//
//  Created by 황필호 on 11/3/24.
//
import SwiftUI

import PopupView

// Bottom Sheet 모서리 설정 확장
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct MyPageView: View {
    @State private var isPresentedBottomSheet = false // BottomSheet 상태 변수
    @State private var isShowLogoutPopup = false // 로그아웃 팝업 상태 변수
    @State private var isShowWithdrawPopup = false // 탈퇴 팝업 상태 변수
    @State private var isShowNotificationSheet = false // 알림 시트 상태 변수
    @State private var showNotificationView = false // NotificationView로 가는 상태 변수 추가
    @State private var showThesisView = false // ThesisView로 네비게이션 상태 변수 추가
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                myPageTopView(isShowNotificationSheet: $isShowNotificationSheet)
                
                Divider()
                
                profileView() // profileView 내부에 수정 버튼을 네비게이션 링크로 변경
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                
                bookMarkView(isPresentedBottomSheet: $isPresentedBottomSheet)
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                setManagementButtonView(
                    isShowLogoutPopup: $isShowLogoutPopup,
                    isShowWithdrawPopup: $isShowWithdrawPopup
                )
                .padding(.top, 24)
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .navigationDestination(isPresented: $showNotificationView) {
                NotificationView()
            }
            .navigationDestination(isPresented: $showThesisView) { // ThesisView 네비게이션 설정
                ThesisView()
            }
            .popup(isPresented: $isPresentedBottomSheet) {
                bookMarkSheetView(showThesisView: $showThesisView) // ThesisView로 가는 바인딩 추가
            } customize: {
                $0
                    .type(.toast)
                    .position(.bottom)
                    .dragToDismiss(true)
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
                    .closeOnTap(false) //버튼 제외 내부 터치 방지
            }
            // 로그아웃 팝업
            .popup(isPresented: $isShowLogoutPopup) {
                LogoutPopupView(isShowLogoutPopup: $isShowLogoutPopup)
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
            // 탈퇴 팝업
            .popup(isPresented: $isShowWithdrawPopup) {
                withdrawPopup(isShowWithdrawPopup: $isShowWithdrawPopup)
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
                    .isOpaque(true) //아마 버튼만 클릭되게
            }
            .popup(isPresented: $isShowNotificationSheet) {
                notificationSheetView(showNotificationView: $showNotificationView)
            } customize: {
                $0
                    .type(.toast)
                    .position(.bottom)
                    .backgroundColor(.black.opacity(0.5))
                    .closeOnTapOutside(true)
                    .dragToDismiss(true)
                    .closeOnTap(false) //버튼 제외 내부 터치 방지
            }
        }
    }
}

struct myPageTopView: View {
    @Binding var isShowNotificationSheet: Bool
    
    var body: some View {
        HStack {
            Text("마이페이지")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeXxl)
                        .weight(Constants.fontWeightSemibold)
                )
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.leading, 24)
            
            Spacer()
            
            Button(action: {
                isShowNotificationSheet.toggle() // 아이콘 클릭 시 알림 시트 표시
            }) {
                Image("icon")
                    .frame(width: 48, height: 48)
                    .padding(.trailing, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Constants.GrayColorWhite)
    }
}

struct profileView: View {
    var body: some View {
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
            
            VStack {
                Text("홍길동 님")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeM)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                    .padding(.trailing, 54)
                
                Spacer()
                    .frame(height: 4)
                
                Text("hong@hansung.ac.kr")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray800)
            }
            
            Spacer()
            
            NavigationLink(destination: ProfileManagementView()) {
                Text("수정하기")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray400)
                    .padding(.trailing, 16)
                    .padding(.top, 65)
            }
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

struct bookMarkView: View {
    @Binding var isPresentedBottomSheet: Bool
    var body: some View {
        VStack {
            HStack {
                Text("관심논문 보러가기")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
                
                Button(action: {
                    isPresentedBottomSheet.toggle()
                }) {
                    Text("더보기")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray400)
                }
            }
            
            Spacer()
                .frame(height: 12)
            
            VStack(spacing: 8) {
                ForEach(0..<2) { _ in
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
                        
                        VStack { // 북마크 이미지를 상단으로 배치하기 위해 VStack 추가
                            Image("bookMark")
                                .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                                .padding(.trailing, 16)
                            
                            Spacer() // 하단에 Spacer를 추가하여 북마크 이미지가 상단으로 올라가도록 함
                        }
                        .padding(.top, 16)
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
    }
}

struct setManagementButtonView: View {
    @Binding var isShowLogoutPopup: Bool
    @Binding var isShowWithdrawPopup: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Button(action: {
                withAnimation {
                    isShowLogoutPopup = true // 로그아웃 팝업 표시
                }
            }) {
                Text("로그아웃")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray400)
            }
            
            Button(action: {
                withAnimation {
                    isShowWithdrawPopup = true // 탈퇴 팝업 표시
                }
            }) {
                Text("탈퇴하기")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray400)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
    }
}

//로그아웃 버튼 뷰
struct LogoutPopupView: View {
    @Binding var isShowLogoutPopup: Bool
    
    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .center) {
                    Text("로그아웃할까요?")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Text("로그아웃하면 서비스 이용이 어려워요. 그래도 로그아웃 할까요?")
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
                        // 로그아웃 처리 로직 추가
                        isShowLogoutPopup = false // 팝업 닫기
                    }) {
                        Text("로그아웃하기")
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
                    .allowsHitTesting(true) // 로그아웃 버튼 클릭 허용
                    
                    Button(action: {
                        isShowLogoutPopup = false // 팝업 닫기
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


// 탈퇴 팝업 뷰
struct withdrawPopup: View {
    @Binding var isShowWithdrawPopup: Bool
    @State private var newNickname: String = "" // 닉네임 입력 변수
    private let currentNickname = "홍길동" // 예제용 기존 닉네임
    
    var body: some View {
        VStack {
            VStack {
                //상단 뷰
                VStack {
                    Text("정말 탈퇴할까요?")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("탈퇴하면 지금까지 이용한 내역이 모두 사라져요. 탈퇴하기 위해서는 닉네임 입력이 필요합니다.")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray800)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                
                Spacer()
                    .frame(height: 20)
                
                //닉네임 입력 뷰
                VStack(alignment: .leading) {
                    Text("닉네임 입력")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Spacer()
                        .frame(height: 8)
                    
                    TextField("닉네임을 입력해 주세요", text: $newNickname)
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
                
                Spacer()
                    .frame(height: 28)
                
                HStack(spacing: 6) {
                    // 탈퇴하기 버튼 - 닉네임 일치 시 색상 변경
                    Button(action: {
                        isShowWithdrawPopup = false // 팝업 닫기
                    }) {
                        Text("탈퇴하기")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeM)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(newNickname == currentNickname ? .white : Constants.GrayColorGray400)
                    }
                    .padding(.horizontal, Constants.fontSizeXs)
                    .padding(.vertical, Constants.fontSizeM)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 48)
                    .background(newNickname == currentNickname ? Color.red : Constants.GrayColorGray100) // 조건에 따른 배경색 변경
                    .cornerRadius(8)
                    
                    HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                        Button(action: {
                            isShowWithdrawPopup = false // 팝업 닫기
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
                    }
                    .padding(.horizontal, Constants.fontSizeXs)
                    .padding(.vertical, Constants.fontSizeM)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 48)
                    .background(Constants.PrimaryColorPrimary500)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Constants.GrayColorWhite)
        .cornerRadius(16)
        .padding(.horizontal, 48)
    }
}


struct bookMarkSheetView: View {
    @Binding var showThesisView: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                //탑 뷰
                HStack {
                    Text("관심논문")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                        .frame(width: 4)
                    
                    Text("7")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                }
                .padding(.leading, 24)
                .padding(.top, 24)
                
                Spacer()
                    .frame(height: 20)
                
                // 북마크 목록
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { index in
                            bookMarkListView(showThesisView: $showThesisView)
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)  // 최대 너비를 먼저 설정
        .frame(height: 600)          // 높이 설정
        .background(Color.white)     // 배경 설정
        .cornerRadius(24, corners: [.topLeft, .topRight])  // 꼭짓점 설정
    }
}

//북마크 리스트 나중에 모델이랑 연결을 편하게 하기 위해 나눠서 코딩 함
struct bookMarkListView: View {
    @Binding var showThesisView: Bool // ThesisView로 가기 위한 상태 바인딩
    
    var body: some View {
        Button(action: {
            showThesisView = true // ThesisView로 네비게이션 트리거
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
                    
                    Spacer()
                        .frame(height: 8)
                    
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
                
                VStack {
                    Image("bookMark")
                        .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                        .padding(.trailing, 16)
                    
                    Spacer()
                }
                .padding(.top, 16)
            }
            .padding(.leading, 16)
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

struct notificationSheetView: View {
    @Binding var showNotificationView: Bool // NotificationView로 가는 바인딩 추가
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                //탑 뷰
                HStack(spacing: 4){
                    Text("전체")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Text("7")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                }
                
                Spacer()
                    .frame(height: 20)
                
                // 알림 뷰
                HStack(spacing: 4) {
                    Text("새로운 알림")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray800)
                    
                    Text("7")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.PrimaryColorPrimary600)
                    
                    Spacer()
                    
                    Text("모두 지우기")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Constants.GrayColorGray400)
                }
                
                Spacer()
                    .frame(height: 12)
                
                //스크롤 리스트
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { index in
                            notificationListView()
                        }
                    }
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            // 더보기 버튼
            Button(action: {
                showNotificationView = true // NotificationView로 이동
            }) {
                HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                    Text("알림 더보기")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray600)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 7))
                        .foregroundColor(Constants.GrayColorGray600)
                }
                .padding(.horizontal, 6)
                .frame(width: 140, height: 36, alignment: .center)
                .background(Constants.GrayColorWhite)
                .cornerRadius(999)
                .overlay(
                    RoundedRectangle(cornerRadius: 999)
                        .inset(by: 0.5)
                        .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                )
            }
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .frame(maxWidth: .infinity)  // 최대 너비를 먼저 설정
        .frame(height: 600)          // 높이 설정
        .background(Color.white)     // 배경 설정
        .cornerRadius(24, corners: [.topLeft, .topRight])  // 꼭짓점 설정
    }
}

//알림 리스트 나중에 모델이랑 연결을 편하게 하기 위해 나눠서 코딩 함
struct notificationListView: View {
    var body: some View {
        HStack {
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
                
                Spacer()
                    .frame(width: 12)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("논문 검색 결과 알림")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.PrimaryColorPrimary600)
                    
                    Spacer()
                        .frame(height: 4)
                    
                    HStack {
                        HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                            Text("딥러닝")
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
                            .frame(width: 4)
                        
                        Text("GPT와 LLM의 관계")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeS)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.GrayColorGray900)
                    }
                    
                    Spacer()
                        .frame(height: 6)
                    
                    Text("서울대학교 홍길동 교수의 논문을 바로 확인해 보세요!")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray600)
                }
            }
            .padding(.leading, 16)
            
            Spacer()
            
            VStack { // 포인트 이미지를 상단으로 배치하기 위해 VStack 추가
                Image("point")
                    .frame(width: 6, height: 6)
                    .background(Constants.PrimaryColorPrimary600)
                    .overlay(
                        Circle()
                            .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                    )
                    .clipShape(Circle())
                
                Spacer() // 하단에 Spacer를 추가하여 북마크 이미지가 상단으로 올라가도록 함
            }
            .padding(.top, 12)
            .padding(.trailing, 12)
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




#Preview {
    MyPageView()
}
