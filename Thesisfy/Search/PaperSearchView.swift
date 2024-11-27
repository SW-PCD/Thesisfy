//
//  PaperSearchView.swift
//  Thesisfy
//
//  Created by 황필호 on 11/8/24.
//

import SwiftUI

struct PaperSearchView: View {
    @State private var isExpanded = false  // 리스트 확장 여부를 저장하는 상태 변수
    @State private var path: [Route] = []  // NavigationStack 경로
    
    var body: some View {
<<<<<<< HEAD
        NavigationStack(path: $path) {
<<<<<<< HEAD
=======
        NavigationStack(path: $path) { // NavigationStack 추가
>>>>>>> 216cbf1 (Resolve Conflice by Search)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    SearchFieldView(path: $path)
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                    
<<<<<<< HEAD
                    PaperListView(path: $path, isExpanded: $isExpanded)  // isExpanded 전달
                    
                    Spacer(minLength: 12)
                }
=======
            VStack(spacing: 0) {
                SearchFieldView(path: $path)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                
                PaperListView(path: $path, isExpanded: $isExpanded)
                
                Spacer(minLength: 12)
>>>>>>> 49dd072 (Merge Login & Register API)
=======
                    PaperListView(path: $path, isExpanded: isExpanded)  // 상태 변수를 전달
                    
                    Spacer()
                        .frame(height: 32)
                    
                    if !isExpanded {  // 리스트가 확장되지 않았을 때만 버튼 표시
                        ShowMoreButton(isExpanded: $isExpanded)
                            .padding(.top, 16)
                    } else {
                        // 버튼이 없어도 같은 높이를 유지하기 위해 빈 공간 추가
                        Color.clear
                            .frame(height: 52)  // ShowMoreButton과 동일한 높이 설정
                    }
                    
                    Spacer(minLength: 12)  // 화면 하단에 일정한 여백 확보
                }
>>>>>>> 216cbf1 (Resolve Conflice by Search)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)  // 전체 화면을 채우되 위쪽 정렬
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .searchView:
                    SearchView()
                case .thesisView:
                    ThesisView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

<<<<<<< HEAD
// MARK: - SearchFieldView
struct SearchFieldView: View {
    @Binding var path: [Route]
<<<<<<< HEAD
    @State private var inputSearch: String = ""
=======
>>>>>>> 49dd072 (Merge Login & Register API)
    
    var body: some View {
        HStack {
            TextField("검색어 입력", text: $inputSearch)
                .font(.custom("Pretendard", size: Constants.fontSizeS))
                .fontWeight(Constants.fontWeightMedium)
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.leading, 12)
            
            Spacer()
            
            Image("search")
                .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                .padding(.trailing, 12)
=======
struct SearchFieldView:View {
    @Binding var path: [Route] // NavigationStack 경로
    @State var inputSearch: String = ""
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                
                TextField("검색어 입력", text: $inputSearch)
                    .font(.custom("Pretendard", size: Constants.fontSizeS))
                    .fontWeight(Constants.fontWeightMedium)
                    .foregroundColor(Constants.GrayColorGray900)
                    .padding(.leading, 12)
                
                
                Spacer()
                
                Image("search")
                    .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                    .padding(.trailing, 12)
            }
            Spacer()
>>>>>>> 216cbf1 (Resolve Conflice by Search)
        }
        .padding(.horizontal, Constants.fontSizeXs)
        .padding(.vertical, Constants.fontSizeS)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Constants.GrayColorGray50)
        .cornerRadius(6)
    }
}

struct PaperListView: View {
<<<<<<< HEAD
    @Binding var path: [Route]
    @Binding var isExpanded: Bool
    let totalPapers = 20
<<<<<<< HEAD
    let papersToShowInitially = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 제목과 검색 결과 개수
=======
    let papersToShowInitially = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 제목과 논문 개수
>>>>>>> 49dd072 (Merge Login & Register API)
            HStack {
=======
    @Binding var path: [Route]  // NavigationStack 경로
    
    let isExpanded: Bool  // 리스트 확장 여부를 받아옴
    let totalPapers = 20  // 예시 데이터 총 개수
    let papersToShowInitially = 5  // 초기 표시 개수
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
>>>>>>> 216cbf1 (Resolve Conflice by Search)
                Text("인공지능 검색결과")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeS)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray800)
                
                Text("\(totalPapers)건")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeS)
                            .weight(Constants.fontWeightSemibold)
                    )
                    .foregroundColor(Constants.PrimaryColorPrimary600)
            }
            
