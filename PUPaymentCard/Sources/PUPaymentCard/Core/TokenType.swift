//
//  TokenType.swift
//

import Foundation

/// An enum which is responsible for the type of cart token in PayU.
public enum TokenType: String {
  /// TOKD_ - Card not saved - token with short lifespan (11 minutes).
  case SINGLE = "SINGLE"
  /// TOK_ - Card not saved.
  case SINGLE_LONGTERM = "SINGLE_LONGTERM"
  /// TOK_ - Card saved - multi-use token will be returned after the it is charged via REST API.
  case MULTI = "MULTI"
}

