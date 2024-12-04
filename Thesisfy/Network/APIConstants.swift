//
//  APIConstants.swift
//  Thesisfy
//
//  Created by KKM on 11/26/24.
//

import Foundation

struct APIConstants {
    // MARK: - Base URL
    static let baseURL: String = "http://3.36.56.213:3000"
    
    static let loginURL: String = baseURL + "/auth/login"

    static let registerURL: String = baseURL + "/auth/register"
    
    static let logoutURL: String = baseURL + "/auth/logout"
    
    static let deleteURL: String = baseURL + "/auth/delete"
    
    static let searchURL: String = baseURL + "/kci/search"
    
    static let chatBotURL: String = baseURL + "/chat/chatopenai"
    
    static let deleteAccountURL: String = baseURL + "/auth/delete"
    
    static let analysisURL: String = baseURL + "/pdf/analyze"
    
    static let detailSearchURL: String = baseURL + "/kci/article-detail"
}
