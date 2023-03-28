//
//  PaymentCardScannerOption.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

/// Allows to select the strategy, which data to scan in ``PaymentCardScannerViewController``
public enum PaymentCardScannerOption {

  /// Should complete when the number is recognized
  case number

  /// Should complete when both number and date are recognized
  case numberAndDate
}
