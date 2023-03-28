//
//  PaymentMethodsProcessor.swift
//  
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUApplePay)
import PUApplePay
#endif

#if canImport(PUCore)
import PUCore
#endif

/// Protocol which defines the behavior for implementation
public protocol PaymentMethodsProcessorProtocol {

  /// ``PaymentMethodsProcessorApplePayPaymentRequestProvider`` instance which needs to provide `PaymentRequest` instance
  var applePayPaymentRequestProvider: PaymentMethodsProcessorApplePayPaymentRequestProvider? { set get }

  /// ``PaymentMethodsProcessorBlikAuthorizationCodePresenter`` instance which needs to provide `presentingViewController`
  var blikAuthorizationCodePresenter: PaymentMethodsProcessorBlikAuthorizationCodePresenter? { set get }


  /// Call this method when there is a need to convert `PaymentMethod` into `PayMethod` (See `PUCore` for details)
  /// - Parameters:
  ///   - paymentMethod: `PaymentMethod` which needs to be processed
  ///   - onDidProcess: `completionHandler` which will be called as soon as `paymentMethod` process. For ex. `CardToken` will be immediately processed into proper `PayMethod` and `BlikCode` without `authorizationCode` will present middleware view controller to give user ability to enter it.
  ///   - onDidFail: `completionHandler` which will be called there was an error during the processing
  func process(
    paymentMethod: PaymentMethod,
    onDidProcess: @escaping (PayMethod) -> Void,
    onDidFail: @escaping (Error) -> Void)
}

/// Protocol which defines the `paymentRequest` for ``PaymentMethodsProcessor``
public protocol PaymentMethodsProcessorApplePayPaymentRequestProvider: AnyObject {

  /// Implementation must return the instance of `PaymentRequest` class. See more details in `PUApplePay` package.
  /// - Returns: `PaymentRequest` instance
  func paymentRequest() -> PaymentRequest
}

/// Protocol which defines the `presentingViewController` for ``PaymentMethodsProcessor``
public protocol PaymentMethodsProcessorBlikAuthorizationCodePresenter: AnyObject {

  /// Implementation must return the instance of `UIViewController` class, from which the BLIK alert view controller
  /// - Returns: `UIViewController` instance as a `presentingViewController`for BLIK alert view controller
  func presentingViewController() -> UIViewController?
}

/// Class which allows to process `PaymentMethod` received from the backend into `PayMethod` which is needed for `OrderCreateRequest`.
/// It automatically handles all the steps required to process Apple Pay, BLIK, etc. by presenting necessary view controllers and presenters
public final class PaymentMethodsProcessor: PaymentMethodsProcessorProtocol {

  // MARK: - Factory
  /// Factory which allows to create the ``PaymentMethodsProcessor`` instance
  public struct Factory {

    // MARK: - Private Properties
    private let assembler = PaymentMethodsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``PaymentMethodsProcessor``
    /// - Returns: Default implementation for ``PaymentMethodsProcessor``
    public func make() -> PaymentMethodsProcessor {
      assembler.makePaymentMethodsProcessor()
    }
  }

  // MARK: - Public Properties
  public weak var applePayPaymentRequestProvider: PaymentMethodsProcessorApplePayPaymentRequestProvider?
  public weak var blikAuthorizationCodePresenter: PaymentMethodsProcessorBlikAuthorizationCodePresenter?

  // MARK: - Private Properties
  private var onDidProcess: ((PayMethod) -> Void)?
  private var onDidFail: ((Error) -> Void)?

  private let applePayService: ApplePayServiceProtocol
  private let blikAlertViewControllerPresenter: BlikAlertViewControllerPresenterProtocol

  // MARK: - Initialization
  init(
    applePayService: ApplePayServiceProtocol,
    blikAlertViewControllerPresenter: BlikAlertViewControllerPresenterProtocol) {
      self.applePayService = applePayService
      self.blikAlertViewControllerPresenter = blikAlertViewControllerPresenter
    }

  // MARK: - PaymentMethodsProcessorProtocol
  public func process(
    paymentMethod: PaymentMethod,
    onDidProcess: @escaping (PayMethod) -> Void,
    onDidFail: @escaping (Error) -> Void
  ) {
    self.onDidProcess = onDidProcess
    self.onDidFail = onDidFail

    switch paymentMethod {
      case is ApplePay:
        guard let paymentRequest = applePayPaymentRequestProvider?.paymentRequest() else { return }

        applePayService.makePayment(
          paymentRequest: paymentRequest,
          onDidAuthorize: onDidAuthorizeApplePay,
          onDidCancel: onDidCancelApplePay,
          onDidFail: onDidFailApplePay)

      case let blikCode as BlikCode:
        blikCode.authorizationCode == nil
        ? processBlikCodeWithoutAuthorizationCode(blikCode)
        : processBlikCodeWithAuthorizationCode(blikCode)

      case let blikToken as BlikToken:
        onDidProcess(
          PayMethod(
            type: .blikToken,
            value: blikToken.value))

      case let cardToken as CardToken:
        onDidProcess(
          PayMethod(
            type: .cardToken,
            value: cardToken.value))

      case let installments as Installments:
        onDidProcess(
          PayMethod(
            type: .pbl,
            value: installments.value))


      case let payByLink as PayByLink:
        onDidProcess(
          PayMethod(
            type: .pbl,
            value: payByLink.value))

      default:
        break
    }
  }

  // MARK: - Private Methods
  private func processBlikCodeWithAuthorizationCode(_ blikCode: BlikCode) {
    guard let blikAuthorizationCode = blikCode.authorizationCode else { return }
    onDidProcess?(
      PayMethod(
        type: .blikToken,
        authorizationCode: blikAuthorizationCode))
  }

  private func processBlikCodeWithoutAuthorizationCode(_ blikCode: BlikCode) {
    guard let presentingViewController = blikAuthorizationCodePresenter?.presentingViewController() else { return }
    blikAlertViewControllerPresenter.presentBlikAlertViewController(
      from: presentingViewController,
      onDidConfirm: onDidConfirmBlik,
      onDidCancel: onDidCancelBlik)
  }

  // MARK: - Handlers
  private func onDidAuthorizeApplePay(_ paymentDataToken: String) {
    onDidProcess?(
      PayMethod(
        type: .pbl,
        value: PaymentMethodValue.applePay,
        authorizationCode: paymentDataToken))
  }

  private func onDidCancelApplePay() {  }

  private func onDidFailApplePay(_ error: Error) {
    onDidFail?(error)
  }

  private func onDidConfirmBlik(_ blikAuthorizationCode: String) {
    onDidProcess?(
      PayMethod(
        type: .blikToken,
        authorizationCode: blikAuthorizationCode))

  }

  private func onDidCancelBlik() {  }
}
