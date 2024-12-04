//  thesisManagementView.swift
   //  Thesisfy
   //
   //  Created by 황필호 on 11/21/24.
   //

   import SwiftUI
   import ExytePopupView
   import UniformTypeIdentifiers

struct BeingWrittenView: View {
    @Binding var path: [Route] //네비게이션 경로를 전달받기 위해 path 추가
    @Binding var selectedFileName: String // 선택된 파일 이름 상위 뷰에서 전달받음
    @Binding var selectedFileDate: String // 선택된 파일 날짜 상위 뷰에서 전달받음
    @Binding var progress: Double // 진행률 추가
    
    @State private var isShowEditPopup = false // 편집 팝업 상태 변수
    @State private var isShowingDocumentPicker = false // 파일 선택 팝업 상태
    @State private var isRequesting = false // 요청 상태
    @State private var alertMessage: String? // Alert 메시지를 저장하는 상태 변수
    
    @State private var recommendations: [Recommendation] = [] // AI 추천 논문 리스트
    @State private var isLoadingRecommendations = false // 로딩 상태 추가
    
    var body: some View {
        VStack {
            setTopView(isShowEditPopup: $isShowEditPopup)
                .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
            
            Spacer()
                .frame(height: 12.15)
            
            Divider()
            
            Spacer()
                .frame(height: 24)
            
            ScrollView(showsIndicators: false) {
                TitleView()
                
                Spacer()
                    .frame(height: 24)
                
                MyThesisView(
                    selectedFileName: $selectedFileName,
                    selectedFileDate: $selectedFileDate,
                    onUpdateTap: {
                        // DocumentPicker 표시
                        isShowingDocumentPicker = true
                    }
                )
                
                Spacer()
                    .frame(height: 24)
                
                progressBar(progress: $progress)
                
                Spacer()
                    .frame(height: 24)
                
                if isLoadingRecommendations {
                    ProgressView("추천 논문을 불러오는 중...")
                        .padding()
                } else {
                    AiRecommendThesisView(
                        recommendations: $recommendations, // @Binding으로 recommendations 바인딩
                        path: $path
                    )
                }
                
                Spacer()
                    .frame(height: 24)
                
                MemoView()
                
                Spacer()
            }
            
            ThesisButton()
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(
                fileName: $selectedFileName,
                fileDate: $selectedFileDate,
                onFileSelected: sendAnalysisRequest //파일 선택 후 서버 요청 실행
            )
        }
        // 편집 팝업
        .popup(isPresented: $isShowEditPopup) {
            EditView(isShowEditPopup: $isShowEditPopup)
        } customize: {
            $0
                .type(.default)
                .position(.center)
                .animation(.easeInOut)
                .autohideIn(nil)
                .dragToDismiss(false)
                .closeOnTap(false) //내부 터치 방지
                .closeOnTapOutside(false) // 바깥 터치 방지
                .backgroundColor(.black.opacity(0.5))
                .isOpaque(true)
        }
        .onAppear(perform: fetchRecommendations)
    }
    
    // 서버 요청 메서드
    private func sendAnalysisRequest() {
            guard !selectedFileName.isEmpty else {
                showAlert(message: "파일이 선택되지 않았습니다.")
                return
            }
            
            // 파일 URL 확인
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(selectedFileName)
            print("파일 경로 확인: \(fileURL.path)")
            
            // 파일 데이터 읽기
            do {
                let fileData = try Data(contentsOf: fileURL)
                print("파일 데이터를 성공적으로 읽었습니다. 크기: \(fileData.count) 바이트")
                
                isRequesting = true // 요청 시작
                
                // NetworkManager를 통해 파일 업로드
                NetworkManager.shared.uploadPDF(fileData: fileData) { result in
                    DispatchQueue.main.async {
                        self.isRequesting = false // 로딩 상태 해제
                        
                        switch result {
                        case .success(let response):
                            print("요청 성공: \(response)")
                            if let progressValue = self.extractProgress(from: response) {
                                self.progress = progressValue // 진행률 업데이트
                                print("진행률 업데이트: \(progressValue * 100)%")
                            } else {
                                self.showAlert(message: "진행률 데이터를 추출할 수 없습니다.")
                            }
                        case .failure(let error):
                            print("요청 실패: \(error.localizedDescription)")
                            self.showAlert(message: "업로드 중 문제가 발생했습니다. 다시 시도해주세요.")
                        }
                    }
                }
            } catch {
                print("Error: 파일 데이터를 로드할 수 없습니다. - \(error.localizedDescription)")
                showAlert(message: "파일 데이터를 로드할 수 없습니다.")
            }
        }
    
