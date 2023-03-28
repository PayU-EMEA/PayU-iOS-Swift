//
//  TestPaymentCardsViewModel.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

protocol TestPaymentCardsViewModelProtocol {
  func numberOfSections() -> Int
  func numberOfItems(in section: Int) -> Int
  func card(at indexPath: IndexPath) -> TestPaymentCard

  func didSelectItem(at indexPath: IndexPath)
}

protocol TestPaymentCardsViewModelDelegate: AnyObject {
  func viewModel(_ viewModel: TestPaymentCardsViewModel, didSelect card: PaymentCard)
}

final class TestPaymentCardsViewModel {

  // MARK: - Public Properties
  weak var delegate: TestPaymentCardsViewModelDelegate?

  // MARK: - Private Properties
  private var cards: [TestPaymentCard]

  // MARK: - Initialization
  init() {
    guard
      let path = Bundle
        .current(.PUPaymentCard)
        .path(forResource: "cards", ofType: "json"),
      let data = FileManager.default.contents(atPath: path),
      let cards = try? JSONDecoder().decode([TestPaymentCard].self, from: data)
    else {
      self.cards = []
      return
    }

    self.cards = cards
  }

  // MARK: - Public Methods
  func numberOfSections() -> Int {
    return 1
  }

  func numberOfItems(in section: Int) -> Int {
    return cards.count
  }

  func card(at indexPath: IndexPath) -> TestPaymentCard {
    return cards[indexPath.row]
  }

  func didSelectItem(at indexPath: IndexPath) {
    let paymentCardItem = card(at: indexPath)
    let paymentCard = PaymentCard(
      number: paymentCardItem.number,
      expirationMonth: paymentCardItem.expirationMonth,
      expirationYear: paymentCardItem.expirationYear,
      cvv: paymentCardItem.cvv)

    delegate?.viewModel(self, didSelect: paymentCard)
  }
}
