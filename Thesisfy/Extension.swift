//
//  Extension.swift
//  Thesisfy
//
//  Created by KKM on 11/26/24.
//

import Foundation

import UIKit

extension UIApplication {
    func hideKeyboardWhenTappedAround() {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        window.addGestureRecognizer(tapRecognizer)
    }
}
