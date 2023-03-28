//
//  NetworkClientStatus.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

public struct NetworkClientStatus: Codable, Equatable {

  // MARK: - Status Codes
  public struct StatusCode: Equatable {
    public static let success = "SUCCESS" 
  }
  
  // MARK: - Public Properties
  public let statusCode: String
  public let codeLiteral: String
  public let code: String
}
