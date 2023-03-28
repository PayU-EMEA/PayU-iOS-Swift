//
//  PaymentMethod.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Interface which represents the payment method
public protocol PaymentMethod {

  /// ``BrandImageProvider`` instance to present the image of the ``PaymentMethod``
  var brandImageProvider: BrandImageProvider { get }

  /// Short representation of details, for ex: "9/2024" for ``CardToken``
  var description: String? { get }

  /// Indicated if the instance is available to be selected
  var enabled: Bool { get }

  /// Name of payment method set by PayU
  var name: String { get }

  /// payType value. Available values are in the [developers.payu.com](https://developers.payu.com/en/overview.html#paymethods)
  var value: String { get }
}

public extension PaymentMethod {
  var formattedDescription: String? {
    return [value, name, description]
      .compactMap { $0 }
      .joined(separator: "\n")
  }
}
