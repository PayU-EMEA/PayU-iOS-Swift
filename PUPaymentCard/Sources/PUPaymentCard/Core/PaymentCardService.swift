//
//  PaymentCardService.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUPaymentCardScanner)
import PUPaymentCardScanner
#endif

#if canImport(PUTheme)
import PUTheme
#endif

/// The protocol which is the abstraction between user interface and API
public protocol PaymentCardServiceProtocol {
  /// Method to tokenize the payment card details entered by user in the ``PaymentCardWidget``
  /// - Parameters:
  ///   - agreement: In case you do not want PayU store payment card for future payments, set it to **false**.
  ///   - completionHandler: `completionHandler` which will be called as the result of method
  func tokenize(agreement: Bool, completionHandler: @escaping (Result<CardToken, Error>) -> Void)


  /// Method to scan the payment card details
  /// - Parameters:
  ///   - option: `PaymentCardScannerOption` value
  ///   - presentingViewController: viewController, from which oyu would like to present the `PaymentCardScannerViewController`
  func scan(option: PaymentCardScannerOption, in presentingViewController: UIViewController)
}

protocol PaymentCardServiceInternalProtocol: PaymentCardServiceProtocol {
  var delegate: PaymentCardServiceDelegate? { set get }
  var paymentCardProvider: PaymentCardProvider? { get }

  func didChangeCVV(_ value: String)
  func didChangeDate(_ value: String)
  func didChangeNumber(_ value: String)
  func didChangePaymentCard(_ paymentCard: PaymentCard)
  func didTapHintCVV()
}

protocol PaymentCardServiceDelegate: AnyObject {
  func paymentCardServiceShouldValidate(_ service: PaymentCardService) throws
  func paymentCardServiceShouldUpdate(_ service: PaymentCardService)
  func paymentCardServiceShouldUpdatePaymentCardProvider(_ service: PaymentCardService)
}

/// Default implementation for ``PaymentCardServiceProtocol`` service
public final class PaymentCardService: PaymentCardServiceProtocol, PaymentCardServiceInternalProtocol {

  // MARK: - Factory
  /// Factory which allows to create the ``PaymentCardServiceProtocol`` instance
  public struct Factory {

    // MARK: - Private Properties
    private let assembler = PaymentCardAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``PaymentCardServiceProtocol``service
    public func make() -> PaymentCardServiceProtocol {
      assembler.makePaymentCardService()
    }
  }

  // MARK: - Public Properties
  weak var delegate: PaymentCardServiceDelegate?

  // MARK: - Private Properties
  private let cvvValidator: PaymentCardValidatorProtocol
  private let dateValidator: PaymentCardValidatorProtocol
  private let numberValidator: PaymentCardValidatorProtocol

  private let finder: PaymentCardProviderFinderProtocol
  private let repository: PaymentCardRepositoryProtocol
  private let presenter: PaymentCardServicePresenterProtocol

  private(set) var cvv = ""
  private(set) var date = ""
  private(set) var number = ""
  private(set) var paymentCardProvider: PaymentCardProvider?

  // MARK: - Initialization
  init(
    cvvValidator: PaymentCardValidatorProtocol,
    dateValidator: PaymentCardValidatorProtocol,
    numberValidator: PaymentCardValidatorProtocol,
    finder: PaymentCardProviderFinderProtocol,
    presenter: PaymentCardServicePresenterProtocol,
    repository: PaymentCardRepositoryProtocol
  ) {
    self.cvvValidator = cvvValidator
    self.dateValidator = dateValidator
    self.numberValidator = numberValidator
    self.finder = finder
    self.presenter = presenter
    self.repository = repository
  }

  // MARK: - PaymentCardServiceInternalProtocol
  func didChangeCVV(_ value: String) {
    cvv = value
  }

  func didChangeDate(_ value: String) {
    date = value
  }

  func didChangeNumber(_ value: String) {
    number = value
    paymentCardProvider = finder.possible(number)
    delegate?.paymentCardServiceShouldUpdatePaymentCardProvider(self)
  }

  func didChangePaymentCard(_ paymentCard: PaymentCard) {
    didChangeCVV(paymentCard.cvv)
    didChangeDate("\(paymentCard.expirationMonth)/\(paymentCard.expirationYear)")
    didChangeNumber(paymentCard.number)
    delegate?.paymentCardServiceShouldUpdate(self)
  }

  func didTapHintCVV() {
    NotificationCenter.default
      .post(
        name: NSNotification.Name.PayU
          .PaymentCardWidget
          .didTapHintAccessoryViewInCVVField,
        object: nil)
  }

  // MARK: - PaymentCardServiceProtocol
  public func tokenize(agreement: Bool, completionHandler: @escaping (Result<CardToken, Error>) -> Void) {
    do {
      try delegate?.paymentCardServiceShouldValidate(self)
      let tokenCreateRequest = makeTokenCreateRequest(agreement: agreement)

      repository.tokenize(
        tokenCreateRequest: tokenCreateRequest,
        completionHandler: completionHandler)
    } catch {  }
  }

  public func scan(option: PaymentCardScannerOption, in presentingViewController: UIViewController) {
    presenter.presentPaymentCardScannerViewController(
      option: option,
      presentingViewController: presentingViewController,
      onComplete: { [weak self] result in self?.didScanPaymentCard(result) }
    )
  }

  // MARK: - Private Methods
  private func didScanPaymentCard(_ result: PaymentCardScannerResult) {
    if let cardNumber = result.cardNumber { didChangeNumber(cardNumber) }
    if let cardExpirationDate = result.cardExpirationDate { didChangeDate(cardExpirationDate) }
    delegate?.paymentCardServiceShouldUpdate(self)
  }

  private func makePaymentCard() -> PaymentCard {
    return PaymentCard(
      number: number.digitsOnly,
      expirationMonth: date.components(separatedBy: "/").first ?? "",
      expirationYear: date.components(separatedBy: "/").last ?? "",
      cvv: cvv.digitsOnly
    )
  }

  private func makeTokenCreateRequest(agreement: Bool) -> TokenCreateRequest {
    return TokenCreateRequest(
      sender: PayU.pos.id,
      data: TokenCreateRequest.Data(
        agreement: agreement,
        card: TokenCreateRequest.Data.Card(
          paymentCard: makePaymentCard())))
  }
}
