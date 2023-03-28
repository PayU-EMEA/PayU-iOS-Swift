//
//  NumberFormatter+Extensions.swift
//  
//  Created by PayU S.A. on 23/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

extension NumberFormatter {
  
  // MARK: - Public Properties
  static let percent: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.multiplier = NSNumber(value: 1)
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 2
    formatter.locale = .current
    return formatter
  }()
  
  static func price(currencyCode: String) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.currencyCode = currencyCode
    formatter.numberStyle = .currency
    formatter.multiplier = NSNumber(value: 0.01)
    formatter.minimumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.locale = .current
    return formatter
  }

}