    // 서버 응답에서 진행률 추출
    private func extractProgress(from response: String) -> Double? {
            guard let data = response.data(using: .utf8) else {
                print("Error: 응답 데이터를 Data 형식으로 변환할 수 없습니다.")
                return nil
            }
            
            do {
                // JSON 데이터 디코딩
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let analysisText = jsonResponse["analysis"] as? String {
                    // "overall_progress" 값을 추출
                    let pattern = #""overall_progress": (\d+)"# // "overall_progress" 패턴을 찾음
                    if let regex = try? NSRegularExpression(pattern: pattern),
                       let match = regex.firstMatch(in: analysisText, range: NSRange(analysisText.startIndex..., in: analysisText)) {
                        if let range = Range(match.range(at: 1), in: analysisText),
                           let progressValue = Double(analysisText[range]) {
                            return progressValue / 100.0 // 0~1 범위로 변환
                        }
                    }
                }
            } catch {
                print("JSON 디코딩 실패: \(error.localizedDescription)")
            }
            return nil
        }
    
    private func fetchRecommendations() {
            isLoadingRecommendations = true
            let request = AnalysisRequest(pdf: selectedFileName)

            NetworkManager.shared.fetchRecommendationsData(request: request) { result in
                DispatchQueue.main.async {
                    self.isLoadingRecommendations = false
                    switch result {
                    case .success(let analysisData):
                        self.progress = Double(analysisData.overall_progress) / 100.0
                        self.recommendations = analysisData.recommendations
                        print("추천 논문 리스트 업데이트: \(self.recommendations)")
                    case .failure(let error):
                        print("추천 논문 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
                        self.showAlert(message: "추천 논문 데이터를 가져오는데 실패했습니다.")
                    }
                }
            }
        }
    
    private func showAlert(message: String) {
            alertMessage = message
            print("Alert: \(message)")  // 알림 메시지 출력
        }
    }

   struct setTopView: View {
       @Binding var isShowEditPopup: Bool
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
               
