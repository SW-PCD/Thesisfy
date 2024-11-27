//
//  APIConstants.swift
//  Thesisfy
//
//  Created by KKM on 11/26/24.
//

import Foundation

struct APIConstants {
    // MARK: - Base URL
    static let baseURL: String = "http://3.34.186.44:4000"
    
    static let loginURL: String = baseURL + "/auth/login"

    static let registerURL: String = baseURL + "/auth/register"
    
    static let logoutURL: String = baseURL + "/auth/logout"
    
    static let deleteURL: String = baseURL + "/auth/delete"
    
    static let searchURL: String = baseURL + "/kci/search"
}
