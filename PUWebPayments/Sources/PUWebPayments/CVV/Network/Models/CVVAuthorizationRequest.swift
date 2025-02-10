//
//  CVVAuthorizationRequest.swift
//

import Foundation

struct CVVAuthorizationRequest: Codable, Equatable {

  // MARK: - Public Properties
  let cvv: String
  let refReqId: String

  // MARK: - Initialization
  init(cvv: String, refReqId: String)
  {
    self.cvv = cvv
    self.refReqId = refReqId
  }
}
