//
//  PaymentCardProviderFinderFactory.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``PaymentCardProviderFinderProtocol`` instances
public struct PaymentCardProviderFinderFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Returns default implementation for ``PaymentCardProviderFinderProtocol`` service
  public func make(luhnValidator: PaymentCardLuhnValidatorProtocol) -> PaymentCardProviderFinderProtocol {
    DefaultPaymentCardProviderFinder(luhnValidator: luhnValidator)
  }

}
