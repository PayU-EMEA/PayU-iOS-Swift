//
//  WebPaymentsResultTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class WebPaymentsResultTests: XCTestCase {

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    let url = URL(string: "https://www.payu.com?refReqId=refReqId")!

    XCTAssertEqual(WebPaymentsResult(status: .success, url: url).status, .success)
    XCTAssertEqual(WebPaymentsResult(status: .success, url: url).url, url)

    XCTAssertEqual(WebPaymentsResult(status: .continue3DS, url: url).status, .continue3DS)
    XCTAssertEqual(WebPaymentsResult(status: .continue3DS, url: url).url, url)

    XCTAssertEqual(WebPaymentsResult(status: .externalApplication, url: url).status, .externalApplication)
    XCTAssertEqual(WebPaymentsResult(status: .externalApplication, url: url).url, url)
  }

}
