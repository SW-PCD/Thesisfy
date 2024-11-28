//
//  MainViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    private var _center: NotificationCenter

    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        _center.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            currentHeight = keyboardFrame.height - 90 // 탭바 높이만큼 조정
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

class MessageManager: ObservableObject {
    static let shared = MessageManager() // 싱글톤
    @Published var messages: [Message] = [
        Message(content: "안녕하세요!", isUser: false),
        Message(content: "논문 추천 서비스에 오신 걸 환영합니다!", isUser: false)
    ]

    private init() {}
}

struct MainViewController: View {
    @StateObject private var messageManager = MessageManager.shared
    @State private var newMessage = ""
    @State private var showSideMenu = false
    @State private var isNewChat = false
    @State private var path: [Route] = []
    @State private var isShowNotificationSheet = false
    @State private var showLoadingAnimation = false

    @ObservedObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        ZStack {
            VStack {
                // 헤더 뷰
                HeaderView(showSideMenu: $showSideMenu, isShowNotificationSheet: $isShowNotificationSheet)

                Divider()

                // 메시지 목록
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(messageManager.messages) { message in
                                HStack {
                                    if message.isUser {
                                        Spacer()
                                        messageBubble(content: message.content, isUser: true)
                                    } else {
                                        messageBubble(content: message.content, isUser: false, isLoading: message.isLoading)
                                        Spacer()
                                    }
                                }
                                .id(message.id) // 메시지에 고유 ID를 할당
                            }
                        }
                        .padding(.vertical, 24)
                        .padding(.bottom, keyboardResponder.currentHeight) // 키보드 높이에 따라 여백 추가
                        .onChange(of: messageManager.messages) { _ in
                            scrollToBottom(proxy: proxy) // 새로운 메시지가 추가되면 스크롤
                        }
                    }
                }

                Spacer()
                
                // 메시지 입력창
                VStack {
                    messageInputView
                        .padding(.bottom, keyboardResponder.currentHeight) // 키보드 높이에 따라 입력창 위치 조정
                        .animation(.easeOut(duration: 0.3), value: keyboardResponder.currentHeight)
                }
            }

            // 사이드 메뉴
            if showSideMenu {
                SideMenu(isSidebarVisible: $showSideMenu, isNewChat: $isNewChat)
                    .zIndex(1)
            }
        }
        .onChange(of: isNewChat) { newValue in
            if newValue {
                startNewChat()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // 키보드 닫기
        }
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

    // 메시지 입력창 뷰
    private var messageInputView: some View {
        HStack(spacing: 12) {
            // 입력 텍스트 필드
            TextField("메시지를 입력하세요...", text: $newMessage)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Constants.GrayColorGray50)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                )
                .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                .foregroundColor(Constants.GrayColorGray900)

            // 전송 버튼
            Button(action: {
                sendMessage()
            }) {
                Image(newMessage.isEmpty ? "send" : "send.fill") // 동적으로 이미지 변경
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(newMessage.isEmpty ? Constants.GrayColorGray400 : Constants.PrimaryColorPrimary100)
            }
            .padding(12)
            .background(newMessage.isEmpty ? Constants.GrayColorGray100 : Constants.PrimaryColorPrimary50)
            .cornerRadius(10)
            .disabled(newMessage.isEmpty) // 메시지가 비어있으면 버튼 비활성화
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 10)
        .background(Color.white)
    }

    // 메시지 버블 뷰
    private func messageBubble(content: String, isUser: Bool, isLoading: Bool = false) -> some View {
        HStack {
            if isLoading {
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(isUser ? Constants.GrayColorWhite : Constants.PrimaryColorPrimary500)
                            .frame(width: 8, height: 8)
                            .offset(x: showLoadingAnimation && isLoading ? 10 : -10)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: showLoadingAnimation
                            )
                            .padding(.leading, 24)
                            .padding(.top, 24)
                    }
                }
                .onAppear {
                    if isLoading {
                        showLoadingAnimation = true
                    }
                }
            } else {
                Text(content)
                    .font(Font.custom("Pretendard", size: Constants.fontSizeM).weight(Constants.fontWeightRegular))
                    .foregroundColor(isUser ? Constants.GrayColorWhite : Constants.GrayColorGray800)
                    .padding(12)
                    .background(isUser ? Constants.PrimaryColorPrimary500 : Constants.GrayColorGray50)
                    .cornerRadius(10)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
        }
    }

    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        messageManager.messages.append(Message(content: newMessage, isUser: true))
        let userMessage = newMessage
        newMessage = ""

        showLoadingAnimation = false
        messageManager.messages.append(Message(content: "", isUser: false, isLoading: true))

        NetworkManager.shared.sendPromptToChatBot(prompt: userMessage) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reply):
                    animateReply(reply)
                case .failure(let error):
                    if let lastMessageIndex = messageManager.messages.lastIndex(where: { !$0.isUser }) {
                        messageManager.messages[lastMessageIndex] = Message(content: "에러 발생: \(error.localizedDescription)", isUser: false)
                    }
                }
            }
        }
    }

    private func animateReply(_ reply: String) {
        guard let lastMessageIndex = messageManager.messages.lastIndex(where: { !$0.isUser }) else { return }
        var displayedText = ""
        messageManager.messages[lastMessageIndex] = Message(content: "", isUser: false, isLoading: false)

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if displayedText.count < reply.count {
                let index = reply.index(reply.startIndex, offsetBy: displayedText.count)
                displayedText.append(reply[index])
                messageManager.messages[lastMessageIndex] = Message(content: displayedText, isUser: false)
            } else {
                timer.invalidate()
            }
        }
    }

    private func startNewChat() {
        messageManager.messages = [
            Message(content: "새로운 대화가 시작되었습니다.", isUser: false)
        ]
        isNewChat = false
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessageID = messageManager.messages.last?.id {
            withAnimation {
                proxy.scrollTo(lastMessageID, anchor: .bottom)
            }
        }
    }
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    var content: String
    let isUser: Bool
    var isLoading: Bool = false
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
