//
//  PaymentCardValidatorFactory.swift
//  
//  Created by PayU S.A. on 22/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``PaymentCardValidatorProtocol`` instances
public struct PaymentCardValidatorFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods

  /// Returns default  implementation for `cvv` validation
  public func makeCVV() -> PaymentCardValidatorProtocol {
    DefaultPaymentCardCVVValidator()
  }

  /// Returns default  implementation for `date` validation
  public func makeDate(dateParser: PaymentCardDateParserProtocol) -> PaymentCardValidatorProtocol {
    DefaultPaymentCardDateValidator(dateParser: dateParser)
  }

  /// Returns default  implementation for `number` validation
  public func makeNumber(providerFinder: PaymentCardProviderFinderProtocol) -> PaymentCardValidatorProtocol {
    DefaultPaymentCardNumberValidator(providerFinder: providerFinder)
  }

}
