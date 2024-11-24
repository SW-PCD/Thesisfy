//
//  MainView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/20/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        setTopView()
        
        Spacer()
            .frame(height: 16)
        
        Divider()
        
        Spacer()
            .frame(height: 24)
        
        ScrollView {
            thesisBeingWrittenView()
            
            Spacer()
                .frame(height: 57)
            
            completedThesisView()
        }
    }
}

struct setTopView: View {
    var body: some View {
        HStack {
            Spacer()
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 28, height: 28)
                .background(
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 28, height: 28)
                        .clipped()
                )
            
            Spacer()
            
            Image("icon")
                .frame(width: 48, height: 48)
        }
        .padding(.horizontal, 16);
    }
}

struct thesisBeingWrittenView: View {
    @State var progress : Double = 0.3
    @State private var isEditing: Bool = false // 편집 모드 상태 변수
    
    var body: some View {
        VStack {
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
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(isEditing ? .blue : Constants.GrayColorGray400)
                }
            }
            
            VStack(spacing: 8) {
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
                            HStack {
                                Text("인공지능과 딥러닝")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeS)
                                            .weight(Constants.fontWeightSemibold)
                                    )
                                    .foregroundColor(Constants.GrayColorGray900)
                                
                                Spacer()
                                
                                if isEditing {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            }
                            
                            HStack {
                                Text("기간")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                            .weight(Constants.fontWeightSemibold)
                                    )
                                    .foregroundColor(Constants.GrayColorGray800)
                                
                                Text("2025년 12월 6일")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                            .weight(Constants.fontWeightMedium)
                                    )
                                    .foregroundColor(Constants.GrayColorGray600)
                                
                                Text("까지")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                            .weight(Constants.fontWeightSemibold)
                                    )
                                    .foregroundColor(Constants.GrayColorGray800)
                            }
                            .padding(.top, 2)
                            
                            Spacer()
                                .frame(height: 8)
                            
                            VStack(alignment: .leading) {
                                Text("진행률")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                            .weight(Constants.fontWeightSemibold)
                                    )
                                    .foregroundColor(Constants.GrayColorGray800)
                                
                                HStack {
                                    ProgressView(value: progress)
                                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                                                .frame(width: 105)
                                                .padding(.top, 0)
                                    
                                    Text("30%")
                                        .font(
                                            Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                                .weight(Constants.fontWeightSemibold)
                                        )
                                        .foregroundColor(Constants.GrayColorGray800)
                                }
                            }
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
        .padding(.horizontal, 24)
    }
}

struct completedThesisView : View {
    var body: some View {
        VStack {
            HStack {
                Text("작성 완료된 논문")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
                
                Text("편집")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXxs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Constants.GrayColorGray400)
            }
            
            VStack(spacing: 8) {
                ForEach(0..<3) { _ in
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
        .padding(.horizontal, 24)
    }
}

#Preview {
    MainView()
}
