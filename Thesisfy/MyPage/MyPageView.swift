//
//  MyPageViewController.swift
//  Thesisfy
//
//  Created by 황필호 on 11/3/24.
//
import SwiftUI
import ExytePopupView

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
    
    @State private var progress: Double = 0.3 // 논문 진행 상태
    @State private var isEditingbeingWrittenView: Bool = false // 작성중인 논문 편집 모드 상태 변수
    @State private var isEditingCompletedThesisView: Bool = false // 작성 완료된 편집 모드 상태 변수
    @State private var paper: String? = "한성대 서강준 황필호" // 작성 중인 논문 상태
    
    @State private var path: [Route] = [] // 네비게이션 스택을 MyPageView에서 선언
    
    var body: some View {
        NavigationStack(path: $path) { // NavigationStack 추가
            VStack(spacing: 0) {
                myPageTopView(isShowNotificationSheet: $isShowNotificationSheet)
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    profileView(path: $path) // profileView 내부에 수정 버튼을 네비게이션 링크로 변경
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 24)
                    
                    bookMarkView(
                        path: $path,
                        isPresentedBottomSheet: $isPresentedBottomSheet)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Divider()
                    
                    Spacer()
                        .frame(height: 24)
                    
                    beingWrittenView(
                        path: $path, // 네비게이션 스택 전달
                        paper: $paper,
                        progress: $progress,
                        isEditing: $isEditingbeingWrittenView,
                        onDeletebeingWrittenView: { self.paper = nil },
                        onAdd: { self.paper = "한성대 서강준 황필호" }
                    )
                    
                    Spacer()
                        .frame(height: 24)
                    
                    CompletedThesisView(
                        path: $path, // 네비게이션 경로 전달
                        isEditingCompletedThesisView: $isEditingCompletedThesisView
                    )
                    
                    Spacer()
                    
                    setManagementButtonView(
                        isShowLogoutPopup: $isShowLogoutPopup,
                        isShowWithdrawPopup: $isShowWithdrawPopup
                    )
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .beingWrittenView:
                    BeingWrittenView(path: $path) // BeingWrittenView로 네비게이션
                case .completeThesisView:
                        CompleteThesisView(path: $path) // CompleteThesisView로 네비게이션
                case .aiRecommendView:
                    AIRecommendView(path: $path) // AIRecommendView로 네비게이션
                case .thesisView:  // ThesisView로 이동
                        ThesisView()
                case .profileManagementView:
                    ProfileManagementView()
                case .notificationView:
                    NotificationView(path: $path)
                default:
                    Text("Route not handled")
                }
            }
            
            .popup(isPresented: $isPresentedBottomSheet) {
                bookMarkSheetView(path: $path)
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
                notificationSheetView(path: $path)
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
        .navigationBarHidden(true)
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
            
            Spacer()
            
            Button(action: {
                isShowNotificationSheet.toggle() // 아이콘 클릭 시 알림 시트 표시
            }) {
                Image("icon")
                    .frame(width: 48, height: 48)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Constants.GrayColorWhite)
    }
}

struct profileView: View {
    @Binding var path: [Route] //네비게이션 스택 바인딩 추가
    
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
            
            Button(action: {
                path.append(.profileManagementView)
            }) {
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
    @Binding var path: [Route] //네비게이션 스택 바인딩 추가
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
}

struct beingWrittenView: View {
    @Binding var path: [Route] //네비게이션 스택 바인딩 추가
    
    @Binding var paper: String? // 작성 중인 논문 상태
    @Binding var progress: Double // 진행률
    @Binding var isEditing: Bool // 편집 모드 상태
    
    var onDeletebeingWrittenView: () -> Void // 논문 삭제 동작
    var onAdd: () -> Void // 논문 추가 동작
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("작성중인 논문")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
                
                Button(action: {
                    isEditing.toggle() // 편집 상태 토글
                }) {
                    Text(isEditing ? "완료" : "편집")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(isEditing ? .blue : Constants.GrayColorGray400)
                }
            }
            
            if let paper = paper {
                Button(action: {
                    path.append(.beingWrittenView) // 네비게이션 경로 추가
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
                            Text(paper)
                                .font(
                                    Font.custom("Pretendard", size: Constants.fontSizeS)
                                        .weight(Constants.fontWeightSemibold)
                                )
                                .foregroundColor(Constants.GrayColorGray900)
                            
                            Spacer()
                                .frame(height: 2)
                            
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
                            
                            Spacer()
                                .frame(height: 8)
                            
                            HStack {
                                Text("진행률")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                            .weight(Constants.fontWeightSemibold)
                                    )
                                    .foregroundColor(Constants.GrayColorGray800)
                                
                                ProgressView(value: progress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                                    .frame(width: 105)
                                
                                Spacer()
                                    .frame(width: 5)
                                
                                Text("\(Int(progress * 100))%")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                            .weight(Constants.fontWeightSemibold)
                                    )
                                    .foregroundColor(Constants.GrayColorGray800)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            if isEditing {
                                Button(action: onDeletebeingWrittenView) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Constants.GrayColorGray50)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                    )
                }
            } else {
                Button(action: onAdd) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(Constants.PrimaryColorPrimary500)
                        Text("추가")
                            .foregroundColor(Constants.PrimaryColorPrimary500)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 3]))
                            .foregroundColor(Constants.PrimaryColorPrimary500)
                    )
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// 추가 버튼 UI
struct AddButtonView: View {
    var onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(Constants.PrimaryColorPrimary500)
                
