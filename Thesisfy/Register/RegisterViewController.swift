//
//  RegisterViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/20/24.
//

import SwiftUI

struct RegisterViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var nickname: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Navigation Bar
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("회원가입")
                        .font(.system(size: Constants.fontSizeXl, weight: Constants.fontWeightSemibold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                    
                    Text("    ")
                }
                
                // Input Views
                SetEmailView(email: $email)
                    .padding(.top, 24)
                
                SetPasswordView(password: $password)
                    .padding(.top, 28)
                
                SetPasswordConfirmView(password: $confirmPassword)
                    .padding(.top, 28)
                
                SetNickNameView(nickname: $nickname)
                    .padding(.top, 28)
                
                SetJobView()
                    .padding(.top, 28)
                
                Spacer()
                
                NavigationLink(destination: TermsAgreementViewController()) {
                    NextButtonView()
                }
            }
            .padding(.horizontal, 24)
            
        }
        .navigationBarBackButtonHidden()
    }
}

struct SetPasswordConfirmView: View {
    @Binding var password: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("비밀번호 확인")
                    .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
                Spacer()
            }
            
            SecureField("비밀번호를 한 번 더 입력해 주세요", text: $password)
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeS)
                .frame(height: 44)
                .background(Constants.GrayColorWhite)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                )
        }
    }
}

struct SetNickNameView: View {
    @Binding var nickname: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("닉네임")
                    .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
                Spacer()
            }
            
            TextField("닉네임을 입력해 주세요", text: $nickname)
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeS)
                .frame(height: 44)
                .background(Constants.GrayColorWhite)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                )
        }
    }
}

// MARK: - ZStack으로 드롭다운 메뉴 구현 해보기
struct SetJobView: View {
    @State private var selectedJob = "대학생"
    let jobOptions = ["대학생", "대학원생", "교수", "교직원", "학생", "기타"]
    
    var body: some View {
        VStack {
            HStack {
                Text("직업")
                    .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
                Spacer()
            }
            
            Picker("직업을 선택해주세요", selection: $selectedJob) {
                ForEach(jobOptions, id: \.self) { job in
                    Text(job)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            .background(Constants.GrayColorWhite)
            .cornerRadius(6)
        }
    }
}

struct NextButtonView: View {
    var title: String = "다음으로" // 기본값 설정

    var body: some View {
        Text(title)
            .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
            .foregroundColor(Constants.GrayColorWhite)
            .padding(.horizontal, Constants.fontSizeXs)
            .padding(.vertical, Constants.fontSizeM)
            .frame(maxWidth: .infinity)
            .background(Constants.PrimaryColorPrimary500)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
            )
    }
}

#Preview {
    RegisterViewController()
}
