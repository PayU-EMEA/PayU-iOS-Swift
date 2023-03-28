//
//  PaymentMethodsWidgetStateDecorator.swift
//
//  Created by PayU S.A. on 23/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

struct PaymentMethodsWidgetStateDecoratorFactory {
  func decorator(_ state: PaymentMethodsWidgetState) -> PaymentMethodsWidgetStateDecorator {
    switch state {
      case .initial:
        return InitialStateDecorator()
      case .blikCode(let paymentMethod):
        return BlikCodeStateDecorator(paymentMethod: paymentMethod)
      case .blikToken(let paymentMethod):
        return BlikTokenStateDecorator(paymentMethod: paymentMethod)
      case .paymentMethod(let paymentMethod):
        return PaymentMethodStateDecorator(paymentMethod: paymentMethod)
    }
  }
}

protocol PaymentMethodsWidgetStateDecorator {
  var title: String? { get }
  var subtitle: String? { get }
  var logo: BrandImageProvider? { get }

  var isPaymentMethodTitleVisible: Bool { get }
  var isPaymentMethodSubtitleVisible: Bool { get }
  var isPaymentMethodLogoVisible: Bool { get }

  var isBlikTokenButtonVisible: Bool { get }
  var isBlikCodeTextInputViewVisible: Bool { get }
}

extension PaymentMethodsWidgetStateDecorator {
  var isPaymentMethodTitleVisible: Bool { title != nil }
  var isPaymentMethodSubtitleVisible: Bool { subtitle != nil }
  var isPaymentMethodLogoVisible: Bool { logo != nil }
}

// MARK: - InitialStateDecorator
private struct InitialStateDecorator: PaymentMethodsWidgetStateDecorator {
  var title: String? { "select_payment_method".localized() }
  var subtitle: String? { nil }
  var logo: BrandImageProvider? { nil }

  var isBlikTokenButtonVisible: Bool { false }
  var isBlikCodeTextInputViewVisible: Bool { false }
}

// MARK: - BlikCodeStateDecorator
private struct BlikCodeStateDecorator: PaymentMethodsWidgetStateDecorator {
  var title: String? { paymentMethod.name }
  var subtitle: String? { paymentMethod.description }
  var logo: BrandImageProvider? { paymentMethod.brandImageProvider }

  var isBlikTokenButtonVisible: Bool { true }
  var isBlikCodeTextInputViewVisible: Bool { false }

  let paymentMethod: PaymentMethod
}

// MARK: - PaymentMethodsBlikTokenStateDecorator
private struct BlikTokenStateDecorator: PaymentMethodsWidgetStateDecorator {
  var title: String? { paymentMethod.name }
  var subtitle: String? { paymentMethod.description }
  var logo: BrandImageProvider? { paymentMethod.brandImageProvider }

  var isBlikTokenButtonVisible: Bool { false }
  var isBlikCodeTextInputViewVisible: Bool { true }

  let paymentMethod: PaymentMethod
}

// MARK: - PaymentMethodsPaymentMethodStateDecorator
private struct PaymentMethodStateDecorator: PaymentMethodsWidgetStateDecorator {
  var title: String? { paymentMethod.name }
  var subtitle: String? { paymentMethod.description }
  var logo: BrandImageProvider? { paymentMethod.brandImageProvider }

  var isBlikTokenButtonVisible: Bool { false }
  var isBlikCodeTextInputViewVisible: Bool { false }

  let paymentMethod: PaymentMethod
}
