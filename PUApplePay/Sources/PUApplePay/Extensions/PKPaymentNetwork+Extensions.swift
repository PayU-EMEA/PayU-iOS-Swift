//
//  PKPaymentNetwork+Extensions.swift
//  
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import PassKit

extension PKPaymentNetwork {
  static func networks() -> [PKPaymentNetwork] {
    return [.maestro, .masterCard, .visa]
  }
}
