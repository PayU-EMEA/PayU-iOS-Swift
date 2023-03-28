//
//  CVVAuthorizationResponse.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

#if canImport(PUAPI)
import PUAPI
#endif

struct CVVAuthorizationResponse: Codable, Equatable {

  // MARK: - Public Properties
  let status: NetworkClientStatus
}
