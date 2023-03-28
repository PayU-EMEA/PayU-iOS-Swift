//
//  Feature.swift
//  Example
//
//  Created by PayU S.A. on 18/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

enum FeatureType: String {
  case demoCVVAuthorization
  case demoPaymentCardScanner
  case demoPaymentCardViewController
  case demoPaymentCardWidget
  case demoApplePay
  case demoPaymentMethods
  case demoPaymentWidget
  case demoSoftAccept
  case demoTheme
  case demoVaryingNumberOfInstallments
  case demoVaryingNumberOfOptions
  case demoWebPaymentsSSL
  case exampleOrder
}

struct Feature: Identifiable {
  var id: String { type.rawValue }

  static let demoApplePay = Feature(title: "Demo / ApplePay", type: .demoApplePay)
  static let demoCVVAuthorization = Feature(title: "Demo / CVV authorization", type: .demoCVVAuthorization)
  static let demoPaymentCardScanner = Feature(title: "Demo / PaymentCardScanner", type: .demoPaymentCardScanner)
  static let demoPaymentCardViewController = Feature(title: "Demo / PaymentCardViewController", type: .demoPaymentCardViewController)
  static let demoPaymentCardWidget = Feature(title: "Demo / PaymentCardWidget", type: .demoPaymentCardWidget)
  static let demoPaymentMethods = Feature(title: "Demo / PaymentMethods", type: .demoPaymentMethods)
  static let demoPaymentMethodsWidget = Feature(title: "Demo / PaymentMethodsWidget", type: .demoPaymentWidget)
  static let demoSoftAccept = Feature(title: "Demo / Soft Accept", type: .demoSoftAccept)
  static let demoTheme = Feature(title: "Demo / Theme", type: .demoTheme)
  static let demoVaryingNumberOfInstallments = Feature(title: "Demo / Mastercard Installments", subtitle: "VARYING_NUMBER_OF_INSTALLMENTS", type: .demoVaryingNumberOfInstallments)
  static let demoVaryingNumberOfOptions = Feature(title: "Demo / Mastercard Installments", subtitle: "VARYING_NUMBER_OF_OPTIONS", type: .demoVaryingNumberOfOptions)
  static let demoWebPaymentsSSL = Feature(title: "Demo / WebPayments (SSL)", type: .demoWebPaymentsSSL)
  static let exampleOrder = Feature(title: "Example / Order", type: .exampleOrder)

  static let all: [Feature] = [
    .demoApplePay,
    .demoCVVAuthorization,
    .demoPaymentCardScanner,
    .demoPaymentCardViewController,
    .demoPaymentCardWidget,
    .demoPaymentMethods,
    .demoPaymentMethodsWidget,
    .demoSoftAccept,
    .demoTheme,
    .demoVaryingNumberOfInstallments,
    .demoVaryingNumberOfOptions,
    .demoWebPaymentsSSL,
    .exampleOrder
  ]

  let title: String
  let subtitle: String?
  let type: FeatureType

  init(title: String, subtitle: String? = nil, type: FeatureType) {
    self.title = title
    self.subtitle = subtitle
    self.type = type
  }
}
