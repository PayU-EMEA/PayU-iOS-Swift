//
//  ApplePayServiceProtocol.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

/// The protocol which defines the behavior for ApplePayService.
public protocol ApplePayServiceProtocol {

  /// Determine whether this device can process payments using *PayU* networks and capabilities bitmask
  ///
  /// Default service checks by:
  ///
  /// - Available capabilities: .capabilityCredit, .capabilityDebit, .capability3DS
  /// - Available networks: .maestro, .masterCard, .visa
  func canMakePayments() -> Bool

  /// Method which invokes Apple Pay to make a transaction
  /// - Parameters:
  ///   - paymentRequest: Instance of ``PaymentRequest``
  ///   - onDidAuthorize: Closure which would be invoked when the transaction completes with success, where the parameter - is `base64EncodedString` of `paymentDataToken`
  ///   - onDidCancel: Closure which would be invoked when the transaction was cancelled
  ///   - onDidFail: Closure which would be invoked when the transaction failed
  func makePayment(
    paymentRequest: PaymentRequest,
    onDidAuthorize: @escaping (String) -> Void,
    onDidCancel: @escaping () -> Void,
    onDidFail: @escaping (Error) -> Void)
}
