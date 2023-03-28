//
//  TestPaymentCard.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct TestPaymentCard: Codable {

  // MARK: - Public Properties
  let number: String
  let expirationMonth: String
  let expirationYear: String
  let cvv: String

  let is3DSecure: String
  let isMastercardInstallments: String
  let behavior: String
}
