//
//  NumberCategory.swift
//  
//  Created by PayU S.A. on 21/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Represents which kind of translation to use: ``NumberCategory/singular`` or ``NumberCategory/plural``
public enum NumberCategory {

  /// The form of a word that is used to denote a singleton.
  case singular

  /// Number category referring to two or more items or units.
  case plural

  var tableName: TableName {
    switch self {
      case .singular:
        return TableName.localizable
      case .plural:
        return TableName.plurals
    }
  }
}
