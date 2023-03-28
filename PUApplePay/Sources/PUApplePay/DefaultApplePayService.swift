//
//  DefaultApplePayService.swift
//
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import PassKit

final class DefaultApplePayService: NSObject, ApplePayServiceProtocol {

  // MARK: - Status
  private enum Status {
    case didStartPayment
    case didPresentAuthorization
    case willAuthorizePayment
    case didAuthorizePayment
  }

  // MARK: - Private Properties
  private var status: Status!

  private var onDidAuthorize: ((String) -> Void)?
  private var onDidCancel: (() -> Void)?
  private var onDidFail: ((Error) -> Void)?

  // MARK: - ApplePayServiceProtocol
  func canMakePayments() -> Bool {
    return PKPaymentAuthorizationController.canMakePayments(
      usingNetworks: PKPaymentNetwork.networks(),
      capabilities: PKMerchantCapability.capabilities())
  }

  func makePayment(
    paymentRequest: PaymentRequest,
    onDidAuthorize: @escaping (String) -> Void,
    onDidCancel: @escaping () -> Void,
    onDidFail: @escaping (Error) -> Void) {

      self.onDidAuthorize = onDidAuthorize
      self.onDidCancel = onDidCancel
      self.onDidFail = onDidFail

      status = .didStartPayment

      let paymentRequest = PKPaymentRequest.Builder()
        .withCountryCode(paymentRequest.countryCode)
        .withCurrencyCode(paymentRequest.currencyCode)
        .withMerchantIdentifier(paymentRequest.merchantIdentifier)
        .withShippingContact(paymentRequest.shippingContact)
        .withPaymentSummaryItems(paymentRequest.paymentSummaryItems)
        .build()

      let authorizationController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
      authorizationController.delegate = self
      authorizationController.present { [weak self] isPresented in
        guard let self = self else { return }

        if isPresented {
          self.status = .didPresentAuthorization
        } else {
          self.onDidFail?(PaymentError.didFailPresentPaymentController)
        }
      }
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension DefaultApplePayService: PKPaymentAuthorizationControllerDelegate {
  func paymentAuthorizationControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationController) {
    status = .willAuthorizePayment
  }

  func paymentAuthorizationController(
    _ controller: PKPaymentAuthorizationController,
    didAuthorizePayment payment: PKPayment,
    handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

      status = .didAuthorizePayment
      completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
      let paymentDataToken = payment.token.paymentData.base64EncodedString()
      onDidAuthorize?(paymentDataToken)
    }

  func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    controller.dismiss { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        switch self.status {
          case .didPresentAuthorization:
            self.onDidCancel?()
            break
          case .willAuthorizePayment:
            self.onDidFail?(PaymentError.didFailPayment)
            break
          default:
            break
        }
      }
    }
  }
}

