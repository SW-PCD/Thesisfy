//
//  MainViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

// MARK: - Chat View
struct MainViewController: View {
    @State private var messages: [Message] = [
        Message(content: "안녕하세요!", isUser: false),
        Message(content: "논문 추천 서비스에 오신 걸 환영합니다!", isUser: false)
    ] // 초기 메시지
    @State private var newMessage = ""
    @State private var showSideMenu = false // 사이드 메뉴 상태 관리
    @State private var isNewChat = false // 새로운 채팅 상태 관리
    @State private var path: [Route] = [] // 네비게이션 경로
    @State private var isShowNotificationSheet = false // 알림 팝업 상태 관리

    var body: some View {
        ZStack {
            VStack {
                // 헤더 뷰
                HeaderView(showSideMenu: $showSideMenu, isShowNotificationSheet: $isShowNotificationSheet)

                Divider()

                // 메시지 목록
                messageListView

                // 입력창
                messageInputView
            }

            // 사이드 메뉴
            if showSideMenu {
                SideMenu(isSidebarVisible: $showSideMenu, isNewChat: $isNewChat)
                    .zIndex(1) // 사이드 메뉴를 최상위로 배치
            }
        }
        .onChange(of: isNewChat) { newValue in
            if newValue {
                startNewChat()
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

    // MARK: - 메시지 목록 뷰
    private var messageListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                ForEach(messages) { message in
                    HStack {
                        if message.isUser {
                            Spacer()
                            messageBubble(content: message.content, isUser: true)
                        } else {
                            messageBubble(content: message.content, isUser: false)
                            Spacer()
                        }
                    }
                }
            }
            .padding(.vertical, 24)
        }
    }

    // MARK: - 메시지 입력창 뷰
    private var messageInputView: some View {
        HStack {
            TextField("궁금한 내용을 검색해 보세요", text: $newMessage)
                .font(.custom("Pretendard", size: Constants.fontSizeS))
                .fontWeight(Constants.fontWeightMedium)
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.leading, 12)

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
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(Constants.GrayColorGray50)
        .cornerRadius(6)
        .padding(24)
        
    }

    // MARK: - 메시지 버블 뷰
    private func messageBubble(content: String, isUser: Bool) -> some View {
        Text(content)
            .font(Font.custom("Pretendard", size: Constants.fontSizeXs).weight(Constants.fontWeightMedium))
            .foregroundColor(isUser ? Constants.GrayColorWhite : Constants.GrayColorGray800)
            .padding(12)
            .background(isUser ? Constants.PrimaryColorPrimary500 : Constants.GrayColorGray50)
            .cornerRadius(10)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }

    // MARK: - 메시지 전송 함수
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        // 사용자의 메시지 추가
        messages.append(Message(content: newMessage, isUser: true))
        let userMessage = newMessage
        newMessage = ""
        
        // 로딩 메시지 추가
        messages.append(Message(content: "답변을 가져오는 중...", isUser: false))
        
        // OpenAI API 호출
        NetworkManager.shared.sendPromptToChatBot(prompt: userMessage) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reply):
                    // 로딩 메시지를 대체
                    if let lastMessageIndex = messages.lastIndex(where: { !$0.isUser }) {
                        messages[lastMessageIndex] = Message(content: reply, isUser: false)
                    }
                case .failure(let error):
                    // 에러 처리
                    if let lastMessageIndex = messages.lastIndex(where: { !$0.isUser }) {
                        messages[lastMessageIndex] = Message(content: "에러 발생: \(error.localizedDescription)", isUser: false)
                    }
                }
            }
        }
    }

    private func simulateSystemResponse() {
        let systemResponse = "인공지능(AI)은 인간처럼 학습하고, 문제를 해결하며, 의사결정을 내리는 기술입니다. 주요 분야로는 머신러닝(데이터 학습), 딥러닝(인공신경망), 자연어 처리(언어 이해), 컴퓨터 비전(이미지 인식), 로보틱스(로봇 제어)가 있습니다. 활용 사례로는 의료(진단), 금융(사기 탐지), 소비자 서비스(챗봇), 제조업(자동화), 교통(자율주행) 등이 있습니다. AI는 데이터와 계산 능력으로 발전하고 있지만, 윤리적 문제, 설명 가능성 부족, 높은 비용 같은 한계도 있습니다! 😄"

        var displayedText = ""
        DispatchQueue.global().async {
            for char in systemResponse {
                usleep(50_000) // 50ms 지연
                DispatchQueue.main.async {
                    displayedText.append(char)
                    if let lastMessage = messages.last, !lastMessage.isUser {
                        messages[messages.count - 1].content = displayedText
                    } else {
                        messages.append(Message(content: displayedText, isUser: false))
                    }
                }
            }
        }
    }

    // MARK: - 새로운 채팅 초기화
    private func startNewChat() {
        messages = [
            Message(content: "새로운 대화가 시작되었습니다.", isUser: false)
        ]
        isNewChat = false
    }
}

// MARK: - 메시지 모델
struct Message: Identifiable {
    let id = UUID()
    var content: String
    let isUser: Bool // true: 사용자의 메시지, false: 시스템 메시지
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
