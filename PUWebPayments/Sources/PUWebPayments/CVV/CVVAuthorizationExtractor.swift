//
//  CVVAuthorizationExtractor.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Allows to extract `refReqId` from `redirectUrl`
public struct CVVAuthorizationExtractor {

  // MARK: - Initialization
  public init() {  }

  // MARK: - Public Methods
  /// Extracts `refReqId` from `redirectUrl`
  /// - Parameter redirectUrl: `redirectUri` from `OrderCreateResponse`
  /// - Returns: value for `refReqId`query item name
  public func extractRefReqId(_ redirectUrl: URL) -> String? {
    redirectUrl.components?.queryItem("refReqId")?.value
  }
}
