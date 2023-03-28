//
//  UIImageExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import UIKit
@testable import PUCore

final class UIImageExtensionsTests: XCTestCase {
  func testHasRequiredBundleImages() throws {
    XCTAssertNotNil(UIImage.calendar)
    XCTAssertNotNil(UIImage.camera)
    XCTAssertNotNil(UIImage.chevronLeft)
    XCTAssertNotNil(UIImage.chevronRight)
    XCTAssertNotNil(UIImage.creditcard)
    XCTAssertNotNil(UIImage.lock)
    XCTAssertNotNil(UIImage.logo)
    XCTAssertNotNil(UIImage.paperplane)
  }
}
