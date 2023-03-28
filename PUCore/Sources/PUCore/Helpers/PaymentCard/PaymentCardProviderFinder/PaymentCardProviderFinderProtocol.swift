//
//  PaymentCardProviderFinderProtocol.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// The protocol which allows to implement different payment card provider search mechanisms
public protocol PaymentCardProviderFinderProtocol {

  /// Method which allows to find  the ``PaymentCardProvider``
  /// - Parameter value: payment card number
  /// - Returns: ``PaymentCardProvider`` instance
  func find(_ value: String) -> PaymentCardProvider?

  /// Method which allows to find  the possible ``PaymentCardProvider`` by first payment card number digits
  /// - Parameter value: payment card number
  /// - Returns: ``PaymentCardProvider`` instance
  func possible(_ value: String) -> PaymentCardProvider?
}
