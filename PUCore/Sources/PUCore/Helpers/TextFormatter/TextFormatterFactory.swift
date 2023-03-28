//
//  TextFormatterFactory.swift
//
//  Created by PayU S.A. on 16/01/2023.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``TextFormatterProtocol`` instances
public struct TextFormatterFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Returns default implementation for ``TextFormatterProtocol`` service with `######` mask
  public func makeBlik() -> TextFormatterProtocol {
    DefaultTextFormatter(mask: .blik)
  }

  /// Returns default implementation for ``TextFormatterProtocol`` service with `###` mask
  public func makeCVV() -> TextFormatterProtocol {
    DefaultTextFormatter(mask: .cvv)
  }

}
