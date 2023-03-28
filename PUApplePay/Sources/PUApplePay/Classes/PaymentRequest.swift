//
//  PaymentRequest.swift
//  
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// A model which is the adapter for native `PKPaymentRequest`
///
/// Example:
/// ```swift
/// let paymentRequest = PaymentRequest(
///   countryCode: "PL",
///   currencyCode: "PLN",
///   merchantIdentifier: "merchantIdentifier",
///   paymentSummaryItems: [
///     PaymentRequest.SummaryItem(
///       label: "Futomaki",
///       amount: 1599),
///     PaymentRequest.SummaryItem(
///       label: "Napkin",
///       amount: 49),
///     PaymentRequest.SummaryItem(
///       label: "Order",
///       amount: 1599 + 49)
///   ],
///   shippingContact: PaymentRequest.Contact(
///     emailAddress: "email@address.com")
/// )
/// ```
public struct PaymentRequest: Equatable {

  // MARK: - Contact

  /// A model which represents the buyer contact information
  public struct Contact: Equatable {

    // MARK: - Public Properties

    /// The contact’s email address
    public let emailAddress: String

    // MARK: - Initialization
    public init(emailAddress: String) {
      self.emailAddress = emailAddress
    }
  }

  // MARK: - SummaryItem

  /// A model which represents the item, for which buyer is trying to pay
  public struct SummaryItem: Equatable {

    // MARK: - Public Properties

    /// A short localized description of the item, e.g. "Tax" or "Gift Card".
    public let label: String

    /// Value in cents. Same currency as the enclosing ``PaymentRequest``.
    /// Negative values are permitted, for example when redeeming a coupon.
    /// An amount is always required unless the summary item's type is set to pending
    public let amount: UInt

    // MARK: - Initialization
    public init(label: String, amount: UInt) {
      self.label = label
      self.amount = amount
    }
  }

  // MARK: - Public Properties

  /// The merchant’s two-letter ISO 3166 country code. (Ex: "PL")
  public let countryCode: String

  /// The three-letter ISO 4217 currency code. (Ex: "PLN")
  public let currencyCode: String

  /// Identifies the merchant, as previously agreed with Apple.
  /// Must match one of the merchant identifiers in the application's entitlement.
  public let merchantIdentifier: String

  /// List of ``SummaryItem`` objects which should be presented to the user.
  /// The last item should be the total you wish to charge
  public let paymentSummaryItems: [SummaryItem]

  /// A prepopulated shipping address.
  public let shippingContact: Contact

  // MARK: - Initialization
  public init(
    countryCode: String,
    currencyCode: String,
    merchantIdentifier: String,
    paymentSummaryItems: [SummaryItem],
    shippingContact: Contact) {
      self.countryCode = countryCode
      self.currencyCode = currencyCode
      self.merchantIdentifier = merchantIdentifier
      self.shippingContact = shippingContact
      self.paymentSummaryItems = paymentSummaryItems
    }
}
