struct RootView: View {
    @State private var path: [Route] = [] // 네비게이션 스택 선언
    
    var body: some View {
        NavigationStack(path: $path) {
            MyPageView(path: $path) // path 전달
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .beingWrittenView:
                BeingWrittenView(path: $path) // 경로에 따라 이동할 뷰 설정
            case .aiRecommendView:
                AIRecommendView()
            }
        }
    }
}
