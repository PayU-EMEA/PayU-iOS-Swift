//
//  NumberFormatter+Extensions.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

extension NumberFormatter {
  static let currency: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = .current
    formatter.multiplier = NSNumber(value: 0.01)
    return formatter
  }()
}
