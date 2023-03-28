//
//  AuthorizationResponse.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//


import Foundation

public struct AuthorizationResponse: Codable {

  //
  public enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
  }

  // MARK: - Public Properties
  public let accessToken: String
}
