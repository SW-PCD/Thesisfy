//
//  LogoutViewController.swift
//  Thesisfy
//
//  Created by 황필호 on 11/4/24.
//

import SwiftUI

struct LogoutViewController: View {
    var body: some View {
        ZStack{
            Rectangle()
              .foregroundColor(.clear)
              .frame(maxWidth: .infinity)
              .frame(maxHeight: .infinity)
              .background(Constants.etcScrim)
            
            VStack{
                logoutSetTopView()
                    .edgesIgnoringSafeArea(.top) // SafeArea에 딱 붙이기
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 430, height: 1)
                  .background(Constants.BorderColorBorder1)
            }
        }
        
    }
}

#Preview {
    LogoutViewController()
}

struct logoutSetTopView: View {
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
            
            Image("icon")
              .frame(width: 48, height: 48)
              .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Constants.GrayColorWhite)
    }
}