               Button(action: {
                   withAnimation {
                       isShowEditPopup = true // 편집 팝업 표시
                   }
               }) {
                   Image(systemName: "ellipsis")
                       .padding(.trailing, 30)
                       .foregroundColor(Color.gray)
               }
           }
           .frame(maxWidth: .infinity, alignment: .center)
           .padding(.vertical, 0)
           .background(Constants.GrayColorWhite)
       }
   }

   //편집 팝업 뷰
   struct EditView: View {
       @Binding var isShowEditPopup: Bool
       
       var body: some View {
           VStack {
               VStack {
                   VStack(alignment: .center) {
                       Text("편집")
                           .font(
                               Font.custom("Pretendard", size: Constants.fontSizeL)
                                   .weight(Constants.fontWeightSemibold)
                           )
                           .multilineTextAlignment(.center)
                           .foregroundColor(Constants.GrayColorGray900)
                       
                       Spacer()
                           .frame(height: 10)
                       
                       Text("작성중인 논문을 완료하시면 복구하기 어려워요. 그래도 완료 할까요?")
                           .font(
                               Font.custom("Pretendard", size: Constants.fontSizeS)
                                   .weight(Constants.fontWeightMedium)
                           )
                           .foregroundColor(Constants.GrayColorGray800)
                           .frame(maxWidth: .infinity)
                           .padding(.horizontal, 20)
                   }
                   .padding(.top, 24)
                   .allowsHitTesting(false) // 이 영역의 터치 이벤트 비활성화
                   
                   Spacer()
                       .frame(height: 28)
                   
                   HStack(spacing: 6) {
                       Button(action: {
                           isShowEditPopup = false // 팝업 닫기
                       }) {
                           Text("완료")
                               .font(
                                   Font.custom("Pretendard", size: Constants.fontSizeM)
                                       .weight(Constants.fontWeightMedium)
                               )
                               .foregroundColor(Constants.GrayColorGray400)
                               .frame(maxWidth: .infinity)
                               .frame(height: 48)
                               .background(Constants.GrayColorGray100)
                               .cornerRadius(8)
                       }
                       .allowsHitTesting(true) // 삭제 버튼 클릭 허용
                       
                       Button(action: {
                           isShowEditPopup = false // 팝업 닫기
                       }) {
                           Text("닫기")
                               .font(
                                   Font.custom("Pretendard", size: Constants.fontSizeM)
                                       .weight(Constants.fontWeightSemibold)
                               )
                               .foregroundColor(Constants.GrayColorWhite)
                               .frame(maxWidth: .infinity)
                               .frame(height: 48)
                               .background(Constants.PrimaryColorPrimary500)
                               .cornerRadius(8)
                       }
                       .allowsHitTesting(true) // 닫기 버튼 클릭 허용
                   }
                   .padding(.bottom, 20)
                   .padding(.horizontal, 20)
                   
               }
           }
           .frame(maxWidth: .infinity, alignment: .top)
           .frame(height: 200)
           .background(Constants.GrayColorWhite)
           .cornerRadius(16)
           .padding(.horizontal, 48)
           .padding(.top, -10) // 전체 내용을 위로 10 포인트 이동
       }
   }

   struct TitleView: View {
       var body: some View {
           HStack {
               VStack(alignment: .leading) {
                   Text("AI 관련 논문")
                       .font(
                           Font.custom("Pretendard", size: Constants.fontSizeXxl)
                               .weight(Constants.fontWeightSemibold)
                       )
                       .foregroundColor(Constants.GrayColorGray900)
                   
                   Spacer()
                       .frame(height: 7)
                   
                   HStack {
                       Text("컴퓨터공학>>인공지능")
                           .font(
                               Font.custom("Pretendard", size: 13)
                                   .weight(Constants.fontWeightSemibold)
                           )
                           .foregroundColor(Constants.PrimaryColorPrimary600)
                   }
               }
               Spacer()
           }
           .padding(.leading, 24)
       }
   }

   struct MyThesisView: View {
       @Binding var selectedFileName: String // 선택된 파일 이름
       @Binding var selectedFileDate: String // 업로드 날짜
       var onUpdateTap: () -> Void // 버튼 클릭 동작 전달
       
       var body: some View {
           VStack {
               HStack {
                   Spacer()
                   
                   // 업데이트 버튼
                   Button(action: onUpdateTap) {
                       Text("업데이트")
                           .font(
                               Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                   .weight(Constants.fontWeightMedium)
                           )
                           .foregroundColor(Constants.GrayColorGray400)
                   }
               }
               
               HStack {
                   // 논문 이미지
                   Image("pdf")
                       .resizable()
                       .frame(width: 42, height: 42)
                       .padding(.leading, 16)
                   
                   Spacer()
                       .frame(width: 12)
                   
                   VStack(alignment: .leading, spacing: 0) {
                       Text(selectedFileName)
                           .font(
                               Font.custom("Pretendard", size: Constants.fontSizeS)
                                   .weight(Constants.fontWeightSemibold)
                           )
                           .foregroundColor(Constants.GrayColorGray900)
                       
                       HStack {
                           Text("업데이트")
                               .font(
                                   Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                       .weight(Constants.fontWeightSemibold)
                               )
                               .foregroundColor(Constants.GrayColorGray800)
                           
                           Text(selectedFileDate.isEmpty ? "날짜 없음" : selectedFileDate)
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
           .padding(.horizontal, 24)
       }
   }

   struct progressBar: View {
       @Binding var progress: Double // 진행률
       
       var body: some View {
           HStack {
               Text("진행률")
                   .font(
                       Font.custom("Pretendard", size: Constants.fontSizeS)
                           .weight(Constants.fontWeightSemibold)
                   )
                   .foregroundColor(Constants.GrayColorGray900)
               
               ProgressView(value: progress)
                   .progressViewStyle(LinearProgressViewStyle(tint: .red))
                   .frame(width: 260)
               
               Spacer()
                   .frame(width: 5)
               
               Text("\(Int(progress * 100))%")
                   .font(
                       Font.custom("Pretendard", size: Constants.fontSizeS)
                           .weight(Constants.fontWeightSemibold)
                   )
                   .foregroundColor(Constants.GrayColorGray900)
               
               Spacer()
           }
           .frame(maxWidth: .infinity)
           .padding(.horizontal, 24)
       }
   }

   struct MemoView: View {
       @State private var memoText: String = "" // 메모 텍스트 상태 변수
       @State private var showAlert: Bool = false // 알림 표시 여부 상태 변수
       
       var body: some View {
           VStack {
               HStack {
                   Text("메모")
                       .font(
                           Font.custom("Pretendard", size: Constants.fontSizeL)
                               .weight(Constants.fontWeightSemibold)
                       )
                       .foregroundColor(Constants.GrayColorGray900)
                   
                   Spacer()
                   
                   // 저장 버튼
                   Button(action: {
                       saveMemo()
                       showAlert = true // 저장 완료 알림 표시
                   }) {
                       Text("저장")
                           .font(
                               Font.custom("Pretendard", size: Constants.fontSizeM)
                                   .weight(Constants.fontWeightMedium)
                           )
                           .foregroundColor(Constants.PrimaryColorPrimary600)
                   }
                   .alert(isPresented: $showAlert) {
                       Alert(
                           title: Text("저장 완료"),
                           message: Text("메모가 저장되었습니다."),
                           dismissButton: .default(Text("확인"))
                       )
                   }
               }
               
               TextEditor(text: $memoText) // 상태 변수를 바인딩
                   .frame(height: 200) // 세로 길이 설정
                   .padding(.horizontal, Constants.fontSizeXs)
                   .padding(.vertical, Constants.fontSizeS)
                   .background(Constants.GrayColorWhite)
                   .cornerRadius(6)
                   .overlay(
                       RoundedRectangle(cornerRadius: 6)
                           .inset(by: 0.5)
                           .stroke(Constants.BorderColorBorder2, lineWidth: 1)
                   )
           }
           .padding(.horizontal, 24)
           .onAppear(perform: loadMemo) // 뷰가 나타날 때 메모 로드
       }
       
       // MARK: - 저장 로직
       private func saveMemo() {
           UserDefaults.standard.set(memoText, forKey: "SavedMemo")
       }
       
       // MARK: - 불러오기 로직
       private func loadMemo() {
           if let savedMemo = UserDefaults.standard.string(forKey: "SavedMemo") {
               memoText = savedMemo
           }
       }
   }

struct AiRecommendThesisView: View {
    @Binding var recommendations: [Recommendation]
    @Binding var path: [Route]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("AI 추천 논문")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    path.append(.aiRecommendView)
                }) {
                    Text("더보기")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 24)

            if recommendations.isEmpty {
                Text("추천 논문이 없습니다.")
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
                    .onAppear {
                        print("추천 논문 데이터가 비어 있습니다.")
                    }
            } else {
                List(recommendations) { recommendation in
                    RecommendationRowView(recommendation: recommendation)
                }
                .onAppear {
                    print("추천 논문 데이터: \(recommendations)")
                }
            }
        }
        .padding(.top, 16)
    }
}

