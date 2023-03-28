//
//  PaymentCardProvider.swift
//  
//  Created by PayU S.A. on 12/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

/// Allows to identify the payment card provider such as: ``maestro``,  ``mastercard``, ``visa``
public struct PaymentCardProvider: Equatable {

  // MARK: - ProviderType

  /// Allows to define the type of the provider
  public enum ProviderType: Int {
    case maestro, mastercard, visa
  }

  // MARK: - Providers
  public static let all: [PaymentCardProvider] = [.maestro, .mastercard, .visa]
  
  public static let maestro = PaymentCardProvider(brandImageProvider: .maestro, type: .maestro, scheme: "MC")
  public static let mastercard = PaymentCardProvider(brandImageProvider: .mastercard, type: .mastercard, scheme: "MC")
  public static let visa = PaymentCardProvider(brandImageProvider: .visa, type: .visa, scheme: "VS")

  // MARK: - Public Properties
  public let brandImageProvider: BrandImageProvider
  public let type: ProviderType
  public var scheme: String

  // MARK: - Initialization
  private init(brandImageProvider: BrandImageProvider, type: ProviderType, scheme: String) {
    self.brandImageProvider = brandImageProvider
    self.type = type
    self.scheme = scheme
  }

  // MARK: - Equatable
  public static func ==(lhs: PaymentCardProvider, rhs: PaymentCardProvider) -> Bool { lhs.type == rhs.type }

}
