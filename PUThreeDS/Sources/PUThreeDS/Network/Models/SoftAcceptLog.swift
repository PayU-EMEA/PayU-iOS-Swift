//
//  SoftAcceptLog.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct SoftAcceptLog: Codable {

  // MARK: - Constants
  private struct Constants {
    static let sender = "PUSDK"
    static let event = "receivedMessage"
    static let level = "INFO"
  }

  // MARK: - Public Properties
  let id: String
  let message: String

  let event: String
  let level: String
  let sender: String

  // MARK: - Initialization
  init(
    id: String,
    message: String,
    event: String = Constants.event,
    level: String = Constants.level,
    sender: String = Constants.sender) {
      self.id = id
      self.message = message
      self.sender = sender
      self.event = event
      self.level = level
    }
}
