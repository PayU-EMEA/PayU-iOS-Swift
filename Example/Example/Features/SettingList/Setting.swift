//
//  Setting.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

enum Setting {
  case countryCode(String)
  case currencyCode(String)
  case environment(EnvironmentModel?)
  case languageCode(String)
  case featureToggle
  case theme(Theme)

  var title: String {
    switch self {
      case .countryCode:
        return "Country"
      case .currencyCode:
        return "Currency"
      case .environment:
        return "Environment"
      case .languageCode:
        return "Language"
      case .featureToggle:
        return "Feature Toggle"
      case .theme:
        return "Theme"
    }
  }

  var subtitle: String? {
    switch self {
      case .countryCode(let countryCode):
        return countryCode
      case .currencyCode(let currencyCode):
        return currencyCode
      case .environment(let environment):
        return [
          environment?.environmentType.rawValue,
          environment?.clientId.limited(10)]
          .compactMap { $0 }.joined(separator: " · ")
      case .languageCode(let languageCode):
        return languageCode
      case .featureToggle:
        return nil
      case .theme(let theme):
        return theme.rawValue
    }
  }
}
