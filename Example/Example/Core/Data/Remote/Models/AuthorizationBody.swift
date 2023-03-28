//
//  AuthorizationBody.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//


import Foundation

public struct AuthorizationBody: Codable {

  // MARK: - CodingKeys
  public enum CodingKeys: String, CodingKey {
    case clientId = "client_id"
    case clientSecret = "client_secret"
    case grantType = "grant_type"
    case email = "email"
    case extCustomerId = "ext_customer_id"
  }

  // MARK: - Public Properties
  public let clientId: String
  public let clientSecret: String
  public let grantType: String
  public let email: String
  public let extCustomerId: String
}
