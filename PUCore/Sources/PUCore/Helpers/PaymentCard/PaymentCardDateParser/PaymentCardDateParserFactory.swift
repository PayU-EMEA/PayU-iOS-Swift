//
//  PaymentCardDateParserFactory.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``PaymentCardDateParserProtocol`` instances
public struct PaymentCardDateParserFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Returns default implementation for ``PaymentCardDateParserProtocol``service
  /// Default implementation supprorts formats: "MM/yy", "MM/yyyy"
  public func make() -> PaymentCardDateParserProtocol {
    DefaultPaymentCardDateParser()
  }

}
