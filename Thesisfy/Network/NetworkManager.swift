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
struct Search: Codable {
    let query: String // 검색 키워드
}

struct SearchResponse: Codable {
    let total: Int           // 총 검색 결과 수
    let records: [Record]    // 논문 결과 리스트
    
    struct Record: Codable {
        let title: String        // 논문 제목
        let abstract: String     // 논문 초록
        let authors: [String]    // 저자 리스트
        let pubYear: String      // 발행 연도
        let url: String          // 논문 URL
        let category: String     // 논문 카테고리
    }
}

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    @Published var register: Register = .init(email: "", password: "", nickname: "", job: "")
    @Published var registerResponse: RegisterResponse?
    @Published var searchResponse: SearchResponse?
    
    //    func fetchTodos() {
    //        let url = "https://jsonplaceholder.typicode.com/todos"
    //        AF.request(url, method: .get)
    //            .responseDecodable(of: [Todo].self) { data in
    //                guard let data = data.value else { return }
    //                self.todo = data
    //            }
    //    }
    
    // MARK: 회원가입
    func registerBtnTapped() {
        let url = APIConstants.registerURL
        
        let param: [String: Any] = [
            "email": "testasdfsadf12fff345@gmail.com",
            "password": "password",
            "nickname": "hwang",
            "job": "student"
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let value):
                    self.registerResponse = value
                    print(self.registerResponse ?? "adsfsadf실패")
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    // MARK: 논문 검색
    func paperSearchBtnTapped(with search: Search) {
        let url = APIConstants.searchURL //@@@@@ API URL
        
        // URL에 쿼리 파라미터 추가
        let param: [String: String] = [ //@@@@@ 요청 파라미터 구성
            "query": search.query,
//            "key": "YOUR_API_KEY",
//            "apiCode": "articleSearch"
        ]
        
        // GET 요청
        AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default) //@@@@@ URL 쿼리 파라미터 인코딩
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        print("Error: No data received from server.") //@@@@@ 데이터 없을 경우
                        return
                    }
                    
                    // JSON 디코딩 시도
                    do {
                        let decodedResponse = try JSONDecoder().decode(SearchResponse.self, from: data) //@@@@@ JSON 디코딩
                        self.searchResponse = decodedResponse
                        print("총 결과 수: \(decodedResponse.total)")
                        print("첫 번째 논문 제목: \(decodedResponse.records.first?.title ?? "없음")")
                    } catch {
                        // JSON 디코딩 실패 시 원시 응답 출력
                        if let rawString = String(data: data, encoding: .utf8) { //@@@@@ 원시 응답 출력
                            print("Raw Response (Not JSON): \(rawString)")
                        }
                        print("JSON Decoding Error: \(error)")
                    }
                case .failure(let error):
                    // 요청 실패 처리
                    print("Request failed: \(error)") //@@@@@ 요청 실패 메시지 출력
                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                        print("Raw Error Response: \(rawString)") //@@@@@ 실패 시 원시 응답 출력
                    }
                }
            }
    }
}
