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
    
    //MARK: 논문 검색
    func paperSearchBtnTapped(with search: Search) {
        let url = "http://3.34.186.44:3000/kci/searchKci"
        
        // URL에 쿼리 파라미터 추가
        let param: [String: String] = [
            "query": search.query
        ]
        
        //GET 요청
        AF.request(url, method: .get, parameters: param)
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                case .success(let value):
                    self.searchResponse = value
                    print("총 결과 수: \(value.total)")
                    print("첫 번째 논문 제목: \(value.records.first?.title ?? "없음")")
                case .failure(let error):
                    print("논문 검색 실패: \(error)")
                }
            }
    }
}



