//
//  Installments.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Model which represent the payment method by Mastercard Installments
public struct Installments: Codable, PaymentMethod {

  // MARK: - Public Properties
  public var brandImageProvider: BrandImageProvider { .url(brandImageUrl) }
  public var description: String? { nil }
  public var enabled: Bool { status == .enabled }

  public let brandImageUrl: String
  public let name: String
  public let status: PayByLink.Status
  public let value: String

  // MARK: - Initialization
  public init(brandImageUrl: String, name: String, status: PayByLink.Status, value: String) {
    self.brandImageUrl = brandImageUrl
    self.name = name
    self.status = status
    self.value = value
  }

  public init(payByLink: PayByLink) {
    self.init(
      brandImageUrl: payByLink.brandImageUrl,
      name: payByLink.name,
      status: payByLink.status,
      value: payByLink.value)
  }
}
