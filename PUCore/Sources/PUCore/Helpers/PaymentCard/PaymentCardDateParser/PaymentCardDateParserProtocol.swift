//
//  PaymentCardDateParserProtocol.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// The protocol which allows to implement different Date parsing mechanisms
public protocol PaymentCardDateParserProtocol {

  /// Method to parse the String into Date. For ex: supported formats: "MM/yy", "MM/yyyy"
  /// - Parameter value: for ex: 12/23, 03/2023
  /// - Returns: Date object if was able to parse the `value`
  func parse(_ value: String) -> Date?
}