<<<<<<< HEAD
<<<<<<< HEAD
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
=======
            // 논문 리스트
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
>>>>>>> 49dd072 (Merge Login & Register API)
                    // 확장 여부에 따라 표시할 논문 개수 조정
                    let papersToShow = isExpanded ? totalPapers : papersToShowInitially
                    ForEach(0..<papersToShow, id: \.self) { _ in
                        PaperRowView(path: $path)
                    }
                    
<<<<<<< HEAD
                    if !isExpanded {  // 확장되지 않은 상태에서만 버튼 표시
=======
                    // 논문 정보 더보기 버튼
                    if !isExpanded {
>>>>>>> 49dd072 (Merge Login & Register API)
                        ShowMoreButton(isExpanded: $isExpanded)
                            .padding(.top, 16)
=======
            // 버튼이 있을 때와 없을 때의 간격을 동일하게 유지
            .padding(.bottom, isExpanded ? 12 : 28)  // 확장 여부에 따라 간격 조정
            
            if isExpanded {
                // 확장된 상태에서는 ScrollView로 모든 논문 표시
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(0..<totalPapers, id: \.self) { _ in
                            PaperRowView(path: $path)
                            
                        }
>>>>>>> 216cbf1 (Resolve Conflice by Search)
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height - 100)  // 확장 시 탭바 높이 고려
            } else {
                // 확장되지 않은 상태에서는 ScrollView 없이 5개의 논문만 표시
                VStack(spacing: 8) {
                    ForEach(0..<papersToShowInitially, id: \.self) { _ in
                        PaperRowView(path: $path)
                    }
                }
                .frame(maxHeight: CGFloat(5 * 100))  // 초기 5개의 논문만 표시
            }
<<<<<<< HEAD
<<<<<<< HEAD
            .frame(maxHeight: isExpanded ? .infinity : CGFloat(papersToShowInitially * 120)) // 높이 조정
=======
            .frame(maxHeight: isExpanded ? .infinity : CGFloat(papersToShowInitially * 120)) // 확장 여부에 따라 높이 조정
>>>>>>> 49dd072 (Merge Login & Register API)
            .animation(.easeInOut, value: isExpanded)
=======
>>>>>>> 216cbf1 (Resolve Conflice by Search)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)  // 상단 정렬
        .background(Color.white)  // 배경색 설정
    }
}

// PaperRowView로 리스트의 각 항목을 분리하여 깔끔하게 유지
struct PaperRowView: View {
    @Binding var path: [Route]  // NavigationStack 경로
    
    var body: some View {
        Button(action: {
            path.append(.thesisView) // 버튼 클릭 시 `thesisView`로 이동
        }) {
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

struct ShowMoreButton: View {
    @Binding var isExpanded: Bool  // 버튼에서 확장 여부를 변경할 수 있도록 바인딩 변수로 설정
    
    var body: some View {
        Button(action: {
            isExpanded.toggle()  // 버튼을 누를 때 확장 여부 토글
        }) {
            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                Text("논문 정보 더보기")  // 상태와 상관없이 동일한 텍스트 사용
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.GrayColorGray600)
                
                Image("downArrow")
                    .frame(width: Constants.fontSizeXs, height: Constants.fontSizeXs)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(width: 140)
            .frame(height: 36)
            .background(Constants.GrayColorWhite)
            .cornerRadius(999)
            .overlay(
                RoundedRectangle(cornerRadius: 999)
                    .inset(by: 0.5)
                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
            )
        }
    }
}

#Preview {
    PaperSearchView()
}
