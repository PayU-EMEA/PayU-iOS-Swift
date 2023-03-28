//
//  CVVAuthorizationService.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

/// Protocol which defines the completion result of ``CVVAuthorizationService``
public protocol CVVAuthorizationServiceDelegate: AnyObject {

  /// This method is called when the authorization was success
  /// - Parameters:
  ///   - service: Instance of ``CVVAuthorizationService`` from where the action was triggered
  ///   - status: ``CVVAuthorizationResult`` value
  func cvvAuthorizationService(_ service: CVVAuthorizationService, didComplete status: CVVAuthorizationResult)

  /// This method is called when the error occured during the authorization
  /// - Parameters:
  ///   - service: Instance of ``CVVAuthorizationService`` from where the action was triggered
  ///   - error: Error with details
  func cvvAuthorizationService(_ service: CVVAuthorizationService, didFail error: Error)
}

/// Allows to make [CVV2 Authorization](https://developers.payu.com/en/card_tokenization.html#handling_cvv2). Is shows the `UIAlertViewController` with `textField`.
public final class CVVAuthorizationService {

  // MARK: - Factory
  /// Factory which allows to create the ``CVVAuthorizationService`` instance
  public struct Factory {
    // MARK: - Private Properties
    private let assembler = WebPaymentsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Initialization
    /// Returns default implementation for ``CVVAuthorizationService``
    /// - Returns: Default implementation for ``CVVAuthorizationService``
    public func make() -> CVVAuthorizationService {
      assembler.makeCVVAuthorizationService()
    }
  }

  // MARK: - Public Properties
  public weak var delegate: CVVAuthorizationServiceDelegate?
  public weak var presentingViewController: UIViewController?

  // MARK: - Private Properties
  private var refReqId: String?
  private var presenter: CVVAuthorizationPresenterProtocol
  private let repository: CVVAuthorizationRepositoryProtocol

  // MARK: - Initialization
  init(presenter: CVVAuthorizationPresenterProtocol, repository: CVVAuthorizationRepositoryProtocol) {
    self.presenter = presenter
    self.repository = repository
  }

  // MARK: - Public Methods
  // TODO: - ADD LOADING STATE WHILE MAKING REQUEST
  public func authorize(refReqId: String) {
    self.refReqId = refReqId
    self.presenter.presentCVVAlertViewController(
      from: presentingViewController,
      onConfirm: { [weak self] cvv in
        guard let self = self else { return }
        guard let refReqId = self.refReqId else { return }
        self.didTapAuthorize(refReqId: refReqId, cvv: cvv)
      },
      onCancel: { [weak self] in
        guard let self = self else { return }
        guard let refReqId = self.refReqId else { return }
        self.didTapCancel(refReqId: refReqId)
      })

  }

  // MARK: - Private Methods
  private func didTapCancel(refReqId: String) {
    delegate?.cvvAuthorizationService(self, didComplete: .cancelled)
  }

  private func didTapAuthorize(refReqId: String, cvv: String) {
    repository.authorizeCVV(
      cvvAuthorizationRequest: CVVAuthorizationRequest(
        data: CVVAuthorizationRequest.Data(
          refReqId: refReqId,
          cvv: cvv)),
      completionHandler: { [weak self] result in
        guard let self = self else { return }

        switch result {
          case .success(let cvvAuthorizationResult):
            self.delegate?.cvvAuthorizationService(self, didComplete: cvvAuthorizationResult)
          case .failure(let error):
            self.delegate?.cvvAuthorizationService(self, didFail: error)
        }
      }
    )
  }
}
