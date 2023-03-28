//
//  HTTPParametersEncoder.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol HTTPParametersEncoder {
  func encode(request: inout URLRequest, with parameters: HTTPParameters) throws
}
