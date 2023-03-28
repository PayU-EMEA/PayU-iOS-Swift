//
//  BlikCode.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Model which represent the payment method by BLIK
public struct BlikCode: PaymentMethod {

  // MARK: - Public Properties
  public var brandImageProvider: BrandImageProvider { .blik }
  public let description: String? = nil
  public let enabled: Bool = true
  public let name: String = "BLIK"
  public let value: String = PaymentMethodValue.blikCode

  public let authorizationCode: String?

  // MARK: - Initialization
  public init(authorizationCode: String? = nil) {
    self.authorizationCode = authorizationCode
  }

  // MARK: - Public Methods
  public func copyWith(authorizationCode: String?) -> BlikCode {
    BlikCode(authorizationCode: authorizationCode)
  }
}
