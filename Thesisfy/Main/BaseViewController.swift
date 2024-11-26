//
//  BaseViewController.swift
//  Thesisfy
//
//  Created by KKM on 11/20/24.
//

import SwiftUI
import ExytePopupView

struct BaseViewController: View {
    @State private var selectedTab = "main" // 현재 선택된 탭 관리 변수
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 선택된 탭에 따른 뷰 전환
                Group {
                    switch selectedTab {
                    case "find":
                        PaperSearchView()
                    case "main":
                        MainViewController()
                    case "myPage":
                        MyPageView()
                    default:
                        MainViewController()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 하단 탭바
                TabBarView(selectedTab: $selectedTab)
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true) // 상단 네비게이션 바 숨기기
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct TabBarView: View {
    @Binding var selectedTab: String
    
    var body: some View {
        HStack(alignment: .center) {
            // Find Tab
            Button(action: {
                selectedTab = "find"
            }) {
                Image(selectedTab == "find" ? "findSelected" : "find")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            .padding(2)
            .frame(height: 80, alignment: .center)
            
            Spacer()
            
            // Main Tab
            Button(action: {
                selectedTab = "main"
            }) {
                Image(selectedTab == "main" ? "mainSelected" : "main")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            .padding(2)
            .frame(height: 80, alignment: .center)
            
            Spacer()
            
            // MyPage Tab
            Button(action: {
                selectedTab = "myPage"
            }) {
                Image(selectedTab == "myPage" ? "myPageSelected" : "myPage")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            .padding(2)
            .frame(height: 80, alignment: .center)
        }
        .padding(.bottom, 16)
        .padding(.top, 16)
        .padding(.horizontal, 56)
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
    }
}

struct SideMenu: View {
    @Binding var isSidebarVisible: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.8
    var bgColor: Color = Color.white
    
    // 드롭다운 상태를 관리할 변수
    @State private var isTodayExpanded = false
    @State private var isYesterdayExpanded = false
    @State private var isDayBeforeYesterdayExpanded = false
    @State private var isPreviousChatsExpanded = false
    
    // 날짜를 계산하는 변수
    private var todayDate: String { formattedDate(daysAgo: 0) }
    private var yesterdayDate: String { formattedDate(daysAgo: 1) }
    private var dayBeforeYesterdayDate: String { formattedDate(daysAgo: 2) }
    
    var body: some View {
        ZStack {
            // 배경 (어두운 반투명 레이어)
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.6))
            .opacity(isSidebarVisible ? 1 : 0)
            .onTapGesture {
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }
            
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    bgColor
                    VStack(alignment: .leading, spacing: 16) {
                        // "새로운 대화 시작하기" 버튼
                        newChat
                        
                        // 드롭다운 메뉴
                        ScrollView(showsIndicators: false) {
                            dropdownMenu(
                                title: "오늘",
                                subtitle: nil, // 오늘 날짜 동적으로 표시
                                isExpanded: $isTodayExpanded,
                                items: ["바이러스학", "딥러닝", "컴퓨터 비전"]
                            )
                            dropdownMenu(
                                title: "어제",
                                subtitle: yesterdayDate, // 어제 날짜 동적으로 표시
                                isExpanded: $isYesterdayExpanded,
                                items: ["UI/UX 디자인", "실내 인테리어", "인공지능", "머신러닝"]
                            )
                            dropdownMenu(
                                title: "그저께",
                                subtitle: dayBeforeYesterdayDate, // 그저께 날짜 동적으로 표시
                                isExpanded: $isDayBeforeYesterdayExpanded,
                                items: ["UI/UX 디자인", "실내 인테리어", "인공지능", "머신러닝"]
                            )
                            dropdownMenu(
                                title: "이전 대화",
                                subtitle: nil, // 날짜 생략 가능
                                isExpanded: $isPreviousChatsExpanded,
                                items: ["바이러스학", "딥러닝", "컴퓨터 비전", "UI/UX 디자인", "실내 인테리어", "인공지능", "머신러닝"]
                            )
                        }
                    }
                    .padding(.top, 80)
                    .padding(.horizontal, 24)
                }
                .frame(width: sideBarWidth)
                .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
                .animation(.spring(), value: isSidebarVisible)
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // 새로운 대화 시작하기 버튼
    var newChat: some View {
        VStack(alignment: .leading) {
            Button(action: {
                // 새 대화 시작 액션 추가
            }) {
                HStack(spacing: 12) {
                    Image("newChat")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text("새로운 대화 시작하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
    }
    
    func dropdownMenu(title: String, subtitle: String?, isExpanded: Binding<Bool>, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // 드롭다운 제목 버튼
            Button(action: {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(Constants.GrayColorGray400)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(Constants.fontSizeXs)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Constants.GrayColorGray50)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .inset(by: 0.5)
                        .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                )
            }
            
            // 드롭다운 항목
            if isExpanded.wrappedValue {
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            // 각 항목 클릭 액션 추가
                        }) {
                            Text(item)
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding(Constants.fontSizeXs)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
    
    // 날짜 계산 함수
    func formattedDate(daysAgo: Int) -> String {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}

#Preview {
    BaseViewController()
}
