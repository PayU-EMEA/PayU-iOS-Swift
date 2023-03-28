//
//  PayByLink.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// PayByLinks are payment methods which always require redirection of the user.
/// Therefore this section includes online bank transfers (pay-by-links), traditional bank transfer,
/// installments and non-tokenized cards.
public struct PayByLink: Codable, PaymentMethod, Equatable {

  // MARK: - Status
  public enum Status: String, Codable, Equatable {
    case enabled = "ENABLED"
    case disabled = "DISABLED"
    case temporaryDisabled = "TEMPORARY_DISABLED"
  }

  // MARK: - Public Properties
  public var brandImageProvider: BrandImageProvider { .url(brandImageUrl) }
  public var description: String? { nil }
  public var enabled: Bool { status == .enabled }

  public let brandImageUrl: String
  public let name: String
  public let status: PayByLink.Status
  public let value: String
}
