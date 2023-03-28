//
//  PaymentCardLuhnValidator.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct DefaultPaymentCardLuhnValidator: PaymentCardLuhnValidatorProtocol {

  // MARK: - Initialization
  init() {  }

  // MARK: - PaymentCardLuhnValidatorProtocol
  func matches(_ value: String) -> Bool {
    var sum = 0
    let number = value.digitsOnly
    let strings = number.reversed().map { String($0) }

    for tuple in strings.enumerated() {
      if let digit = Int(tuple.element) {
        let odd = tuple.offset % 2 == 1
        switch (odd, digit) {
          case (true, 9):
            sum += 9
          case (true, 0...8):
            sum += (digit * 2) % 9
          default:
            sum += digit
        }
      } else {
        return false
      }
    }
    return sum % 10 == 0
  }

}

