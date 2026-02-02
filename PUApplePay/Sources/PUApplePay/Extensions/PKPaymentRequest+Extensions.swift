//
//  PKPaymentRequestBuilder.swift
//  
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import PassKit

extension PKPaymentRequest {

  // MARK: - Builder
  final class Builder {

    // MARK: - Private Properties
    private let request = PKPaymentRequest()

    // MARK: - Public Methods
    @discardableResult
    func withMerchantIdentifier(_ merchantIdentifier: String) -> Builder {
      request.merchantIdentifier = merchantIdentifier
      return self
    }

    @discardableResult
    func withCountryCode(_ countryCode: String) -> Builder {
      request.countryCode = countryCode
      return self
    }

    @discardableResult
    func withCurrencyCode( _ currencyCode: String) -> Builder {
      request.currencyCode = currencyCode
      return self
    }

    @discardableResult
    func withShippingContact(_ shippingContact: PaymentRequest.Contact?) -> Builder {
      guard let shippingContact = shippingContact else { return self }
      let contact = PKContact()
      contact.emailAddress = shippingContact.emailAddress
      request.requiredShippingContactFields = [.emailAddress]
      request.shippingContact = contact
      return self
    }

    @discardableResult
    func withPaymentSummaryItems(_ paymentSummaryItems: [PaymentRequest.SummaryItem]) -> Builder {
      request.paymentSummaryItems = paymentSummaryItems.map {
        PKPaymentSummaryItem(
          label: $0.label,
          amount: NSDecimalNumber(
            mantissa: UInt64(exactly: NSNumber(value: $0.amount)) ?? 0,
            exponent: -2,
            isNegative: false),
          type: .final) }
      return self
    }

    func build() -> PKPaymentRequest {
      request.supportedNetworks = PKPaymentNetwork.networks()
      request.merchantCapabilities = PKMerchantCapability.capabilities()
      return request
    }
  }
}

