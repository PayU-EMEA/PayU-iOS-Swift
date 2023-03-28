//
//  PayMethod.swift
//  
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Model which represent the [PayMethod](https://developers.payu.com/en/restapi.html#paymethod) which can be used during the [OrderCreateRequest](https://developers.payu.com/en/restapi.html#creating_new_order_api)
public struct PayMethod: Codable, Equatable {

  // MARK: - PayMethodType
  public enum PayMethodType: String, Codable, Equatable {
    case blik = "BLIK"
    case blikToken = "BLIK_TOKEN"
    case cardToken = "CARD_TOKEN"
    case installmenst = "INSTALLMENTS"
    case pbl = "PBL"
  }

  // MARK: - Public Properties
  public let type: PayMethodType
  public let value: String?
  public let authorizationCode: String?

  // MARK: - Initialization
  public init(type: PayMethodType, value: String? = nil, authorizationCode: String? = nil) {
    self.type = type
    self.value = value
    self.authorizationCode = authorizationCode
  }
}

public extension PayMethod {
  var formattedDescription: String? {
    return [type.rawValue, value, authorizationCode]
      .compactMap { $0 }
      .joined(separator: "\n")
  }
}
