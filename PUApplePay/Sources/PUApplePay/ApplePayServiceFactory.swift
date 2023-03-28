//
//  ApplePayServiceFactory.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

/// Factory which allows to create the ``ApplePayServiceFactory`` instances
public struct ApplePayServiceFactory {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Returns details implementation for ``ApplePayServiceProtocol``service
  public func make() -> ApplePayServiceProtocol {
    DefaultApplePayService()
  }
}
