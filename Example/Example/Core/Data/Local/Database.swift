//
//  Database.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

@propertyWrapper
struct Database<T> {
  private let key: String

  init(key: String) {
    self.key = key
  }

  var wrappedValue: T? {
    get { return UserDefaults.standard.object(forKey: key) as? T}
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
}
