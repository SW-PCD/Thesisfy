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
    
    var body: some View {
        ZStack {
            VStack {
                // 헤더 뷰
                HeaderView(showSideMenu: $showSideMenu)
                
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
    }
    
    // 메시지 전송 함수
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        messages.append(newMessage)
        newMessage = ""
    }
}

struct HeaderView: View {
    @Binding var showSideMenu: Bool
    
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
            
            Image("bell")
                .resizable()
                .frame(width: 48, height: 48)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MainViewController()
}
