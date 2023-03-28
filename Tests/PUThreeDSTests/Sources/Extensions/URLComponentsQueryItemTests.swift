//
//  URLComponentsExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class URLComponentsExtensionsTests: XCTestCase {
  func testShouldAppendURLQueryItem() throws {
    let url = URL(string: "https://www.payu.com")!
    let queryItem = URLQueryItem(name: "query", value: "item")
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

    XCTAssertNil(components.queryItems?.first(where: { $0.name == queryItem.name }))

    components.appendURLQueryItem(queryItem)
    XCTAssertNotNil(components.queryItems?.first(where: { $0.name == queryItem.name }))
  }
}
