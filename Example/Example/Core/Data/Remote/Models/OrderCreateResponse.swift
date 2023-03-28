//
//  OrderCreateResponse.swift
//  Example
//
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

public struct OrderCreateResponse: Codable {

  // MARK: - Status
  public struct Status: Codable {

    // MARK: - Code
    public enum Code: String, Codable {
      case success = "SUCCESS"
      case warningContinueRedirect = "WARNING_CONTINUE_REDIRECT"
      case warningContinue3DS = "WARNING_CONTINUE_3DS"
      case warningContinueCVV = "WARNING_CONTINUE_CVV"
    }

    // MARK: - Public Properties
    public let statusCode: OrderCreateResponse.Status.Code
  }

  // MARK: - Public Properties
  public let status: OrderCreateResponse.Status
  public let redirectUri: String?
  public let iframeAllowed: Bool?
  public let orderId: String

  var redirectUrl: URL? {
    guard let redirectUri = redirectUri else { return nil }
    return URL(string: redirectUri)!
  }
}
