//
//  PaymentCardScannerAssembler.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

#if canImport(PUCore)
import PUCore
#endif

@available(iOS 13.0, *)
final class PaymentCardScannerAssembler {

  func makePaymentCardDateParser() -> PaymentCardDateParserProtocol {
    PaymentCardDateParserFactory().make()
  }

  func makePaymentCardFormatterDate() -> PaymentCardFormatterProtocol {
    PaymentCardFormatterFactory().makeDate()
  }

  func makePaymentCardFormatterNumber() -> PaymentCardFormatterProtocol {
    PaymentCardFormatterFactory().makeNumber()
  }

  func makePaymentCardLuhnValidator() -> PaymentCardLuhnValidatorProtocol {
    PaymentCardLuhnValidatorFactory().make()
  }

  func makePaymentCardProviderFinder() -> PaymentCardProviderFinderProtocol {
    PaymentCardProviderFinderFactory().make(luhnValidator: makePaymentCardLuhnValidator())
  }

  func makePaymentCardValidatorDate() -> PaymentCardValidatorProtocol {
    PaymentCardValidatorFactory().makeDate(dateParser: makePaymentCardDateParser())
  }

  func makePaymentCardValidatorNumber() -> PaymentCardValidatorProtocol {
    PaymentCardValidatorFactory().makeNumber(providerFinder: makePaymentCardProviderFinder())
  }

  func makePaymentCardScannerService(option: PaymentCardScannerOption) -> PaymentCardScannerService {
    PaymentCardScannerService(
      option: option,
      paymentCardDateFormatter: makePaymentCardFormatterDate(),
      paymentCardDateValidator: makePaymentCardValidatorDate(),
      paymentCardNumberFormatter: makePaymentCardFormatterNumber(),
      paymentCardNumberValidator: makePaymentCardValidatorNumber())
  }


  func makePaymentCardScannerViewController(option: PaymentCardScannerOption) -> PaymentCardScannerViewController {
    PaymentCardScannerViewController(service: makePaymentCardScannerService(option: option))
  }

}