                Text("추가")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.PrimaryColorPrimary500)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(.white)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [5, 3])) // 점선 패턴
                    .foregroundColor(Constants.PrimaryColorPrimary500) // 선 색상
            )
        }
    }
}

struct CompletedThesisView: View {
    @Binding var path: [Route] // 네비게이션 경로 바인딩 추가
    
    @Binding var isEditingCompletedThesisView: Bool // 편집 모드 상태
    @State private var isSectionOpen = true // 섹션 열림/닫힘 상태
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    isSectionOpen.toggle() // 열림/닫힘 상태 토글
                }) {
                    HStack {
                        Text("작성 완료된 논문")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeL)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.GrayColorGray900)
                        
                        Spacer()
                        
                        if isSectionOpen {
                            Button(action: {
                                isEditingCompletedThesisView.toggle() // 편집 상태 토글
                            }) {
                                Text(isEditingCompletedThesisView ? "완료" : "편집")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                            .weight(Constants.fontWeightMedium)
                                    )
                                    .foregroundColor(isEditingCompletedThesisView ? .blue : Constants.GrayColorGray400)
                            }
                        }
                        
                        Spacer()
                            .frame(width: 14)
                        
                        Image(systemName: isSectionOpen ? "chevron.up" : "chevron.down")
                            .foregroundColor(Constants.GrayColorGray900)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if isSectionOpen {
                ForEach(0..<3) { _ in
                    Button(action: {
                        path.append(.completeThesisView) // CompleteThesisView로 이동
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
                                Text("한성대 차은우 황필호")
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
                            
                            // 삭제 버튼 (편집 모드에서만 표시)
                            VStack {
                                if isEditingCompletedThesisView {
                                    Button(action: {
                                        print("논문 삭제 동작")
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                                }
                                Spacer()
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
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
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
    @State private var inputPassword: String = "" // 비밀번호 입력 변수
    private let correctPassword = "1234" // 임의 설정된 비밀번호

    var body: some View {
        VStack {
            VStack {
                // 상단 뷰
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
                    
                    Text("탈퇴하면 지금까지 이용한 내역이 모두 사라져요. 탈퇴하기 위해서는 비밀번호 입력이 필요합니다.")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray800)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                
                Spacer()
                    .frame(height: 20)
                
                // 비밀번호 입력 뷰
                VStack(alignment: .leading) {
                    Text("비밀번호 입력")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Spacer()
                        .frame(height: 8)
                    
                    SecureField("비밀번호를 입력해 주세요", text: $inputPassword) // SecureField로 수정
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
                    // 탈퇴하기 버튼 - 비밀번호 일치 시 색상 변경
                    Button(action: {
                        if inputPassword == correctPassword {
                            isShowWithdrawPopup = false // 팝업 닫기
                            // 탈퇴 로직 추가 가능
                        }
                    }) {
                        Text("탈퇴하기")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeM)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(inputPassword == correctPassword ? .white : Constants.GrayColorGray400)
                    }
                    .padding(.horizontal, Constants.fontSizeXs)
                    .padding(.vertical, Constants.fontSizeM)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 48)
                    .background(inputPassword == correctPassword ? Color.red : Constants.GrayColorGray100) // 조건에 따른 배경색 변경
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
    @Binding var path: [Route] // 네비게이션 경로 바인딩 추가
    
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
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { index in
                            bookMarkListView(path: $path)
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
    @Binding var path: [Route] // 네비게이션 경로 바인딩 추가
    
    var body: some View {
        Button(action: {
            path.append(.thesisView) // Route에 thesisView 추가
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
    @Binding var path: [Route] // 네비게이션 경로 바인딩 추가
    
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
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { index in
                            notificationListView(path: $path)
                        }
                    }
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            // 더보기 버튼
            Button(action: {
                path.append(.notificationView)
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
    @Binding var path: [Route] // 네비게이션 경로 바인딩 추가
    
    var body: some View {
        
        Button(action: {
            path.append(.thesisView) // Route에 thesisView 추가
        }) {
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
}

#Preview {
    MyPageView()
}
