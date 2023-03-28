//
//  PaymentCardScannerResult.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

/// Model, which contains the data about the recognized payment card
public struct PaymentCardScannerResult: Equatable {

  // MARK: - Public Properties

  /// The ``PaymentCardScannerOption`` value, which indicates the strategy how to scan the payment card
  public let option: PaymentCardScannerOption

  /// Recognized payment card number
  public let cardNumber: String?

  /// Recognized payment card expiration date in "MM/yy" or "MM/yyyy" format
  public let cardExpirationDate: String?

  var isProcessed: Bool {
    switch option {
      case .number:
        return cardNumber != nil
      case .numberAndDate:
        return cardNumber != nil && cardExpirationDate != nil
    }
  }

  var isProcessedAtLeastOneParameter: Bool {
    cardNumber != nil || cardExpirationDate != nil
  }

  // MARK: - Initialization
  init(option: PaymentCardScannerOption, cardNumber: String? = nil, cardExpirationDate: String? = nil) {
    self.option = option
    self.cardNumber = cardNumber
    self.cardExpirationDate = cardExpirationDate
  }

  // MARK: - Public Methods
  func copyWith(cardNumber: String) -> PaymentCardScannerResult {
    return PaymentCardScannerResult(
      option: option,
      cardNumber: cardNumber,
      cardExpirationDate: cardExpirationDate)
  }

  func copyWith(cardExpirationDate: String) -> PaymentCardScannerResult {
    return PaymentCardScannerResult(
      option: option,
      cardNumber: cardNumber,
      cardExpirationDate: cardExpirationDate)
  }

}
