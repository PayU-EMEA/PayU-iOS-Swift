//
//  WebPaymentsRequest.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Allows to prepare the request in the WebView
public struct WebPaymentsRequest: Equatable {

  // MARK: - RequestType

  /// Based on the `statusCode` from the `OrderCreateResponse`
  public enum RequestType {
    case payByLink
    case threeDS
  }

  // MARK: - Public Properties

  /// ``WebPaymentsRequest/RequestType-swift.enum`` based on the `statusCode` from the `OrderCreateResponse`
  public let requestType: RequestType

  /// `redirectUri` from the `OrderCreateResponse`
  public let redirectUrl: URL

  /// Any valid url, for ex: your company homepage
  public let continueUrl: URL

  // MARK: - Initialization
  public init(requestType: WebPaymentsRequest.RequestType, redirectUrl: URL, continueUrl: URL) {
    self.requestType = requestType
    self.redirectUrl = redirectUrl
    self.continueUrl = continueUrl
  }
}
