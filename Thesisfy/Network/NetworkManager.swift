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
    func paperSearchBtnTapped(with query: String) {
        let url = "http://3.34.186.44:3000/kci/searchKci"
        
        // URL에 쿼리 파라미터 추가
        let param: [String: String] = ["query": query]
        
        // GET 요청
        AF.request(url, method: .get, parameters: param, encoder: URLEncodedFormParameterEncoder.default)
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                case .success(let value):
                    self.searchResponse = value
                    print("총 결과 수: \(value.total)")
                    print("첫 번째 논문 제목: \(value.records.first?.title ?? "없음")")
                case .failure(let error):
                    print("논문 검색 실패: \(error.localizedDescription)")
                }
            }
    }
}
