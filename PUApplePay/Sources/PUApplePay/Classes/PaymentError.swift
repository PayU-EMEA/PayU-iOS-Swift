//
//  PaymentError.swift
//  
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// An enum which is responsible for the error during payment with Apple Pay
public enum PaymentError: Error {

  /// Should appear in case of unknown Apple Pay state
  case didFailPayment

  /// Should appear when presenting of `PKPaymentAuthorizationController` was not success
  case didFailPresentPaymentController

  /// Should appear as the result when user manually close the instance of `PKPaymentAuthorizationController`
  case didCancelPayment
}
