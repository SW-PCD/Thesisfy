//
//  LoginModel.swift
//  Thesisfy
//
//  Created by KKM on 11/26/24.
//

import Foundation

struct LoginModel: Encodable {
    var email: String?
    var password: String?
}

struct LoginResponse: Decodable {
    let message: String
    let user: UserInfo
}

struct UserInfo: Decodable {
    let id: Int
    let email: String
    let nickname: String
    let job: String
}
