//
//  CardToken.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Model which represent the payment method by payment card
public struct CardToken: Codable, PaymentMethod, Equatable {

  // MARK: - Status
  public enum Status: String, Codable, Equatable {
    case active = "ACTIVE"
    case expired = "EXPIRED"
  }

  // MARK: - Public Properties
  public var brandImageProvider: BrandImageProvider { .url(brandImageUrl) }
  public var description: String? { "\(cardExpirationMonth)/\(cardExpirationYear)" }
  public var enabled: Bool { status == .active }
  public var name: String { cardNumberMasked }

  public let brandImageUrl: String
  public let cardExpirationMonth: Int
  public let cardExpirationYear: Int
  public let cardNumberMasked: String
  public let cardScheme: String?
  public let preferred: Bool
  public let status: CardToken.Status
  public let value: String

  // MARK: - Initializiation
  public init(
    brandImageUrl: String,
    cardExpirationMonth: Int,
    cardExpirationYear: Int,
    cardNumberMasked: String,
    cardScheme: String?,
    preferred: Bool,
    status: CardToken.Status,
    value: String) {
      self.brandImageUrl = brandImageUrl
      self.cardExpirationMonth = cardExpirationMonth
      self.cardExpirationYear = cardExpirationYear
      self.cardNumberMasked = cardNumberMasked
      self.cardScheme = cardScheme
      self.preferred = preferred
      self.status = status
      self.value = value
    }
}
