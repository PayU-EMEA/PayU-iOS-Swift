//
//  PaymentCardProviderMatcherFactory.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``PaymentCardProviderMatcherProtocol`` instances
public struct PaymentCardProviderMatcherFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Returns default  implementation for ``PaymentCardProvider/maestro`` matcher
  public func make() -> [PaymentCardProviderMatcherProtocol] {
    [makeMaestro(), makeMastercard(), makeVisa()]
  }

  /// Returns default  implementation for ``PaymentCardProvider/maestro`` matcher
  public func makeMaestro() -> PaymentCardProviderMatcherProtocol {
    DefaultPaymentCardProviderMatcher(
      provider: .maestro,
      lengths: [Int](12...19),
      pattern: "^(06|5[0678]|6)")
  }

  /// Returns default  implementation for ``PaymentCardProvider/mastercard`` matcher
  public func makeMastercard() -> PaymentCardProviderMatcherProtocol {
    DefaultPaymentCardProviderMatcher(
      provider: .mastercard,
      lengths: [16],
      pattern: "^(5[1-5]|2[2-7])")
  }

  /// Returns default  implementation for ``PaymentCardProvider/visa`` matcher
  public func makeVisa() -> PaymentCardProviderMatcherProtocol {
    DefaultPaymentCardProviderMatcher(
      provider: .visa,
      lengths: [13, 16],
      pattern: "^4")
  }

}
