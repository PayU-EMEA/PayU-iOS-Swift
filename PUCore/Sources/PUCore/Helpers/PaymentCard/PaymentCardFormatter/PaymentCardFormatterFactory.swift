//
//  PaymentCardFormatterFactory.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``PaymentCardFormatterProtocol`` instances
public struct PaymentCardFormatterFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Returns default implementation for ``PaymentCardFormatterProtocol``service
  /// Default implementation supprorts formats: "###"
  public func makeCVV() -> PaymentCardFormatterProtocol {
    DefaultPaymentCardFormatter(mask: "###")
  }

  /// Returns default implementation for ``PaymentCardFormatterProtocol``service
  /// Default implementation supprorts formats: "##/####"
  public func makeDate() -> PaymentCardFormatterProtocol {
    DefaultPaymentCardFormatter(mask: "##/####")
  }

  /// Returns default implementation for ``PaymentCardFormatterProtocol``service
  /// Default implementation supprorts formats: "#### #### #### #### ###"
  public func makeNumber() -> PaymentCardFormatterProtocol {
    DefaultPaymentCardFormatter(mask: "#### #### #### #### ####")
  }

}
