//
//  DefaultPaymentCardFormatter.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

/// Default implementation for ``PaymentCardFormatterProtocol``
struct DefaultPaymentCardFormatter: PaymentCardFormatterProtocol {

  // MARK: - Private Properties
  private let mask: String

  // MARK: - Initialization
  init(mask: String) {
    self.mask = mask
  }

  // MARK: - PaymentCardFormatterProtocol
  func formatted(_ text: String) -> String {
    var result = ""
    let decimalDigits = text.digitsOnly
    var index = decimalDigits.startIndex

    for character in mask where index < decimalDigits.endIndex {
      if character == "#" {
        result.append(decimalDigits[index])
        index = decimalDigits.index(after: index)
      } else {
        result.append(character)
      }
    }
    return result
  }
}
