//
//  Decoder.swift
//
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

func decode<T: Decodable>(type: T.Type, from file: String) -> T {
  let url = Bundle.current(.PUMastercardInstallmentsTests).url(forResource: file, withExtension: "json")!
  let data = try! Data(contentsOf: url)
  return try! JSONDecoder().decode(type, from: data)
}
