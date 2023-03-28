//
//  UIColor+Extensions.swift
//
//  Created by PayU S.A. on 15/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

/// Inspired by: https://www.avanderlee.com/swift/dark-mode-support-ios/
infix operator |: AdditionPrecedence
public extension UIColor {

    /// Easily define two colors for both light and dark mode.
    /// - Parameters:
    ///   - lightMode: The color to use in light mode.
    ///   - darkMode: The color to use in dark mode.
    /// - Returns: A dynamic color that uses both given colors respectively for the given user interface style.
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}

extension UIColor {
  public convenience init?(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
      case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
      case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
      default: (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(
      red: CGFloat(r) / 255,
      green: CGFloat(g) / 255,
      blue: CGFloat(b) / 255,
      alpha: CGFloat(a) / 255)
  }
}
