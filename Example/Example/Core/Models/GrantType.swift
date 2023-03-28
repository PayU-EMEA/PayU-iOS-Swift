//
//  GrantType.swift
//  Example
//
//  Created by PayU S.A. on 18/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

enum GrantType: String, Codable, CaseIterable {
  case clientCredentials = "client_credentials"
  case trustedMerchant = "trusted_merchant"
}
