//
//  PaymentMethodsResponse.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import PUSDK

public struct PaymentMethodsResponse: Codable {
  public let blikTokens: [BlikToken]?
  public let cardTokens: [CardToken]
  public let payByLinks: [PayByLink]
}
