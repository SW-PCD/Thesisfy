//
//  NetworkManager.swift
//  Thesisfy
//
//  Created by 황필호 on 11/27/24.
//

import Foundation
import Alamofire

// 회원가입
struct Register: Codable {
    let email: String
    let password: String
    let nickname: String
    let job: String
}

struct RegisterResponse: Codable {
    var message: String?
}

// 논문 상세 정보
struct ArticleDetail: Codable {
    let articleId: String
    let title: String
    let abstract: String
    let authors: String
    let institution: String
    let journalName: String
    let publisherName: String
    let pubYear: String
    let articleCategories: String
    let url: String
}

// 논문 검색
struct SearchResponse: Codable {
    let total: String
    let records: [Record]
    
    struct Record: Codable {
        let title: [LocalizedTitle]
        let abstract: [LocalizedAbstract]?
        let authors: [String]
        let pubYear: String
        let url: String
        let category: String
        
        // 'title' 배열에서 적절한 언어의 제목을 반환 (기본은 'original')
        var localizedTitle: String {
            title.first { $0.lang == "original" }?.value ?? title.first?.value ?? "제목 없음"
        }
        
        // 'abstract' 배열에서 적절한 언어의 초록을 반환 (기본은 'original')
        var localizedAbstract: String {
            abstract?.first { $0.lang == "original" }?.value ?? "초록 없음"
        }
        
        private enum CodingKeys: String, CodingKey {
            case title, abstract, authors, pubYear, url, category
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode([LocalizedTitle].self, forKey: .title)
            abstract = try container.decodeIfPresent([LocalizedAbstract].self, forKey: .abstract)
            pubYear = try container.decode(String.self, forKey: .pubYear)
            url = try container.decode(String.self, forKey: .url)
            category = try container.decode(String.self, forKey: .category)
            
            // authors를 문자열 또는 배열로 처리
            if let authorsArray = try? container.decode([String].self, forKey: .authors) {
                authors = authorsArray
            } else if let authorsString = try? container.decode(String.self, forKey: .authors) {
                authors = [authorsString]
            } else {
                authors = []
            }
        }
    }
    
    struct LocalizedTitle: Codable {
        let value: String
        let lang: String?
        
        private enum CodingKeys: String, CodingKey {
            case value = "_" // JSON의 '_' 키를 Swift의 'value' 변수로 매핑
            case lang
        }
    }
    
    struct LocalizedAbstract: Codable {
        let value: String
        let lang: String
        
        private enum CodingKeys: String, CodingKey {
            case value = "_" // JSON의 '_' 키를 Swift의 'value' 변수로 매핑
            case lang
        }
        
        // lang 키가 없을 경우 기본값을 설정
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try container.decode(String.self, forKey: .value)
            self.lang = try container.decodeIfPresent(String.self, forKey: .lang) ?? "unknown"
        }
    }
}

// AI챗봇
struct ChatRequest: Codable {
    let userId: Int
    let prompt: String
}

struct ChatResponse: Codable {
    let reply: String
}

// 회원 탈퇴
struct DeleteAccountRequest: Codable {
    let email: String
    let password: String
}

struct DeleteAccountResponse: Codable {
    var message: String? // 성공 메시지
    var error: String?   // 오류 메시지
}

class ArticleDetailViewModel: ObservableObject {
    @Published var articleDetail: ArticleDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadArticleDetail(articleId: String) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.fetchArticleDetail(articleId: articleId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let articleDetail):
                    self.articleDetail = articleDetail
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// NetworkManager.swift
extension NetworkManager {
    // 논문 상세 정보 요청
    func fetchArticleDetail(articleId: String, completion: @escaping (Result<ArticleDetail, Error>) -> Void) {
        let url = APIConstants.detailSearchURL
        let params: [String: Any] = ["id": articleId] // `id` 파라미터로 전달

        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default)
            .responseDecodable(of: ArticleDetail.self) { response in
                switch response.result {
                case .success(let articleDetail):
                    completion(.success(articleDetail))
                case .failure(let error):
                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                        print("Raw Error Response: \(rawString)")
                    }
                    completion(.failure(error))
                }
            }
    }
}

// 작성중인 논문 보조
struct Recommendation: Identifiable, Codable {  //@@@@@ 수정: Identifiable 프로토콜 추가
    let id = UUID() //@@@@@ 수정: UUID 자동 생성
    let title: String
    let field: String
    let authors: String
    let url: String
}

// 전체 응답 모델
struct AnalysisRequest: Codable {
    let pdf: String // 논문 파일 이름
}

struct AnalysisData: Codable {
    let overall_progress: Int
    let recommendations: [Recommendation]
}

struct Response: Codable {
    let analysis: String // 이중 디코딩이 필요한 문자열 데이터
}

//    struct AnalysisRequest: Codable {
//        let pdf: String // 논문 파일 이름
//    }
//
//    struct AnalysisResponse: Codable {
//        let analysis: AnalysisData
//
//        struct AnalysisData: Codable {
//            let overall_progress: Int // 진행률 (0~100)
//            let recommend: [Recommendation]? // 추천 논문 리스트
//        }
//    }

