//
//  RegisterModel.swift
//  Thesisfy
//
//  Created by KKM on 11/26/24.
//

import Foundation

struct RegisterModel: Encodable {
    var email: String
    var password: String
    var nickname: String
    var job: String
}

struct RegisterResponse: Decodable {
    var message: String?
}
