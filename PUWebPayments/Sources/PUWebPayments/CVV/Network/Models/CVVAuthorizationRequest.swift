//
//  CVVAuthorizationRequest.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct CVVAuthorizationRequest: Codable, Equatable {

  // MARK: - Constants
  private struct Constants {
    static let request = "auth.cvv"
  }

  // MARK: - Data
  struct Data: Codable, Equatable {

    // MARK: - Public Properties
    let refReqId: String
    let cvv: String
  }

  // MARK: - Public Properties
  let request: String
  let data: CVVAuthorizationRequest.Data

  // MARK: - Initialization
  init(request: String = Constants.request, data: CVVAuthorizationRequest.Data) {
    self.request = request
    self.data = data
  }
}
