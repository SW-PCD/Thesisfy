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
    var error: String?
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

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    @Published var registerResponse: RegisterResponse?
    @Published var searchResponse: SearchResponse?
    
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
    
    // MARK: 논문 검색
    func paperSearchBtnTapped(query: String, page: Int = 1, displayCount: Int = 10) {
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
//    func paperSearchBtnTapped(with search: Search) {
//        let url = APIConstants.searchURL //@@@@@ API URL
//        
//        // URL에 쿼리 파라미터 추가
//        let param: [String: String] = [ //@@@@@ 요청 파라미터 구성
//            "query": search.query,
////            "key": "YOUR_API_KEY",
////            "apiCode": "articleSearch"
//        ]
//        
//        // GET 요청
//        AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default) //@@@@@ URL 쿼리 파라미터 인코딩
//            .response { response in
//                switch response.result {
//                case .success(let data):
//                    guard let data = data else {
//                        print("Error: No data received from server.") //@@@@@ 데이터 없을 경우
//                        return
//                    }
//                    
//                    // JSON 디코딩 시도
//                    do {
//                        let decodedResponse = try JSONDecoder().decode(SearchResponse.self, from: data) //@@@@@ JSON 디코딩
//                        self.searchResponse = decodedResponse
//                        print("총 결과 수: \(decodedResponse.total)")
//                        print("첫 번째 논문 제목: \(decodedResponse.records.first?.title ?? "없음")")
//                    } catch {
//                        // JSON 디코딩 실패 시 원시 응답 출력
//                        if let rawString = String(data: data, encoding: .utf8) { //@@@@@ 원시 응답 출력
//                            print("Raw Response (Not JSON): \(rawString)")
//                        }
//                        print("JSON Decoding Error: \(error)")
//                    }
//                case .failure(let error):
//                    // 요청 실패 처리
//                    print("Request failed: \(error)") //@@@@@ 요청 실패 메시지 출력
//                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
//                        print("Raw Error Response: \(rawString)") //@@@@@ 실패 시 원시 응답 출력
//                    }
//                }
//            }
//    }
}
