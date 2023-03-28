//
//  PaymentCardViewModel.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

protocol PaymentCardViewModelProtocol {
  func didTapOpenTestCards(in presentingViewController: UIViewController)
  func didTapScanCard(in presentingViewController: UIViewController)
  func didTapSaveAndUse()
  func didTapUse()
}

protocol PaymentCardViewModelDelegate: AnyObject {
  func paymentCardViewModel(_ viewModel: PaymentCardViewModel, didComplete cardToken: CardToken)
  func paymentCardViewModel(_ viewModel: PaymentCardViewModel, didFail error: Error)
}

final class PaymentCardViewModel: PaymentCardViewModelProtocol {

  // MARK: - Public Properties
  weak var delegate: PaymentCardViewModelDelegate?
  let service: PaymentCardServiceProtocol

  // MARK: - Private Properties
  private let openTestCardsUseCase: OpenTestCardsUseCase

  // MARK: - Initialization
  init(service: PaymentCardServiceProtocol) {
    self.service = service
    self.openTestCardsUseCase = OpenTestCardsUseCase(service: service)
  }

  // MARK: - PaymentCardViewModelProtocol
  func didTapOpenTestCards(in presentingViewController: UIViewController) {
    openTestCardsUseCase.execute(in: presentingViewController)
  }

  func didTapScanCard(in presentingViewController: UIViewController) {
    service.scan(option: .numberAndDate, in: presentingViewController)
  }

  func didTapSaveAndUse() {
    tokenize(agreement: true)
  }

  func didTapUse() {
    tokenize(agreement: false)
  }

  // MARK: - Private Methods
  private func tokenize(agreement: Bool) {
    service.tokenize(agreement: agreement) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let cardToken):
          self.delegate?.paymentCardViewModel(self, didComplete: cardToken)
        case .failure(let error):
          self.delegate?.paymentCardViewModel(self, didFail: error)
      }
    }
  }
}
