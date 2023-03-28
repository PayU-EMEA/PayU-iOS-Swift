//
//  DefaultPaymentCardCVVValidator.swift
//  
//  Created by PayU S.A. on 22/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct DefaultPaymentCardCVVValidator: PaymentCardValidatorProtocol {
  func validate(_ value: String?) throws {
    guard let value = value else { throw PaymentCardError.emptyCVV }
    if value.isEmpty { throw PaymentCardError.emptyCVV }
    if value.count != 3 { throw PaymentCardError.invalidCVV }
  }
}
