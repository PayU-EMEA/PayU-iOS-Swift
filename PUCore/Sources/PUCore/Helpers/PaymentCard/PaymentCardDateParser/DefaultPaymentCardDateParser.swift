//
//  DefaultPaymentCardDateParser.swift
//
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Default implementation for ``PaymentCardDateParserProtocol`` which parses Date in two formats: "MM/yy", "MM/yyyy"
struct DefaultPaymentCardDateParser: PaymentCardDateParserProtocol {

  // MARK: - Format
  private enum Format: String, CaseIterable {
    case short = "MM/yy"
    case long = "MM/yyyy"
  }

  // MARK: - Private Properties
  private let dateFormatter = DateFormatter()

  // MARK: - Initialization
  public init() {  }

  // MARK: - PaymentCardDateParserProtocol
  /// Method to parse the String into Date. Supported formats: "MM/yy", "MM/yyyy"
  /// - Parameter value: for ex: 12/23, 03/2023
  /// - Returns: Date object if was able to parse the `value`
  func parse(_ value: String) -> Date? {
    for format in Format.allCases {
      dateFormatter.dateFormat = format.rawValue

      guard let date = dateFormatter.date(from: value) else { continue }
      return date
    }
    return nil
  }

}
