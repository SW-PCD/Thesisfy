//
//  MainViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct MainViewController: View {
    @State private var messages: [String] = ["안녕하세요!", "논문 추천 서비스에 오신 걸 환영합니다!"] // 초기 메시지
    @State private var newMessage = ""
    @State private var showSideMenu = false // 사이드 메뉴 상태를 관리하는 변수
    @State private var path: [Route] = [] // 네비게이션 경로
    @State private var isShowNotificationSheet = false // 알림 팝업 표시 상태
    
    var body: some View {
        ZStack {
            VStack {
                // 헤더 뷰
                HeaderView(showSideMenu: $showSideMenu, isShowNotificationSheet: $isShowNotificationSheet)
                
                Divider()
                
                // 메시지 목록
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(messages, id: \.self) { message in
                            HStack {
                                if message.contains("안녕하세요") { // 시스템 메시지 구분
                                    Spacer()
                                    Text(message)
                                        .font(Font.custom("Pretendard", size: Constants.fontSizeXs)
                                            .weight(Constants.fontWeightMedium))
                                        .foregroundColor(Constants.GrayColorWhite)
                                        .padding(12)
                                        .background(Constants.PrimaryColorPrimary500)
                                        .cornerRadius(10)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.horizontal)
                                } else { // 사용자 메시지
                                    Text(message)
                                        .font(Font.custom("Pretendard", size: Constants.fontSizeXs)
                                            .weight(Constants.fontWeightMedium))
                                        .foregroundColor(Constants.GrayColorGray800)
                                        .padding(12)
                                        .background(Constants.GrayColorGray50)
                                        .cornerRadius(10)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.vertical, 24)
                }
                
                // 입력창
                HStack {
                    ZStack(alignment: .leading) {
                        if newMessage.isEmpty {
                            Text("궁금한 내용을 검색해 보세요")
                                .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                                .foregroundColor(Constants.GrayColorGray400)
                        }
                        
                        TextField("", text: $newMessage)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.clear, lineWidth: 1)
                            )
                            .frame(height: 48)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        sendMessage()
                    }) {
                        Image("send")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, Constants.fontSizeS)
                .frame(height: 48, alignment: .center)
                .background(Constants.GrayColorGray50)
                .cornerRadius(6)
                .padding(24)
            }
            
            // 사이드 메뉴
            if showSideMenu {
                SideMenu(isSidebarVisible: $showSideMenu)
                    .zIndex(1) // 사이드 메뉴를 최상위로 배치
            }
        }
        // 알림 팝업 뷰
        .popup(isPresented: $isShowNotificationSheet) {
            MainNotificationSheetView(path: $path)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .backgroundColor(.black.opacity(0.5))
                .closeOnTapOutside(true)
                .dragToDismiss(true)
                .closeOnTap(false)
        }
    }
    
    // 메시지 전송 함수
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        messages.append(newMessage)
        newMessage = ""
    }
}

struct MainNotificationSheetView: View {
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
            
            
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .frame(maxWidth: .infinity)  // 최대 너비를 먼저 설정
        .frame(height: 600)          // 높이 설정
        .background(Color.white)     // 배경 설정
        .cornerRadius(24, corners: [.topLeft, .topRight])  // 꼭짓점 설정
    }
}

struct HeaderView: View {
    @Binding var showSideMenu: Bool
    @Binding var isShowNotificationSheet: Bool // 알림 팝업 상태 추가
    
    var body: some View {
        HStack {
            // 사이드 메뉴 버튼
            Button(action: {
                withAnimation(.spring()) {
                    showSideMenu.toggle()
                }
            }) {
                Image("sideMenu")
                    .resizable()
                    .frame(width: 48, height: 48)
            }
            
            Spacer()
            
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 28, height: 28)
                
                Text("Thesisfy")
                    .font(.custom("Pretendard", size: 12))
                    .foregroundStyle(Color.blue) // 예시로 색상 지정
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    isShowNotificationSheet.toggle() // 알림 팝업 표시 상태 전환
                }
            }) {
                Image("bell")
                    .resizable()
                    .frame(width: 48, height: 48)
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MainViewController()
}
