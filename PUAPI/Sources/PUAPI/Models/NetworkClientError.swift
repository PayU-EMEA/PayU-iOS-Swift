//
//  NetworkClientError.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

public struct NetworkClientError: Codable, Error, LocalizedError {

  // MARK: - Public Properties
  public let statusCode: String
  public let codeLiteral: String
  public let code: String

  // MARK: - Initialization
  public init(status: NetworkClientStatus) {
    self.statusCode = status.statusCode
    self.codeLiteral = status.codeLiteral
    self.code = status.code
  }

  // MARK: - LocalizedError
  public var errorDescription: String? {
    return "\(codeLiteral) (\(code))"
  }
}
