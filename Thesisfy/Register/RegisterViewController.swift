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
                    
                    NavigationLink(destination: TermsAgreementViewController()) {
                        NextButtonView()
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
