//
//  Selectable.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol Selectable: Equatable {
  var id: String { get }
  var title: String { get }
}

extension String: Selectable {
  public var id: String {
    return self
  }
  var title: String {
    return self
  }
}
