//
//  PaymentMethodsConfiguration.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

#if canImport(PUCore)
import PUCore
#endif

/// Allows to setup the configuration how to display the payment methods
public struct PaymentMethodsConfiguration: Equatable {

  // MARK: - Public Properties

  /// The list of `blikTokens` received from the backend
  public let blikTokens: [BlikToken]?

  /// The list of `cardTokens` received from the backend
  public let cardTokens: [CardToken]

  /// The list of `payByLinks` received from the backend
  public let payByLinks: [PayByLink]

  /// Indicates if to give user ability to add new payment card
  public let enableAddCard: Bool

  /// Indicates if to give user ability to pay by `PayByLink`
  public let enablePayByLinks: Bool

  // MARK: - Private Properties
  private let allCardTokens: [CardToken]
  private let allPayByLinks: [PayByLink]

  private let showExpiredCards: Bool
  private let showDisabledPayByLinks: Bool

  // MARK: - Initialization
  public init(
    blikTokens: [BlikToken]? = nil,
    cardTokens: [CardToken] = [],
    payByLinks: [PayByLink] = [],
    enableAddCard: Bool = true,
    enablePayByLinks: Bool = true,
    showExpiredCards: Bool = false,
    showDisabledPayByLinks: Bool = false) {

      self.blikTokens = blikTokens
      self.cardTokens = cardTokens.filter { showExpiredCards ? true : $0.status == .active }
      self.payByLinks = payByLinks.filter { showDisabledPayByLinks ? true : $0.status == .enabled }

      self.enableAddCard = enableAddCard
      self.enablePayByLinks = enablePayByLinks

      self.allCardTokens = cardTokens
      self.allPayByLinks = payByLinks

      self.showExpiredCards = showExpiredCards
      self.showDisabledPayByLinks = showDisabledPayByLinks
    }

  func copyWith(_ cardToken: CardToken) -> PaymentMethodsConfiguration {
    var updatedCardTokens = allCardTokens
    updatedCardTokens.append(cardToken)

    return PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: updatedCardTokens,
      payByLinks: payByLinks,
      enableAddCard: enableAddCard,
      enablePayByLinks: enablePayByLinks,
      showExpiredCards: showExpiredCards,
      showDisabledPayByLinks: showDisabledPayByLinks
    )
  }
}
