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
<<<<<<< HEAD
        NavigationStack(path: $path) {
<<<<<<< HEAD
=======
        NavigationStack(path: $path) { // NavigationStack 추가
>>>>>>> 216cbf1 (Resolve Conflice by Search)
=======
        NavigationStack(path: $path) {
>>>>>>> ab9b96a (Update Search)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    SearchFieldView(path: $path)
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                    
<<<<<<< HEAD
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
=======
                    PaperListView(path: $path, isExpanded: $isExpanded)  // isExpanded 전달
>>>>>>> ab9b96a (Update Search)
                    
                    Spacer(minLength: 12)
                }
>>>>>>> 216cbf1 (Resolve Conflice by Search)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white.ignoresSafeArea())
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
=======
// MARK: - SearchFieldView
struct SearchFieldView: View {
    @Binding var path: [Route]
    @State private var inputSearch: String = ""
>>>>>>> ab9b96a (Update Search)
    
    var body: some View {
        HStack {
            TextField("검색어 입력", text: $inputSearch)
                .font(.custom("Pretendard", size: Constants.fontSizeS))
                .fontWeight(Constants.fontWeightMedium)
                .foregroundColor(Constants.GrayColorGray900)
                .padding(.leading, 12)
            
            Spacer()
<<<<<<< HEAD
>>>>>>> 216cbf1 (Resolve Conflice by Search)
=======
            
            Image("search")
                .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                .padding(.trailing, 12)
>>>>>>> ab9b96a (Update Search)
        }
        .padding(.horizontal, Constants.fontSizeXs)
        .padding(.vertical, Constants.fontSizeS)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Constants.GrayColorGray50)
        .cornerRadius(6)
    }
}

// MARK: - PaperListView
struct PaperListView: View {
<<<<<<< HEAD
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
=======
    @Binding var path: [Route]
    @Binding var isExpanded: Bool
    let totalPapers = 20
    let papersToShowInitially = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 제목과 검색 결과 개수
            HStack {
>>>>>>> ab9b96a (Update Search)
                Text("인공지능 검색결과")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightMedium))
                    .foregroundColor(Constants.GrayColorGray800)
                
                Text("\(totalPapers)건")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightSemibold))
                    .foregroundColor(Constants.PrimaryColorPrimary600)
            }
            
<<<<<<< HEAD
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
=======
            ScrollView(showsIndicators: false) {
>>>>>>> ab9b96a (Update Search)
                VStack(spacing: 8) {
                    // 확장 여부에 따라 표시할 논문 개수 조정
                    let papersToShow = isExpanded ? totalPapers : papersToShowInitially
                    ForEach(0..<papersToShow, id: \.self) { _ in
                        PaperRowView(path: $path)
                    }
                    
                    if !isExpanded {  // 확장되지 않은 상태에서만 버튼 표시
                        ShowMoreButton(isExpanded: $isExpanded)
                            .padding(.top, 16)
                    }
                }
            }
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
            .frame(maxHeight: isExpanded ? .infinity : CGFloat(papersToShowInitially * 120)) // 높이 조정
=======
            .frame(maxHeight: isExpanded ? .infinity : CGFloat(papersToShowInitially * 120)) // 확장 여부에 따라 높이 조정
>>>>>>> 49dd072 (Merge Login & Register API)
            .animation(.easeInOut, value: isExpanded)
=======
>>>>>>> 216cbf1 (Resolve Conflice by Search)
=======
            .frame(maxHeight: isExpanded ? .infinity : CGFloat(papersToShowInitially * 120)) // 높이 조정
            .animation(.easeInOut, value: isExpanded)
>>>>>>> ab9b96a (Update Search)
        }
    }
}

// MARK: - PaperRowView
struct PaperRowView: View {
    @Binding var path: [Route]
    
    var body: some View {
        Button(action: {
            path.append(.thesisView)
        }) {
            HStack(spacing: 12) {
                Image("SNU")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Constants.BorderColorBorder1, lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("인공지능과 딥러닝")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeS).weight(Constants.fontWeightSemibold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Text("서울대학교 인공지능학부")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeXxs).weight(Constants.fontWeightMedium))
                        .foregroundColor(Constants.GrayColorGray800)
                    
                    Text("홍길동 학생")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeXxs).weight(Constants.fontWeightRegular))
                        .foregroundColor(Constants.GrayColorGray600)
                }
                
                Spacer()
            }
            .padding()
            .background(Constants.GrayColorGray50)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Constants.BorderColorBorder1, lineWidth: 1))
        }
    }
}

// MARK: - ShowMoreButton
struct ShowMoreButton: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button(action: {
            isExpanded.toggle()
        }) {
            HStack {
                Text("논문 정보 더보기")
                    .font(Font.custom("Pretendard", size: Constants.fontSizeXs).weight(Constants.fontWeightMedium))
                    .foregroundColor(Constants.GrayColorGray600)
                
                Image("downArrow")
                    .resizable()
                    .frame(width: 12, height: 12)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Constants.GrayColorWhite)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Constants.BorderColorBorder1, lineWidth: 1))
        }
    }
}

#Preview {
    PaperSearchView()
}
