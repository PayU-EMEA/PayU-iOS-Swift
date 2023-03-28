//
//  PaymentCardValidatorProtocol.swift
//  
//  Created by PayU S.A. on 22/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// The protocol which allows to declare if the payment card properties are valid
public protocol PaymentCardValidatorProtocol {
  /// Method which validates the payment card property. Throws an instance of ``PaymentCardError``
  /// - Parameter value: payment card property to validate: cvv, date, number
  func validate(_ value: String?) throws
}
