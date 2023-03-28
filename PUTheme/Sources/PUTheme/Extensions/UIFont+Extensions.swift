//
//  UIFont+Extensions.swift
//  
//  Created by PayU S.A. on 28/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import UIKit

extension UIFont {

  // MARK: - FamilyName
  enum FamilyName {

    // MARK: - OpenSans
    enum AmpleSoft: String, CaseIterable {
      case regular = "AmpleSoftPro-Regular"

      // MARK: - Public Methods
      static func fontName(weight: UIFont.Weight) -> Self {
        return .regular
      }
    }
  }

  // MARK: - Register Font
  static func registerFonts() {
    UIFont.FamilyName.AmpleSoft.allCases.forEach { registerFont(fontName: $0.rawValue, withExtension: "ttf") }
  }

  private static func registerFont(fontName: String, withExtension fontExtension: String) {
    guard let url = Bundle.current(.PUTheme).url(forResource: fontName, withExtension: fontExtension),
          let dataProvider = CGDataProvider(url: url as CFURL),
          let font = CGFont(dataProvider) else { return }

    var error: Unmanaged<CFError>?
    CTFontManagerRegisterGraphicsFont(font, &error)
  }

  // MARK: - Public Methods
  static func defaultFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
    return UIFont(
      name: UIFont
        .FamilyName
        .AmpleSoft
        .fontName(weight: weight)
        .rawValue,
      size: size) ?? UIFont.systemFont(ofSize: size)
  }
}
