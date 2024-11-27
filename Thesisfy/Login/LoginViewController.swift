//
//  LoginViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/20/24.
//

import SwiftUI
import Alamofire

struct LoginViewController: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var loginSuccess = false // 로그인 성공 여부 상태
    
    var isLoginEnabled: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.top, 60)
                
                SetEmailView(email: $email)
                    .padding(.top, 70)
                SetPasswordView(password: $password)
                    .padding(.top, 28)
                
                NavigationLink(destination: BaseViewController(), isActive: $loginSuccess) {
                    Button(action: {
                        loginUser()
                    }) {
                        Text("로그인")
                            .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
                            .foregroundColor(isLoginEnabled ? Constants.GrayColorWhite : Constants.GrayColorGray400)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(isLoginEnabled ? Constants.PrimaryColorPrimary500 : Constants.GrayColorGray100)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                            )
                    }
                    .disabled(!isLoginEnabled)
                }
                .padding(.top, 72)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("로그인 실패"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                }
                
                NavigationLink(destination: RegisterViewController()) {
                    HStack {
                        Text("지금 바로 계정을 만들어 보세요")
                            .font(.system(size: Constants.fontSizeXs, weight: Constants.fontWeightRegular))
                            .foregroundStyle(Constants.GrayColorGray400)
                        
                        Text("회원가입")
                            .font(.system(size: Constants.fontSizeS, weight: Constants.fontWeightRegular))
                            .foregroundStyle(Constants.GrayColorGray400)
                    }
                    .padding(.top, 36)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - 로그인 요청 함수
    private func loginUser() {
        guard isLoginEnabled else { return }
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF.request(APIConstants.loginURL, method: .post, parameters: LoginModel(email: email, password: password), encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let data):
                    alertMessage = data.message
                    if data.message.contains("성공") {
                        loginSuccess = true // 로그인 성공 시 이동 플래그 true로 설정
                        // 회원 정보 출력
                        print("회원 정보:")
                        print("ID: \(data.user.id)")
                        print("Email: \(data.user.email)")
                        print("Nickname: \(data.user.nickname)")
                        print("Job: \(data.user.job)")
                    }
                case .failure(let error):
                    alertMessage = "이메일 또는 비밀번호가 잘못되었습니다."
                    print("로그인 실패: \(error.localizedDescription)")
                }
                showAlert = !loginSuccess // 실패 시만 Alert 표시
            }
    }
}

#Preview {
    LoginViewController()
}

struct SetEmailView: View {
    @Binding var email: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("이메일")
                    .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
                
                Spacer()
            }
            
            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                TextField("이메일을 입력해 주세요", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never) // 자동 대문자 비활성화
                    .font(.system(size: Constants.fontSizeS, weight: Constants.fontWeightMedium))
                    .padding(.horizontal, Constants.fontSizeXs)
                    .padding(.vertical, Constants.fontSizeS)
                    .frame(height: 44, alignment: .leading)
                    .background(Constants.GrayColorWhite)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .inset(by: 0.5)
                            .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                    )
            }
        }
    }
}

struct SetPasswordView: View {
    @Binding var password: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("비밀번호")
                    .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
                
                Spacer()
            }
            
            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                SecureField("비밀번호를 입력해 주세요", text: $password)
                    .textInputAutocapitalization(.never) // 자동 대문자 비활성화
                    .padding(.horizontal, Constants.fontSizeXs)
                    .padding(.vertical, Constants.fontSizeS)
                    .frame(height: 44, alignment: .leading)
                    .background(Constants.GrayColorWhite)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .inset(by: 0.5)
                            .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                    )
            }
        }
    }
}

struct LoginButtonView: View {
    var isEnabled: Bool
    
    var body: some View {
        Button(action: {
            print("로그인 버튼 클릭")
        }) {
            NavigationLink(destination: BaseViewController()) {
                HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                    Text("로그인")
                        .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
                        .foregroundColor(isEnabled ? Constants.GrayColorWhite : Constants.GrayColorGray400)
                }
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeM)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(isEnabled ? Constants.PrimaryColorPrimary500 : Constants.GrayColorGray100)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                )
            }
        }
        .disabled(!isEnabled) // 버튼 비활성화 상태
    }
}
