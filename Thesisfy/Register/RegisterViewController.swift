//
//  RegisterViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/20/24.
//

import SwiftUI

// MARK: - UserDefaults로 구현한 회원가입
//struct RegisterViewController: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//    @State private var nickname: String = ""
//    @State private var selectedJob: String = "대학생"
//    @State private var navigateToTerms = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    
//    var isRegisterEnabled: Bool {
//        // 모든 필드가 비어 있지 않고, 비밀번호와 확인 비밀번호가 일치할 경우
//        !email.isEmpty && !password.isEmpty && password == confirmPassword && !nickname.isEmpty
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Navigation Bar
//                HStack {
//                    Button {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Image(systemName: "chevron.left")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.black)
//                    }
//                    
//                    Spacer()
//                    
//                    Text("회원가입")
//                        .font(.system(size: Constants.fontSizeXl, weight: Constants.fontWeightSemibold))
//                        .foregroundColor(Constants.GrayColorGray900)
//                    
//                    Spacer()
//                    
//                    Image("") // 오른쪽 여백 균형을 맞추기 위해 사용
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                }
//                .padding(.horizontal, 24)
//
//                ScrollView(showsIndicators: false) {
//                    // Input Fields
//                    SetEmailView(email: $email)
//                        .padding(.top, 24)
//                    
//                    SetPasswordView(password: $password)
//                        .padding(.top, 28)
//                    
//                    SetPasswordConfirmView(password: $confirmPassword)
//                        .padding(.top, 28)
//                    
//                    SetNickNameView(nickname: $nickname)
//                        .padding(.top, 28)
//                    
//                    SetJobView()
//                        .padding(.top, 28)
//                    
//                    // Next button
//                    NavigationLink(destination: TermsAgreementViewController(), isActive: $navigateToTerms) {
//                        EmptyView()
//                    }
//                    
//                    NextButtonView()
//                        .onTapGesture {
//                            if isRegisterEnabled {
//                                registerUser()
//                            } else {
//                                alertMessage = "모든 필드를 올바르게 입력해 주세요."
//                                showAlert = true
//                            }
//                        }
//                }
//                .padding(.horizontal, 24)
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//    
//    // MARK: - 회원가입 로직
//    private func registerUser() {
//        // UserDefaults에 데이터 저장
//        UserDefaults.standard.set(email, forKey: "email")
//        UserDefaults.standard.set(password, forKey: "password")
//        UserDefaults.standard.set(nickname, forKey: "nickname")
//        UserDefaults.standard.set(selectedJob, forKey: "job")
//        
//        alertMessage = "회원가입이 완료되었습니다!"
//        showAlert = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            navigateToTerms = true
//        }
//    }
//}
//
//
//struct SetPasswordConfirmView: View {
//    @Binding var password: String
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            HStack {
//                Text("비밀번호 확인")
//                    .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
//                Spacer()
//            }
//            
//            SecureField("비밀번호를 한 번 더 입력해 주세요", text: $password)
//                .padding(.horizontal, Constants.fontSizeXs)
//                .padding(.vertical, Constants.fontSizeS)
//                .frame(height: 44)
//                .background(Constants.GrayColorWhite)
//                .cornerRadius(6)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 6)
//                        .stroke(Constants.BorderColorBorder2, lineWidth: 1)
//                )
//        }
//    }
//}
//
//struct SetNickNameView: View {
//    @Binding var nickname: String
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            HStack {
//                Text("닉네임")
//                    .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
//                Spacer()
//            }
//            
//            TextField("닉네임을 입력해 주세요", text: $nickname)
//                .padding(.horizontal, Constants.fontSizeXs)
//                .padding(.vertical, Constants.fontSizeS)
//                .frame(height: 44)
//                .background(Constants.GrayColorWhite)
//                .cornerRadius(6)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 6)
//                        .stroke(Constants.BorderColorBorder2, lineWidth: 1)
//                )
//        }
//    }
//}
//
//struct SetJobView: View {
//    @State private var selectedJob: String? = "대학생" // 선택된 직업 상태 변수
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("직업")
//                .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
//                .foregroundColor(Constants.GrayColorGray900)
//            
//            // JobDropDownPicker 재사용
//            JobDropDownPicker(
//                selection: $selectedJob,
//                options: ["대학생", "대학원생", "교수", "교직원", "학생", "기타"],
//                onSelectionChanged: { selected in
//                    print("선택된 직업: \(selected ?? "없음")") // 선택 시 작업 수행
//                }
//            )
//            .background(Constants.GrayColorWhite)
//            .cornerRadius(6)
//        }
//        .padding(.vertical, 16)
//    }
//}
//
//struct JobDropDownPicker: View {
//    @Binding var selection: String?
//    var options: [String]
//    var maxWidth: CGFloat = .infinity
//    var onSelectionChanged: (String?) -> Void
//
//    @State private var showDropdown = false
//    @SceneStorage("drop_down_zindex") private var index = 1000.0
//    @State private var zindex = 1000.0
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // 상단 선택된 항목 표시
//            HStack {
//                Text(selection ?? "대학생")
//                    .font(
//                        Font.custom("Pretendard", size: Constants.fontSizeS)
//                            .weight(Constants.fontWeightMedium)
//                    )
//                    .foregroundColor(Constants.GrayColorGray900)
//
//                Spacer()
//
//                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
//                    .font(.title3)
//                    .foregroundColor(showDropdown ? Constants.PrimaryColorPrimary600 : .gray)
//            }
//            .padding(.horizontal, Constants.fontSizeXs)
//            .padding(.vertical, Constants.fontSizeS)
//            .frame(maxWidth: maxWidth, minHeight: 50)
//            .background(Constants.GrayColorWhite)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
//                    showDropdown.toggle()
//                }
//            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 6)
//                    .inset(by: 0.5)
//                    .stroke(showDropdown ? Constants.PrimaryColorPrimary600 : Constants.BorderColorBorder2, lineWidth: 1)
//            )
//            .cornerRadius(6)
//
//            // 옵션 리스트
//            if showDropdown {
//                OptionsView()
//                    .frame(maxWidth: maxWidth)
//                    .background(Color.white)
//                    .cornerRadius(6)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 6)
//                            .inset(by: 0.5)
//                            .stroke(Constants.BorderColorBorder2, lineWidth: 1)
//                    )
//                    .transition(.asymmetric(
//                        insertion: .opacity.combined(with: .scale(scale: 1.0, anchor: .top)),
//                        removal: .opacity.combined(with: .scale(scale: 0.9, anchor: .top))
//                    ))
//                    .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: showDropdown)
//                    .padding(.top, 4)
//            }
//        }
//        .zIndex(zindex)
//    }
//
//    func OptionsView() -> some View {
//        VStack(spacing: 0) {
//            ForEach(options, id: \.self) { option in
//                HStack {
//                    Text(option)
//                        .font(
//                            Font.custom("Pretendard", size: Constants.fontSizeS)
//                                .weight(Constants.fontWeightMedium)
//                        )
//                        .foregroundColor(Constants.GrayColorGray900)
//
//                    Spacer()
//                }
//                .padding(.horizontal, 15)
//                .padding(.vertical, 10)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    selection = option
//                    onSelectionChanged(option)
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
//                        showDropdown.toggle()
//                    }
//                }
//
//                if option != options.last {
//                    Divider()
//                }
//            }
//        }
//    }
//}



//// MARK: - ZStack으로 드롭다운 메뉴 구현 해보기
//struct SetJobView: View {
//    @State private var selectedJob: String? = "대학생" // 선택된 직업 상태 변수
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("직업")
//                .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
//                .foregroundColor(Constants.GrayColorGray900)
//
//            // JobDropDownPicker 재사용
//            JobDropDownPicker(
//                selection: $selectedJob,
//                options: ["대학생", "대학원생", "교수", "교직원", "학생", "기타"],
//                onSelectionChanged: { selected in
//                    print("선택된 직업: \(selected ?? "없음")") // 선택 시 작업 수행
//                }
//            )
//            .background(Constants.GrayColorWhite)
//            .cornerRadius(6)
//        }
//        .padding(.vertical, 16)
//    }
//}
//
//struct JobDropDownPicker: View {
//    @Binding var selection: String?
//    var options: [String]
//    var maxWidth: CGFloat = .infinity
//    var onSelectionChanged: (String?) -> Void
//
//    @State private var showDropdown = false
//    @SceneStorage("drop_down_zindex") private var index = 1000.0
//    @State private var zindex = 1000.0
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // 상단 선택된 항목 표시
//            HStack {
//                Text(selection ?? "대학생")
//                    .font(
//                        Font.custom("Pretendard", size: Constants.fontSizeS)
//                            .weight(Constants.fontWeightMedium)
//                    )
//                    .foregroundColor(Constants.GrayColorGray900)
//
//                Spacer()
//
//                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
//                    .font(.title3)
//                    .foregroundColor(showDropdown ? Constants.PrimaryColorPrimary600 : .gray)
//            }
//            .padding(.horizontal, Constants.fontSizeXs)
//            .padding(.vertical, Constants.fontSizeS)
//            .frame(maxWidth: maxWidth, minHeight: 50)
//            .background(Constants.GrayColorWhite)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
//                    showDropdown.toggle()
//                }
//            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 6)
//                    .inset(by: 0.5)
//                    .stroke(showDropdown ? Constants.PrimaryColorPrimary600 : Constants.BorderColorBorder2, lineWidth: 1)
//            )
//            .cornerRadius(6)
//
//            // 옵션 리스트
//            if showDropdown {
//                OptionsView()
//                    .frame(maxWidth: maxWidth)
//                    .background(Color.white)
//                    .cornerRadius(6)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 6)
//                            .inset(by: 0.5)
//                            .stroke(Constants.BorderColorBorder2, lineWidth: 1)
//                    )
//                    .transition(.asymmetric(
//                        insertion: .opacity.combined(with: .scale(scale: 1.0, anchor: .top)),
//                        removal: .opacity.combined(with: .scale(scale: 0.9, anchor: .top))
//                    ))
//                    .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: showDropdown)
//                    .padding(.top, 4)
//            }
//        }
//        .zIndex(zindex)
//    }
//
//    func OptionsView() -> some View {
//        VStack(spacing: 0) {
//            ForEach(options, id: \.self) { option in
//                HStack {
//                    Text(option)
//                        .font(
//                            Font.custom("Pretendard", size: Constants.fontSizeS)
//                                .weight(Constants.fontWeightMedium)
//                        )
//                        .foregroundColor(Constants.GrayColorGray900)
//
//                    Spacer()
//                }
//                .padding(.horizontal, 15)
//                .padding(.vertical, 10)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    selection = option
//                    onSelectionChanged(option)
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
//                        showDropdown.toggle()
//                    }
//                }
//
//                if option != options.last {
//                    Divider()
//                }
//            }
//        }
//    }
//}

//struct NextButtonView: View {
//    var title: String = "다음으로" // 기본값 설정
//
//    var body: some View {
//        Text(title)
//            .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
//            .foregroundColor(Constants.GrayColorWhite)
//            .padding(.horizontal, Constants.fontSizeXs)
//            .padding(.vertical, Constants.fontSizeM)
//            .frame(maxWidth: .infinity)
//            .background(Constants.PrimaryColorPrimary500)
//            .cornerRadius(12)
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
//            )
//    }
//}

// MARK: - 회원가입 API 연동
struct RegisterViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var nickname: String = ""
    @State private var selectedJob: String = "대학생" // 기본 직업 선택
    @State private var navigateToTerms = false // 상태 변수 추가
    
    var isRegisterEnabled: Bool {
        // 모든 필드가 올바르게 입력되었는지 확인
        !email.isEmpty && !password.isEmpty && password == confirmPassword && !nickname.isEmpty
    }
    
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
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("회원가입")
                        .font(.system(size: Constants.fontSizeXl, weight: Constants.fontWeightSemibold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                    
                    Image("") // 오른쪽 여백 균형을 위해
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 24)
                
                ScrollView(showsIndicators: false) {
                    // Input Views
                    SetEmailView(email: $email)
                        .padding(.top, 24)
                    
                    SetPasswordView(password: $password)
                        .padding(.top, 28)
                    
                    SetPasswordConfirmView(password: $confirmPassword)
                        .padding(.top, 28)
                    
                    SetNickNameView(nickname: $nickname)
                        .padding(.top, 28)
                    
                    // 수정된 SetJobView 사용
                    SetJobView()
                        .padding(.top, 28)
                    
                    Spacer()
                    
                    // NavigationLink 구성
                    NavigationLink(destination: TermsAgreementViewController(), isActive: $navigateToTerms) {
                        EmptyView()
                    }
                    
                    // 다음으로 버튼
                    NextButtonView().onTapGesture {
                        if isRegisterEnabled {
                            let registerModel = Register(email: email, password: password, nickname: nickname, job: selectedJob)
                            NetworkManager.shared.registerBtnTapped(registerModel: registerModel)
                            navigateToTerms = true // 상태 변수 true로 설정
                        } else {
                            // 유효성 검사가 실패하면 처리 로직 추가
                            print("모든 필드를 올바르게 입력해주세요.")
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
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
    @State private var selectedJob: String? = "대학생" // 선택된 직업 상태 변수

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("직업")
                .font(.system(size: Constants.fontSizeL, weight: Constants.fontWeightSemibold))
                .foregroundColor(Constants.GrayColorGray900)
            
            // JobDropDownPicker 재사용
            JobDropDownPicker(
                selection: $selectedJob,
                options: ["대학생", "대학원생", "교수", "교직원", "학생", "기타"],
                onSelectionChanged: { selected in
                    print("선택된 직업: \(selected ?? "없음")") // 선택 시 작업 수행
                }
            )
            .background(Constants.GrayColorWhite)
            .cornerRadius(6)
        }
        .padding(.vertical, 16)
    }
}

struct JobDropDownPicker: View {
    @Binding var selection: String?
    var options: [String]
    var maxWidth: CGFloat = .infinity
    var onSelectionChanged: (String?) -> Void

    @State private var showDropdown = false
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zindex = 1000.0

    var body: some View {
        VStack(spacing: 0) {
            // 상단 선택된 항목 표시
            HStack {
                Text(selection ?? "대학생")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeS)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray900)

                Spacer()

                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                    .font(.title3)
                    .foregroundColor(showDropdown ? Constants.PrimaryColorPrimary600 : .gray)
            }
            .padding(.horizontal, Constants.fontSizeXs)
            .padding(.vertical, Constants.fontSizeS)
            .frame(maxWidth: maxWidth, minHeight: 50)
            .background(Constants.GrayColorWhite)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                    showDropdown.toggle()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .inset(by: 0.5)
                    .stroke(showDropdown ? Constants.PrimaryColorPrimary600 : Constants.BorderColorBorder2, lineWidth: 1)
            )
            .cornerRadius(6)

            // 옵션 리스트
            if showDropdown {
                OptionsView()
                    .frame(maxWidth: maxWidth)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .inset(by: 0.5)
                            .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                    )
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 1.0, anchor: .top)),
                        removal: .opacity.combined(with: .scale(scale: 0.9, anchor: .top))
                    ))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: showDropdown)
                    .padding(.top, 4)
            }
        }
        .zIndex(zindex)
    }

    func OptionsView() -> some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray900)

                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
                .onTapGesture {
                    selection = option
                    onSelectionChanged(option)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                        showDropdown.toggle()
                    }
                }

                if option != options.last {
                    Divider()
                }
            }
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

#Preview {
    RegisterViewController()
}
