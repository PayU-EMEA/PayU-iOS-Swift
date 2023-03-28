//
//  PaymentCardFormatterProtocol.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

/// The protocol which allows to implement different card formatted mechanisms
public protocol PaymentCardFormatterProtocol {

  /// Method to format the input text into formatted text
  /// - Parameter text: text to format
  /// - Returns: formatter text
  func formatted(_ text: String) -> String
}
