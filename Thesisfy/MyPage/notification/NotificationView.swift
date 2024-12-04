//
//  NotificationView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/9/24.
//

import SwiftUI

struct NotificationView: View {
    @Binding var path: [Route] // NavigationStack의 경로 바인딩 추가
    
    @State private var newNotificationsCount: Int = 5 // 새로운 알림 수
    @State private var readNotificationsCount: Int = 5 // 이미 읽은 알림 수
    
    var totalNotificationsCount: Int {
        newNotificationsCount + readNotificationsCount
    }
    
    var body: some View {
            VStack {
                setTopNotificationView()
                    .navigationBarBackButtonHidden(true)
                
                Spacer()
                    .frame(height: 12)
                
                Divider()
                
                Spacer()
                    .frame(height: 20)
                
                TotalCountView(totalCount: totalNotificationsCount)
                
                Spacer()
                    .frame(height: 12)
                
                NotificationListView(path: $path,
                                     newNotificationsCount: $newNotificationsCount, readNotificationsCount: $readNotificationsCount)
            }
    }
}

struct setTopNotificationView: View {
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
                .frame(width: 92)
            
            Text("전체 알림")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeXl)
                        .weight(Constants.fontWeightSemibold)
                )
                .padding(.leading, 6) // @@위치 강제로 맞춘거 나중에 필요하면 수정
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.GrayColorGray900)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 0)
        .background(Constants.GrayColorWhite)
    }
}

struct TotalCountView: View {
    var totalCount: Int // 전체 알림 수를 받을 변수
    
    var body: some View {
        HStack(spacing: 4) {
            Text("전체")
              .font(
                Font.custom("Pretendard", size: Constants.fontSizeL)
                  .weight(Constants.fontWeightSemibold)
              )
              .foregroundColor(Constants.GrayColorGray900)
            
            Text("\(totalCount)")
              .font(
                Font.custom("Pretendard", size: Constants.fontSizeL)
                  .weight(Constants.fontWeightSemibold)
              )
              .foregroundColor(Constants.GrayColorGray900)
            
            Spacer()
        }
        .padding(.leading, 24)
    }
}

struct NotificationListView:View {
    @Binding var path: [Route] // NavigationStack의 경로 바인딩 추가
    
    @Binding var newNotificationsCount: Int // 새로운 알림 수
    @Binding var readNotificationsCount: Int // 이미 읽은 알림 수
    
    var totalNotificationsCount: Int {
        newNotificationsCount + readNotificationsCount
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 4) {
                Text("새로운 알림")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeM)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray800)
                
                Text("\(newNotificationsCount)")
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
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            
            // 스크롤 리스트
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(0..<newNotificationsCount, id: \.self) { index in
                        NewNotificationListView(path: $path)
                    }
                        
                    ForEach(0..<readNotificationsCount, id: \.self) { index in
                        CheckedNotificationListView(path: $path)
                        }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

//알림 리스트 나중에 모델이랑 연결을 편하게 하기 위해 나눠서 코딩 함
struct NewNotificationListView: View {
    @Binding var path: [Route] // NavigationStack의 경로 바인딩 추가
    
    var body: some View {
            Button(action: {
                path.append(.thesisView(articleId: nil)) // thesisView로 이동
            }) {
                HStack {
                    HStack {
                        Image("SNU")
                            .resizable()
                            .frame(width: 42, height: 43)
                            .background(Circle().fill(Constants.GrayColorWhite))
                            .overlay(
                                Circle()
                                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                            )
                        
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
                    
                    VStack { // 북마크 이미지를 상단으로 배치하기 위해 VStack 추가
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

// 이미 확인한 알림
struct CheckedNotificationListView: View {
    @Binding var path: [Route] // NavigationStack의 경로 바인딩 추가
    
    var body: some View {
        Button(action: {
            path.append(.thesisView(articleId: nil)) // thesisView로 이동
        }) {
            HStack {
                HStack {
                    Image("SNU")
                        .resizable()
                        .frame(width: 42, height: 43)
                        .background(Circle().fill(Constants.GrayColorWhite))
                        .overlay(
                            Circle()
                                .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                        )
                    
                    Spacer()
                        .frame(width: 12)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("논문 검색 결과 알림")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.GrayColorGray500)
                        
                        Spacer()
                            .frame(height: 4)
                        
                        HStack {
                            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                                Text("딥러닝")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                                            .weight(Constants.fontWeightSemibold)
                                    )
                                    .foregroundColor(Constants.GrayColorGray500)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Constants.GrayColorGray100)
                            .cornerRadius(6)
                            
                            Spacer()
                                .frame(width: 4)
                            
                            Text("GPT와 LLM의 관계")
                                .font(
                                    Font.custom("Pretendard", size: Constants.fontSizeS)
                                        .weight(Constants.fontWeightSemibold)
                                )
                                .foregroundColor(Constants.GrayColorGray700)
                        }
                        
                        Spacer()
                            .frame(height: 6)
                        
                        Text("서울대학교 홍길동 교수의 논문을 바로 확인해 보세요!")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(Constants.GrayColorGray400)
                    }
                }
                .padding(.leading, 16)
                
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
    }
}

#Preview {
    NotificationView(path: .constant([]))
}
