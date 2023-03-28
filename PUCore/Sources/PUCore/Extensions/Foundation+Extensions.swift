//
//  Foundation+Extensions.swift
//  
//  Created by PayU S.A. on 23/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

var debug: Bool {
  var isDebug = false
#if DEBUG
  isDebug = true
#endif
  return isDebug
}
