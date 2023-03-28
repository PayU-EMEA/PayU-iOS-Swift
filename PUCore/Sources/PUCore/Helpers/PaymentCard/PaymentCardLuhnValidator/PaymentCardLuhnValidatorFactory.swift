//
//  PaymentCardLuhnValidatorFactory.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``PaymentCardLuhnValidatorProtocol`` instances
public struct PaymentCardLuhnValidatorFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Returns default  implementation for ``PaymentCardLuhnValidatorProtocol``
  /// Default implementation is: [Documentation](https://en.wikipedia.org/wiki/Luhn_algorithm)
  ///
  /// ```swift
  /// let validator = PaymentCardLuhnValidatorFactory().make()
  /// validator.matches("4444 3333 2222 1111") // true
  /// validator.matches("0000 0000 0000 0000") // false
  /// ```
  public func make() -> PaymentCardLuhnValidatorProtocol {
    DefaultPaymentCardLuhnValidator()
  }

}
