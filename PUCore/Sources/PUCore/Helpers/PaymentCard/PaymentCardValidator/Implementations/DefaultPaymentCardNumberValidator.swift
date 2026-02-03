//
//  DefaultPaymentCardNumberValidator.swift
//  
//  Created by PayU S.A. on 22/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct DefaultPaymentCardNumberValidator: PaymentCardValidatorProtocol {

  // MARK: - Private Properties
  private let providerFinder: PaymentCardProviderFinderProtocol

  // MARK: - Initialization
  init(providerFinder: PaymentCardProviderFinderProtocol) {
    self.providerFinder = providerFinder
  }

  func validate(_ value: String?) throws {
    guard let value = value else { throw PaymentCardError.emptyNumber }
    if value.isEmpty { throw PaymentCardError.emptyNumber }
    let provider = providerFinder.find(value)
    if provider == nil { throw PaymentCardError.invalidNumber }
  }
    
  func canBeCompleted(_ value: String?) throws -> Bool{
      try validate(value);
      guard let value, let provider = providerFinder.find(value) else {
          return false
      }
      return provider == .visa ? value.digitsOnly.count >= 16 : true;
    }
}
