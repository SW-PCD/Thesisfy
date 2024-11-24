import SwiftUI

struct ProfileManagementView: View {
    @State private var currentTab: Int = 0 // 선택된 탭 인덱스를 관리할 변수 추가
    @State private var selectedJob: String? = nil // 선택된 직업 상태 변수 추가
    @State private var nickname: String = "홍길동" // 닉네임 초기값
    
    @State private var isProfileModified: Bool = false // 회원 정보 수정 여부 상태 변수
    @State private var isPasswordModified: Bool = false // 비밀번호 변경 여부 상태 변수
    
    var body: some View {
        VStack {
            ProfileManagementTopView()
            
            TabBarView(currentTab: $currentTab) // 바인딩으로 전달
            
            Spacer()
                .frame(height: 24)
            
            if currentTab == 0 {
                EditProfileView(
                    selectedJob: $selectedJob,
                    nickname: $nickname,
                    isProfileModified: $isProfileModified
                ) // 선택된 직업과 닉네임 전달
            } else if currentTab == 1 {
                EditpasswordView(isPasswordModified: $isPasswordModified)
            }
            
            Spacer()
            
            // 버튼 색상은 현재 탭의 수정 여부 상태 변수에 따라 다르게 표시
            EditProfileButton(
                isModified: currentTab == 0 ? isProfileModified : isPasswordModified
            ) {
                // 버튼 클릭 시 동작을 각 탭에 맞춰 추가할 수 있습니다
                if currentTab == 0 {
                    print("회원 정보 수정 버튼 클릭됨")
                } else {
                    print("비밀번호 변경 버튼 클릭됨")
                }
            }
            .navigationBarBackButtonHidden(true) // 백 버튼 숨기기
        }
    }
    
    struct ProfileManagementTopView: View {
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
                