struct ErrorResponse: Codable {
    let error: String
}

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    @Published var registerResponse: RegisterResponse?
    @Published var searchResponse: SearchResponse?
    @Published var chatResponse: String? // 챗봇 응답 저장
    @Published var deleteAccountResponse: DeleteAccountResponse? // 탈퇴 응답 저장
    @Published var analysisResponse: AnalysisData? // 이중 디코딩 후 결과 저장
    
    // MARK: - Custom Error 타입 추가
    enum NetworkError: Error {
        case custom(String) // 커스텀 에러 메시지를 포함
        case decodingError(String) // 디코딩 관련 에러
        
        var localizedDescription: String {
            switch self {
            case .custom(let message), .decodingError(let message):
                return message
            }
        }
    }
    
    // MARK: 회원가입
    func registerBtnTapped(registerModel: Register) {
        let url = APIConstants.registerURL
        
        // Register 모델 객체를 JSON으로 인코딩
        AF.request(url, method: .post, parameters: registerModel, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let value):
                    self.registerResponse = value
                    print("회원가입 성공: \(value.message ?? "메시지 없음")")
                case .failure(let error):
                    print("회원가입 실패: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: 회원 탈퇴
    func deleteAccount(password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let email = UserManager.shared.email else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "이메일 정보가 없습니다."])))
            return
        }
        
        let url = APIConstants.deleteAccountURL // 탈퇴 API URL
        let parameters = DeleteAccountRequest(email: email, password: password) // 요청 데이터
        
        // POST 요청
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: DeleteAccountResponse.self) { response in
                switch response.result {
                case .success(let value):
                    if let message = value.message {
                        completion(.success(message)) // 성공 메시지 전달
                        print("회원 탈퇴 성공: \(message)")
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "알 수 없는 오류"])))
                        print("회원 탈퇴 실패: 알 수 없는 메시지")
                    }
                case .failure(let error):
                    // 디코딩 실패 시 원시 데이터를 로깅
                    if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                        print("Raw Response: \(rawResponse)")
                    }
                    completion(.failure(error))
                    print("회원 탈퇴 요청 실패: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: 논문 검색
    func paperSearchBtnTapped(query: String, page: Int = 1, displayCount: Int = 20) {
        let url = APIConstants.searchURL
        let params: [String: Any] = [
            "query": query,
            "page": page,
            "displayCount": displayCount
        ]
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default)
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        print("Error: No data received from server.")
                        return
                    }
                    
                    // JSON 디코더를 사용하여 응답 처리
                    let decoder = JSONDecoder()
                    // 기본 설정 (키 디코딩 전략 및 데이터 디코딩 전략)
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    decoder.dataDecodingStrategy = .deferredToData
                    
                    do {
                        let decodedResponse = try decoder.decode(SearchResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.searchResponse = decodedResponse
                        }
                    } catch {
                        if let rawString = String(data: data, encoding: .utf8) {
                            print("Raw Response (Not JSON): \(rawString)")
                        }
                        print("JSON Decoding Error: \(error)")
                    }
                    
                case .failure(let error):
                    print("Request failed: \(error)")
                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                        print("Raw Error Response: \(rawString)")
                    }
                }
            }
    }
    
    // MARK: OpenAI API 호출 메서드
    func sendPromptToChatBot(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userId = UserManager.shared.userId else {
            print("Error: User ID not found. User must be logged in.")
            completion(.failure(NSError(domain: "User ID Missing", code: 0, userInfo: nil)))
            return
        }
        
        let url = APIConstants.chatBotURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters = ChatRequest(userId: userId, prompt: prompt)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: ChatResponse.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value.reply))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: 업로드 함수
    // 업로드 함수에서 데이터가 정상적으로 전송되었는지 확인하는 로그 추가
    func uploadPDF(fileData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard !fileData.isEmpty else {
            print("Error: 파일 데이터가 비어 있습니다.")
            completion(.failure(NetworkError.custom("파일 데이터가 비어 있습니다.")))
            return
        }

        let url = APIConstants.analysisURL

        AF.upload(multipartFormData: { formData in
            formData.append(fileData, withName: "pdf", fileName: "document.pdf", mimeType: "application/pdf")
        }, to: url)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    completion(.success(jsonString))
                } else {
                    completion(.failure(NetworkError.custom("서버 응답이 없습니다.")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Analysis 요청 메서드
    // 추천 논문 데이터를 가져오는 메서드
    func fetchRecommendationsData(request: AnalysisRequest, completion: @escaping (Result<AnalysisData, NetworkError>) -> Void) {
            let url = APIConstants.analysisURL
            
            AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
                .response { response in
                    if let data = response.data {
                        print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "No readable data")")
                        
                        let decoder = JSONDecoder()
                        do {
                            // Step 1: 1차 디코딩 (Response 구조체)
                            let decodedResponse = try decoder.decode(Response.self, from: data)
                            
                            // Step 2: analysis 필드를 다시 JSON으로 디코딩
                            guard let analysisData = decodedResponse.analysis.data(using: .utf8) else {
                                throw NetworkError.custom("analysis 필드를 Data로 변환할 수 없습니다.")
                            }
                            
                            let analysis = try decoder.decode(AnalysisData.self, from: analysisData)
                            completion(.success(analysis))
                            print("디코딩 성공: \(analysis)")
                        } catch {
                            print("Response 데이터를 디코딩하는 중 오류 발생: \(error.localizedDescription)")
                            completion(.failure(.custom("Response 데이터를 디코딩할 수 없습니다.")))
                        }
                    } else {
                        print("서버로부터 데이터를 받지 못했습니다.")
                        completion(.failure(.custom("서버로부터 데이터를 받지 못했습니다.")))
                    }
                }
        }
}
