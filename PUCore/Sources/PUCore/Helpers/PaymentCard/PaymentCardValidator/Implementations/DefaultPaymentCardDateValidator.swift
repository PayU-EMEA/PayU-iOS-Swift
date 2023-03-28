//
//  DefaultPaymentCardDateValidator.swift
//  
//  Created by PayU S.A. on 22/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct DefaultPaymentCardDateValidator: PaymentCardValidatorProtocol {

  // MARK: - Private Properties
  private let dateParser: PaymentCardDateParserProtocol

  // MARK: - Initialization
  init(dateParser: PaymentCardDateParserProtocol) {
    self.dateParser = dateParser
  }

  func validate(_ value: String?) throws {
    guard let value = value else { throw PaymentCardError.emptyDate }
    if value.isEmpty { throw PaymentCardError.emptyDate }
    let date = dateParser.parse(value)
    if date == nil { throw PaymentCardError.invalidDate }
    if !date!.isInFuture { throw PaymentCardError.invalidDate }
  }
}
