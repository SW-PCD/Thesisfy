//
//  Constants.swift
//  Thesisfy
//
//  Created by 황필호 on 11/3/24.
//

import Foundation
import SwiftUI

struct Constants {
    // MARK: - Colors
    static let GrayColorWhite: Color = .white
    static let GrayColorGray900: Color = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let GrayColorGray50: Color = Color(red: 0.98, green: 0.98, blue: 0.98)
    static let GrayColorGray100: Color = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let GrayColorGray400: Color = Color(red: 0.71, green: 0.71, blue: 0.71)
    static let GrayColorGray500: Color = Color(red: 0.58, green: 0.58, blue: 0.58)
    static let GrayColorGray600: Color = Color(red: 0.42, green: 0.42, blue: 0.42)
    static let GrayColorGray700: Color = Color(red: 0.35, green: 0.35, blue: 0.35)
    static let GrayColorGray800: Color = Color(red: 0.23, green: 0.23, blue: 0.23)
    static let PrimaryColorPrimary50: Color = Color(red: 0.89, green: 0.95, blue: 1)
    static let PrimaryColorPrimary100: Color = Color(red: 0.74, green: 0.86, blue: 1)
    static let PrimaryColorPrimary500: Color = Color(red: 0.18, green: 0.56, blue: 1)
    static let PrimaryColorPrimary600: Color = Color(red: 0.19, green: 0.51, blue: 0.94)
    static let SemanticColorNegativeNegative400: Color = Color(red: 1, green: 0.29, blue: 0.29)
    static let BorderColorBorder1: Color = .black.opacity(0.05)
    static let BorderColorBorder2: Color = .black.opacity(0.1)
    static let DropShadowShadow1: Color = .black.opacity(0.05)
    static let etcScrim: Color = .black.opacity(0.2)

    // MARK: - Font Sizes
    static let fontSizeXxxs: CGFloat = 10
    static let fontSizeXxs: CGFloat = 11
    static let fontSizeXs: CGFloat = 12
    static let fontSizeS: CGFloat = 14
    static let fontSizeM: CGFloat = 16
    static let fontSizeL: CGFloat = 18
    static let fontSizeXl: CGFloat = 20
    static let fontSizeXxl: CGFloat = 22
    static let fontSizeXxxl: CGFloat = 26

    // MARK: - Font Weights
    static let fontWeightRegular: Font.Weight = .regular
    static let fontWeightMedium: Font.Weight = .medium
    static let fontWeightSemibold: Font.Weight = .semibold
    static let fontWeightBold: Font.Weight = .bold
}
