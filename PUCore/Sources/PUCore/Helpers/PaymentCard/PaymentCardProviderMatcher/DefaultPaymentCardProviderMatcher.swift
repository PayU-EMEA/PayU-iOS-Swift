//
//  DefaultPaymentCardProviderMatcher.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct DefaultPaymentCardProviderMatcher: PaymentCardProviderMatcherProtocol {

  // MARK: - Public Properties
  let provider: PaymentCardProvider
  private let lengths: [Int]
  private let pattern: String

  // MARK: - Initialization
  init(provider: PaymentCardProvider, lengths: [Int], pattern: String) {
    self.provider = provider
    self.lengths = lengths
    self.pattern = pattern
  }

  // MARK: - Public Methods
  func matches(_ value: String) -> Bool {
    let matchesLength = lengths.contains(where: { $0 == value.digitsOnly.count })
    let matchesPattern = value ~= pattern
    return matchesLength && matchesPattern
  }

  func possible(_ value: String) -> Bool {
    value *= pattern
  }
}
