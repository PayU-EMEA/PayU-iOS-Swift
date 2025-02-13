//
//  PaymentCard.swift
//  
//  Created by PayU S.A. on 12/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct PaymentCard: Codable, Equatable {

  // MARK: - Public Properties
  let number: String
  let expirationMonth: String
  let expirationYear: String
  let cvv: String

}
