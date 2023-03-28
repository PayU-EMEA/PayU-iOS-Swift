//
//  PaymentCardProviderMatcherProtocol.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// The protocol which allows to understand if payment card matches any of ``PaymentCardProvider``
public protocol PaymentCardProviderMatcherProtocol {

  /// Indicates the ``PaymentCardProvider`` assosiated with current matcher
  var provider: PaymentCardProvider { get }


  /// Method which allows to indicate if `value` card number matches any of ``PaymentCardProvider``
  /// - Parameter value: card number
  /// - Returns: `true`if `value` matches Luhn algorithm
  func matches(_ value: String) -> Bool

  /// Method which allows to indicate if `value` card number is possible any of ``PaymentCardProvider``
  /// - Parameter value: card number
  /// - Returns: `true`if `value` is possible any of ``PaymentCardProvider``
  func possible(_ value: String) -> Bool
}
