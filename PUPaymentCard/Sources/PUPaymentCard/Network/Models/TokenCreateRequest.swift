//
//  TokenCreateRequest.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct TokenCreateRequest: Codable, Equatable {

  // MARK: - Data
  struct Data: Codable, Equatable {

    // MARK: - Card
    struct Card: Codable, Equatable {

      // MARK: - Public Properties
      let number: String
      let expirationMonth: String
      let expirationYear: String
      let cvv: String

      // MARK: - Initialization
      init(number: String, expirationMonth: String, expirationYear: String, cvv: String) {
        self.number = number
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
      }

      init(paymentCard: PaymentCard) {
        self.number = paymentCard.number
        self.expirationMonth = paymentCard.expirationMonth
        self.expirationYear = paymentCard.expirationYear
        self.cvv = paymentCard.cvv
      }
    }

    // MARK: - Public Properties
    let agreement: Bool
    let card: Card
  }

  // MARK: - Public Properties
  let request: String
  let sender: String
  let data: Data

  // MARK: - Initialization
  init(request: String = "TokenCreateRequest", sender: String, data: Data) {
    self.request = request
    self.sender = sender
    self.data = data
  }
}
