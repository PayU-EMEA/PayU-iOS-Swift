//
//  PaymentCardScanner.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

/// Allows to understand if the ``PaymentCardScannerViewController`` is available
public struct PaymentCardScanner {

  // MARK: - Public Methods


  /// Allows to understand if the ``PaymentCardScannerViewController`` is available
  /// - Returns: `true` if iOS version is greater than 13.0
  public static func isAvailable() -> Bool {
    if #available(iOS 13, *) {
      return true
    } else {
      return false
    }
  }

}
