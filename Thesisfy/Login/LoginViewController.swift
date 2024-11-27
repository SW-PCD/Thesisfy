//
//  LoginViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/20/24.
//

import SwiftUI
import Alamofire

//struct LoginViewController: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var loginSuccess = false // 로그인 성공 여부 상태
//    
//    var isLoginEnabled: Bool {
//        return !email.isEmpty && !password.isEmpty
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Image("Logo")
//                    .resizable()
//                    .frame(width: 80, height: 80)
//                    .padding(.top, 60)
//                
//                SetEmailView(email: $email)
//                    .padding(.top, 70)
//                SetPasswordView(password: $password)
//                    .padding(.top, 28)
//                
//                NavigationLink(destination: BaseViewController(), isActive: $loginSuccess) {
//                    Button(action: {
//                        loginUser()
//                    }) {
//                        Text("로그인")
//                            .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
//                            .foregroundColor(isLoginEnabled ? Constants.GrayColorWhite : Constants.GrayColorGray400)
//                            .frame(maxWidth: .infinity, minHeight: 48)
//                            .background(isLoginEnabled ? Constants.PrimaryColorPrimary500 : Constants.GrayColorGray100)
//                            .cornerRadius(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
//                            )
//                    }
//                    .disabled(!isLoginEnabled)
//                }
//                .padding(.top, 72)
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text("🥲로그인 결과"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
//                }
//                
//                NavigationLink(destination: RegisterViewController()) {
//                    HStack {
//                        Text("지금 바로 계정을 만들어 보세요")
//                            .font(.system(size: Constants.fontSizeXs, weight: Constants.fontWeightRegular))
//                            .foregroundStyle(Constants.GrayColorGray400)
//                        
//                        Text("회원가입")
//                            .font(.system(size: Constants.fontSizeS, weight: Constants.fontWeightRegular))
//                            .foregroundStyle(Constants.GrayColorGray400)
//                    }
//                    .padding(.top, 36)
//                }
//                
//                Spacer()
//            }
//            .padding(.horizontal, 24)
//        }
//    }
//    
//    // MARK: - 로컬 로그인 로직
//    private func loginUser() {
//        guard isLoginEnabled else { return }
//        
//        // UserDefaults에서 이메일-비밀번호 확인
//        let storedEmail = UserDefaults.standard.string(forKey: "email")
//        let storedPassword = UserDefaults.standard.string(forKey: "password")
//        
//        if storedEmail == email && storedPassword == password {
//            loginSuccess = true
//            alertMessage = "로그인 성공!"
//        } else {
//            loginSuccess = false
//            alertMessage = "이메일 또는 비밀번호가 잘못되었습니다."
//            showAlert = true
//        }
//    }
//}


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
                    Alert(title: Text("🥲로그인 실패"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
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

        AF.request(APIConstants.loginURL, method: .post, parameters: LoginModel(email: email, password: password), encoder: JSONParameterEncoder.default)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    print("상태 코드: \(statusCode)")
                }

                if let data = response.data, !data.isEmpty {
                    do {
                        // 서버 응답 디코딩
                        let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

                        // 상태 코드 확인
                        if response.response?.statusCode == 200 {
                            loginSuccess = true
                            alertMessage = "로그인 성공"
                            print("로그인 성공")
                        } else {
                            alertMessage = decodedResponse.message
                            showAlert = true
                            print("로그인 실패: \(decodedResponse.message)")
                        }
                    } catch {
                        // 디코딩 실패 시 응답 데이터 확인
                        let responseString = String(data: data, encoding: .utf8)
                        print("디코딩 오류: \(error.localizedDescription), 응답 데이터: \(responseString ?? "데이터 없음")")
                        alertMessage = "로그인 실패: \(responseString ?? "알 수 없는 오류")"
                        showAlert = true
                    }
                } else {
                    print("서버에서 빈 응답을 보냈습니다.")
                    alertMessage = "서버에서 데이터를 받지 못했습니다."
                    showAlert = true
                }
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
