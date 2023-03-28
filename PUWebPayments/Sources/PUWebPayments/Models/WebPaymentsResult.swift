//
//  WebPaymentsResult.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Allows to understand the result of the WebView payment
public struct WebPaymentsResult: Equatable {

  // MARK: - Status
  public enum Status {

    /// Successful transaction
    case success

    /// Transaction failed (e.g. timeout)
    case failure

    /// Transaction cancelled by user
    case cancelled

    /// Transaction needs to be confirmed by 3DS. Continue with `SoftAcceptService` from `PUThreeDS` package
    case continue3DS

    /// Transaction needs to be confirmed by CVV code. Continue with ``CVVAuthorizationService``
    case continueCvv

    /// Transaction will be handled in mobile bank app
    case externalApplication
  }

  // MARK: - Public Properties
  public let status: WebPaymentsResult.Status
  public let url: URL

  // MARK: - Initialization
  public init(status: WebPaymentsResult.Status, url: URL) {
    self.status = status
    self.url = url
  }

}
