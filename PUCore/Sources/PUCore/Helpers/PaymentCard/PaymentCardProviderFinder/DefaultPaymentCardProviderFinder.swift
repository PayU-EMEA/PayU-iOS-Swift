//
//  DefaultPaymentCardProviderFinder.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct DefaultPaymentCardProviderFinder: PaymentCardProviderFinderProtocol {

  // MARK: - Private Properties
  private let luhnValidator: PaymentCardLuhnValidatorProtocol
  private let providerMatchers = PaymentCardProviderMatcherFactory().make()

  // MARK: - Initialization
  init(luhnValidator: PaymentCardLuhnValidatorProtocol) {
    self.luhnValidator = luhnValidator
  }

  // MARK: - PaymentCardProviderFinderProtocol
  func find(_ value: String) -> PaymentCardProvider? {
    guard luhnValidator.matches(value) else { return nil }

    for providerMatcher in providerMatchers {
      if providerMatcher.matches(value) {
        return providerMatcher.provider
      }
    }

    return nil
  }

  func possible(_ value: String) -> PaymentCardProvider? {
    for providerMatcher in providerMatchers {
      if providerMatcher.possible(value) {
        return providerMatcher.provider
      }
    }

    return nil
  }

}