struct RecommendationRowView: View {
    let recommendation: Recommendation
    
    var body: some View {
        Button(action: {
            if let url = URL(string: recommendation.url) {
                UIApplication.shared.open(url)
            } else {
                print("잘못된 URL: \(recommendation.url)")
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // 카테고리
                    Text(recommendation.field)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.PrimaryColorPrimary600)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Constants.PrimaryColorPrimary50)
                        .cornerRadius(6)
                    
                    // 제목
                    Text(recommendation.title)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    // 저자
                    Text(recommendation.authors)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.GrayColorGray600)
                }
                
                Spacer()
            }
            .padding()
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

   struct ThesisButton: View {
       var body: some View {
           ZStack {
               HStack(alignment: .center, spacing: Constants.fontSizeXxxs) {
                   Text("챗봇 사용하기")
                       .font(
                           Font.custom("Pretendard", size: Constants.fontSizeM)
                               .weight(Constants.fontWeightBold)
                       )
                       .foregroundColor(Constants.GrayColorWhite)
               }
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
           .padding(.horizontal, 24)
       }
   }

   struct DocumentPicker: UIViewControllerRepresentable {
       @Binding var fileName: String // 선택된 파일 이름
       @Binding var fileDate: String // 선택된 파일 날짜
       var onFileSelected: (() -> Void)? // 파일 선택 후 실행될 콜백 //@@@@@@ 파일 선택 후 실행되는 동작 전달
       
       func makeCoordinator() -> Coordinator {
           Coordinator(parent: self)
       }
       
       func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
           let documentPicker = UIDocumentPickerViewController(
               documentTypes: ["com.adobe.pdf"], // PDF만 선택 가능 //@@@@@@ PDF 타입으로 제한
               in: .import
           )
           documentPicker.delegate = context.coordinator
           return documentPicker
       }
       
       func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
           // 여기에서는 별도로 업데이트 작업 필요 없음 //@@@@@@ 빈 함수로 유지
       }
       
       class Coordinator: NSObject, UIDocumentPickerDelegate {
           let parent: DocumentPicker
           
           init(parent: DocumentPicker) {
               self.parent = parent
           }
           
           func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
               guard let selectedURL = urls.first else { return }
               
               // 파일 이름 업데이트
               parent.fileName = selectedURL.lastPathComponent
               
               // 임시 디렉토리로 복사
               let tempDirectory = FileManager.default.temporaryDirectory
               let destinationURL = tempDirectory.appendingPathComponent(selectedURL.lastPathComponent)
               do {
                   // 기존 파일 제거
                   if FileManager.default.fileExists(atPath: destinationURL.path) {
                       try FileManager.default.removeItem(at: destinationURL)
                   }
                   try FileManager.default.copyItem(at: selectedURL, to: destinationURL)
                   print("파일이 임시 디렉토리에 복사되었습니다: \(destinationURL.path)") //@@@@@@ 디버깅용 로그
               } catch {
                   print("Error: 파일 복사 실패 - \(error.localizedDescription)")
               }
               
               // 파일 선택 후 실행되는 동작 호출
               parent.onFileSelected?()
           }
           
           func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
               print("파일 선택이 취소되었습니다.") //@@@@@@ 선택 취소 시 로그 출력
           }
       }
   }

   #Preview {
       BeingWrittenView(
           path: .constant([]),
           selectedFileName: .constant("미리보기 논문.pdf"),
           selectedFileDate: .constant("2024년 12월 1일 10시 00분"),
           progress: .constant(0.5) // 정의에 포함된 경우
       )
   }
