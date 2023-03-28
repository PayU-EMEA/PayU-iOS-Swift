//
//  HTTPTask.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

enum HTTPTask {
  case request
  case requestParameters(body: HTTPParameters?, url: HTTPParameters?)
}
