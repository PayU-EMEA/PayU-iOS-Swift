//
//  BlikToken.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Model which represent the payment method by existing BLIK token
public struct BlikToken: Codable, PaymentMethod, Equatable {

  // MARK: - Public Properties
  public var brandImageProvider: BrandImageProvider { .url(brandImageUrl) }
  public var description: String? { nil }
  public var enabled: Bool { true }
  public var name: String { "BLIK" }

  public let brandImageUrl: String
  public let type: String
  public let value: String
}
