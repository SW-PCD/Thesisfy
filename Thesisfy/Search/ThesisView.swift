import SafariServices
import SwiftUI

struct ThesisView: View {
    @Environment(\.dismiss) var dismiss // dismiss 환경 변수를 선언
    @ObservedObject var viewModel = ArticleDetailViewModel()
    
    let articleId: String // 논문의 articleId
    
    var body: some View {
        VStack {
            if let articleDetail = viewModel.articleDetail {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("backArrow")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                    
                    Spacer()
                    
                    Text("논문 상세보기")
                        .font(.system(size: Constants.fontSizeXl, weight: Constants.fontWeightSemibold))
                        .foregroundStyle(Constants.GrayColorGray900)
                    
                    Spacer()
                    
                    Image("")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(.clear)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ThesisTitleView(articleDetail: articleDetail) // API 데이터 기반으로 제목, 저자, 소속 기관 등 표시
                        
                        ThesisBottomView(abstract: articleDetail.abstract) // 초록을 표시
                    }
                }
            } else if viewModel.isLoading {
                ProgressView("불러오는 중...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Constants.PrimaryColorPrimary600))
                    .padding(.top, 24)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding(.top, 24)
            }
        }
        .navigationBarBackButtonHidden(true) // Back 버튼 숨기기
        .onAppear {
            viewModel.loadArticleDetail(articleId: articleId) // 데이터 로드
        }
    }
}

struct ThesisTitleView: View {
    @State private var isBookmarked = false // 북마크 상태 변수
    @State private var showWebView = false  // 모달을 표시할 상태 변수
    let articleDetail: ArticleDetail // 전달받은 논문 상세 정보
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                        // 카테고리
                        Text(articleDetail.articleCategories)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeS)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.PrimaryColorPrimary600)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Constants.PrimaryColorPrimary50)
                    .cornerRadius(6)
                    
                    Spacer()
                        .frame(height: 11)
                    
                    // 제목
                    Text(articleDetail.title)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                        .frame(height: 6)
                    
                    HStack(spacing: 6) {
                        // 소속 기관 (예: 서울대학교)
                        Text(articleDetail.institution)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.GrayColorGray800)
                        
                        // 저자 (예: 홍길동 학생)
                        Text(articleDetail.authors)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(Constants.GrayColorGray600)
                    }
                }
                Spacer()
                
                VStack {
                    // 북마크 토글 버튼
                    Button(action: {
                        isBookmarked.toggle() // 버튼 클릭 시 상태 토글
                    }) {
                        Image(isBookmarked ? "bookMark" : "bookMarkOff") // 상태에 따라 이미지 변경
                            .frame(width: Constants.fontSizeXl, height: Constants.fontSizeXl)
                    }
                    
                    Spacer()
                }
                .padding(.top, 24)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 28)
            
            HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                Button(action: {
                    // URL을 출력하고 모달을 띄우기 위한 로직
                    print("논문 전체 보기: \(articleDetail.url)")
                    showWebView.toggle()  // 모달을 띄우기 위한 상태 변경
                }) {
                    // URL로 넘어가는 버튼 (예: "논문 전체 보기")
                    Text("논문 전체 보기")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightBold)
                        )
                        .foregroundColor(Constants.GrayColorWhite)
                        .padding(.horizontal, Constants.fontSizeXs)
                        .padding(.vertical, Constants.fontSizeM)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Constants.PrimaryColorPrimary500)
                        .cornerRadius(Constants.fontSizeXs)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.fontSizeXs)
                                .inset(by: 0.5)
                                .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                        )
                }
                .sheet(isPresented: $showWebView) {
                    // 웹사이트를 모달로 띄우는 WebView
                    SafariView(url: URL(string: articleDetail.url)!) // SafariView로 URL을 띄움
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 195)
    }
}

// SafariView 구현 (웹 페이지를 모달로 띄우기 위한 뷰)
struct SafariView: View {
    let url: URL
    
    var body: some View {
        SafariViewController(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

// SafariViewController: SwiftUI에서 UIKit을 사용할 때 Safari를 모달로 띄우는 방법
struct SafariViewController: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct ThesisBottomView: View {
    let abstract: String  // 초록을 받아서 표시
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("초록")
                    .font(.system(size: Constants.fontSizeXl, weight: Constants.fontWeightSemibold))
                    .foregroundColor(Constants.GrayColorGray900)
                    .padding(.vertical, 16)
                Spacer()
            }
            
            // 초록 텍스트 (모든 내용이 표시되도록 lineLimit을 nil로 설정)
            Text(abstract)
                .padding(.vertical, 16)
                .font(Font.custom("Pretendard", size: Constants.fontSizeM))
                .foregroundColor(Constants.GrayColorGray600)
                .lineLimit(nil) // 초록의 모든 내용 표시
        }
        .padding(.leading, 16)
        .frame(maxWidth: .infinity)
        .background(Constants.GrayColorGray50)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .inset(by: 0.5)
                .stroke(Constants.BorderColorBorder1, lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    ThesisView(articleId: "ART002914111")
}
