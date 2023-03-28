//
//  PaymentCardError.swift
//  
//  Created by PayU S.A. on 12/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Allows to declare the exact error during PaymentCard validation
public enum PaymentCardError: Error, LocalizedError {
  public static let emptyCVV = PaymentCardError.error("enter_cvv")
  public static var emptyDate = PaymentCardError.error("enter_card_date")
  public static var emptyNumber = PaymentCardError.error("enter_card_number")

  public static var invalidCVV = PaymentCardError.error("enter_valid_cvv")
  public static var invalidDate = PaymentCardError.error("enter_valid_card_date")
  public static var invalidNumber = PaymentCardError.error("enter_valid_card_number")

  case error(String)

  // MARK: - LocalizedError
  public var errorDescription: String? {
    switch self {
      case .error(let message):
        return message
    }
  }
}
