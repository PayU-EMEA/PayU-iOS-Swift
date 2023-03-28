//
//  TokenCreateResponse.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

#if canImport(PUAPI)
import PUAPI
#endif

#if canImport(PUCore)
import PUCore
#endif

struct TokenCreateResponse: Codable, Equatable {

  // MARK: - Result
  struct Result: Codable, Equatable {

    // MARK: - Public Properties
    let token: String
    let mask: String
    let type: String
  }

  // MARK: - Public Properties
  let status: NetworkClientStatus
  let data: TokenCreateResponse.Result?

}