                Text("프로필 편집")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXl)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 0)
            .background(Constants.GrayColorWhite)
        }
    }
    
    struct TabBarView: View {
        @Binding var currentTab: Int
        @Namespace var namespace //애니메이션
        var tabBarOptions: [String] = ["회원정보 수정", "비밀번호 변경"]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tabBarOptions.indices, id: \.self) { index in
                        let title = tabBarOptions[index]
                        TabBarItem(currentTab: $currentTab,
                                   namespace: namespace,
                                   title: title,
                                   tab: index)
                    }
                }
                .padding(.leading, 24)
            }
            .background(Color.white)
            .frame(height: 40)
        }
    }
    
    struct TabBarItem: View {
        @Binding var currentTab: Int
        let namespace: Namespace.ID
        
        var title: String
        var tab: Int
        
        var body: some View {
            Button {
                currentTab = tab
            } label: {
                VStack {
                    Text(title)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(currentTab == tab ? Constants.PrimaryColorPrimary600 : Constants.GrayColorGray500)
                    if currentTab == tab {
                        Color(Constants.PrimaryColorPrimary600)
                            .frame(height: 2)
                            .matchedGeometryEffect(id: "underline", in: namespace.self)
                    } else {
                        Color.clear.frame(height: 2)
                    }
                }
                .animation(.spring(), value: currentTab)
            }
            .buttonStyle(.plain)
        }
    }
    
    struct EditProfileView: View {
        @Binding var selectedJob: String? // 선택된 직업 변수 바인딩
        @Binding var nickname: String
        @Binding var isProfileModified: Bool
        
        var body: some View {
            VStack(spacing: 28) {
                EditEmailView()
                EditNickNameView(nickname: $nickname, isProfileModified: $isProfileModified)
                
                // EditJobView에 드롭다운 포함
                EditJobView(selectedJob: $selectedJob, isProfileModified: $isProfileModified)
            }
            .padding(.horizontal, 24)
        }
    }
    
    struct EditEmailView: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("이메일")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                Spacer()
                    .frame(height: 8)
                
                HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                    Text("hong@hansung.ac.kr")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray400)
                }
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeS)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Constants.GrayColorGray100)
                .cornerRadius(6)
                
                Text("이메일은 변경이 불가합니다")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXxxs)
                            .weight(Constants.fontWeightRegular)
                    )
                    .foregroundColor(Constants.GrayColorGray700)
            }
        }
    }
    
    struct EditNickNameView: View {
        @Binding var nickname: String
        @Binding var isProfileModified: Bool// 닉네임 변경 여부 상태 변수
        @State private var isNicknameChanged: Bool = false // 닉네임 변경 여부 상태 변수
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("닉네임")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                HStack {
                    // 닉네임 입력 필드
                    HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                        TextField("닉네임을 입력하세요", text: $nickname, onEditingChanged: { _ in
                            // 텍스트 필드의 입력값이 변경되면 상태를 업데이트
                            isNicknameChanged = !nickname.isEmpty // 닉네임이 비어있지 않으면 색상 활성화
                            isProfileModified = true
                        })
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    }
                    .padding(.horizontal, Constants.fontSizeXs)
                    .padding(.vertical, Constants.fontSizeS)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Constants.GrayColorWhite)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .inset(by: 0.5)
                            .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                    )
                    
                    Spacer()
                        .frame(width: 6)
                    
                    // 중복 확인 버튼
                    Button(action: {
                        // 중복 확인 버튼을 누를 때 수행할 작업 추가
                    }) {
                        Text("중복 확인")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeS)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(isNicknameChanged ? .white : Constants.GrayColorGray400)
                    }
                    .padding(.horizontal, Constants.fontSizeXs)
                    .padding(.vertical, Constants.fontSizeM)
                    .frame(width: 80, height: 45, alignment: .center)
                    .background(isNicknameChanged ? Constants.PrimaryColorPrimary500 : Constants.GrayColorGray100)
                    .cornerRadius(8)
                    .animation(.easeInOut(duration: 0.2), value: isNicknameChanged) // 색상 변화 애니메이션 추가
                }
            }
        }
    }
    
    struct EditJobView: View {
        @Binding var selectedJob: String? // 선택된 직업 변수 바인딩
        @Binding var isProfileModified: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("직업")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                // 드롭다운 선택 추가
                JobDropDownPicker(
                    selection: $selectedJob,
                    options: ["대학생", "대학원생", "교수", "교직원", "학생", "기타"],
                    onSelectionChanged: { _ in
                        isProfileModified = true
                    }
                )
            }
        }
    }
    
    struct DropDownItemView: View {
        @State var selection1: String? = nil
        
        var body: some View {
            JobDropDownPicker(
                selection: $selection1,
                options: [
                    "대학생",
                    "대학원생",
                    "교수",
                    "교직원",
                    "학생",
                    "기타"
                ],
                onSelectionChanged: { _ in
                    // 선택 변경 시 수행할 작업 추가 가능
                }
            )
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
                // 상단 선택된 항목 표시 뷰
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
                        .stroke(showDropdown ? Constants.PrimaryColorPrimary600 : Constants.BorderColorBorder2, lineWidth: 1) // 보더 색상 변경
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
                        .padding(.top, 4) // 상단 선택 영역과 옵션 리스트 사이의 간격
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
                        Divider() // 옵션 간 구분선
                    }
                }
            }
        }
    }
    
    struct EditpasswordView: View {
        @Binding var isPasswordModified: Bool
        @State private var newPassword: String = "" // newPassword를 상태 변수로 추가합니다.
        
        var body: some View {
            VStack(spacing: 28) {
                CurrentPassword(isModified: $isPasswordModified)
                
                NewPassWord(isModified: $isPasswordModified, newPassword: $newPassword) // NewPassWord에 newPassword 바인딩 전달 //@@@@@
                
                CheckNewPassWord(isModified: $isPasswordModified, newPassword: $newPassword) // CheckNewPassWord에 newPassword 바인딩 전달 //@@@@@
            }
            .padding(.horizontal, 24)
        }
    }
    
    struct CurrentPassword: View {
        @Binding var isModified: Bool
        @State private var currentPassword: String = "" // 비밀번호 상태 변수 추가
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("현재 비밀번호")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                // SecureField의 text 바인딩을 통해 실시간으로 상태 업데이트
                SecureField("현재 비밀번호를 입력해 주세요", text: Binding(
                    get: { currentPassword },
                    set: { newValue in
                        currentPassword = newValue
                        isModified = !currentPassword.isEmpty // 비밀번호가 입력되면 버튼 활성화
                    }
                ))
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeS)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeS)
                .frame(maxWidth: .infinity, alignment: .leading)
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
    
    struct NewPassWord: View {
        @Binding var isModified: Bool
        @Binding var newPassword: String // newPassword 바인딩 추가
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("새로운 비밀번호")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                // SecureField의 text 바인딩을 통해 실시간으로 상태 업데이트
                SecureField("새로운 비밀번호를 입력해 주세요", text: Binding(
                    get: { newPassword },
                    set: { newValue in
                        newPassword = newValue
                        isModified = !newPassword.isEmpty // 비밀번호가 입력되면 버튼 활성화
                    }
                ))
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeS)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeS)
                .frame(maxWidth: .infinity, alignment: .leading)
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
    
    struct CheckNewPassWord: View {
        @Binding var isModified: Bool
        @State private var checkNewPassword: String = "" // 비밀번호 상태 변수 추가
        @Binding var newPassword: String // 새로운 비밀번호를 받아 비교
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("새로운 비밀번호 확인")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.GrayColorGray900)
                
                // SecureField의 text 바인딩을 통해 실시간으로 상태 업데이트
                SecureField("새로운 비밀번호를 한번 더 입력해 주세요", text: Binding(
                    get: { checkNewPassword },
                    set: { newValue in
                        checkNewPassword = newValue
                        isModified = !checkNewPassword.isEmpty // 비밀번호가 입력되면 버튼 활성화
                    }
                ))
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeS)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeS)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Constants.GrayColorWhite)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .inset(by: 0.5)
                        .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                )
                
                // "비밀번호가 일치하지 않습니다" 메시지 표시 조건 추가
                if !checkNewPassword.isEmpty && checkNewPassword != newPassword {
                    Text("비밀번호가 일치하지 않습니다.")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Color.red)
                        .padding(.top, Constants.fontSizeXs)
                }
            }
        }
    }
    
    struct EditProfileButton: View {
        var isModified: Bool
        var action: () -> Void // 버튼을 눌렀을 때 실행할 클로저
        
        var body: some View {
            Button(action: {
                action() // 버튼 액션 호출
            }) {
                HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                    Text("회원정보 수정하기")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightBold)
                        )
                        .foregroundColor(isModified ? .white : Constants.GrayColorGray400)
                }
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeM)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 51)
                .background(isModified ? Constants.PrimaryColorPrimary600 : Constants.GrayColorGray100)
                .cornerRadius(8)
                .padding(.bottom, 45)
                .padding(.horizontal, 24)
            }
            .disabled(!isModified) // 수정되지 않은 경우 버튼 비활성화
        }
    }
}

#Preview {
    ProfileManagementView()
}
