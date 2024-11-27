//
//  ThesisfyApp.swift
//  Thesisfy
//
//  Created by KKM on 11/25/24.
//

import SwiftUI

@main
struct ThesisfyApp: App {
    var body: some Scene {
        WindowGroup {
            BaseViewController()
                .onAppear {
                    UIApplication.shared.hideKeyboardWhenTappedAround()
                }
        }
    }
}
