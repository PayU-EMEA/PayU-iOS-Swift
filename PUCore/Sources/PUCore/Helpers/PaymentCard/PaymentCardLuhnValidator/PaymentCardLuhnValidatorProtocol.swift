//
//  PaymentCardLuhnValidatorProtocol.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// The protocol which allows to implement service for Luhn validation
///
/// <!-- @mockable -->
public protocol PaymentCardLuhnValidatorProtocol {

  /// Method which allows to indicate if `value` card number matches Luhn algorithm
  /// - Parameter value: card number
  /// - Returns: `true`if `value` matches Luhn algorithm
  func matches(_ value: String) -> Bool
}
