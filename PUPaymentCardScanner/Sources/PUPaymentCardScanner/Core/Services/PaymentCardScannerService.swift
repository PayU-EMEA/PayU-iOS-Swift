//
//  PaymentCardScannerService.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

#if canImport(PUCore)
import PUCore
#endif

final class PaymentCardScannerService {

  // MARK: - Public Properties
  private(set) var result: PaymentCardScannerResult

  // MARK: - Private Properties
  private let paymentCardDateFormatter: PaymentCardFormatterProtocol
  private let paymentCardDateValidator: PaymentCardValidatorProtocol
  private let paymentCardNumberFormatter: PaymentCardFormatterProtocol
  private let paymentCardNumberValidator: PaymentCardValidatorProtocol

  // MARK: - Initialization
  init(
    option: PaymentCardScannerOption,
    paymentCardDateFormatter: PaymentCardFormatterProtocol,
    paymentCardDateValidator: PaymentCardValidatorProtocol,
    paymentCardNumberFormatter: PaymentCardFormatterProtocol,
    paymentCardNumberValidator: PaymentCardValidatorProtocol
  ) {
    self.result = PaymentCardScannerResult(option: option)
    self.paymentCardDateFormatter = paymentCardDateFormatter
    self.paymentCardDateValidator = paymentCardDateValidator
    self.paymentCardNumberFormatter = paymentCardNumberFormatter
    self.paymentCardNumberValidator = paymentCardNumberValidator
  }

  // MARK: - Public Methods
  func isProcessed() -> Bool {
    result.isProcessed
  }

  @discardableResult
  func process(_ recognizedText: String) -> Bool {
    processCardNumber(recognizedText)
    processCardExpirationDate(recognizedText)
    return isProcessed()
  }

  // MARK: - Private Methods
  private func processCardNumber(_ recognizedText: String) {
    guard result.cardNumber == nil else { return }

    do {
      try paymentCardNumberValidator.validate(recognizedText)
      let cardNumber = paymentCardNumberFormatter.formatted(recognizedText)
      result = result.copyWith(cardNumber: cardNumber)
    } catch {  }
  }

  private func processCardExpirationDate(_ recognizedText: String) {
    guard result.cardExpirationDate == nil else { return }

    do {
      try paymentCardDateValidator.validate(recognizedText)
      let cardExpirationDate = paymentCardDateFormatter.formatted(recognizedText)
      result = result.copyWith(cardExpirationDate: cardExpirationDate)
    } catch {  }
  }

}
