//
//  SoftAcceptRequest.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Model, which allows to pass the `redirectUri` from   [OrderCreateResponse](https://developers.payu.com/en/3ds_2.html#api_response) directly into the ``SoftAcceptService``
public struct SoftAcceptRequest {

  // MARK: - Public Properties

  /// `redirectUri` from   [OrderCreateResponse](https://developers.payu.com/en/3ds_2.html#api_response)
  public let redirectUrl: URL

  // MARK: - Initialization
  public init(redirectUrl: URL) {
    self.redirectUrl = redirectUrl
  }
}
