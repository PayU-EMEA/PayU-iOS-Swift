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
  /// - Returns: `true`, because the scanner is available on every iOS version supported by the SDK
  public static func isAvailable() -> Bool {
    return true
  }

}
