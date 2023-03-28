//
//  WebPaymentsRequestTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class WebPaymentsRequestTests: XCTestCase {

  func testShouldKeepPropertiesAfterBeingInitilizedWithPayByLinkRequestType() throws {
    let continueUrl = URL(string: "https://www.payu.com?refReqId=refReqId")!
    let redirectUrl = URL(string: "https://www.payu.com?authenticationId=authenticationId")!
    let requestType = WebPaymentsRequest.RequestType.payByLink

    let webPaymentsRequest = WebPaymentsRequest(
      requestType: requestType,
      redirectUrl: redirectUrl,
      continueUrl: continueUrl)

    XCTAssertEqual(webPaymentsRequest.continueUrl, continueUrl)
    XCTAssertEqual(webPaymentsRequest.redirectUrl, redirectUrl)
    XCTAssertEqual(webPaymentsRequest.requestType, requestType)
  }

  func testShouldKeepPropertiesAfterBeingInitilizedWithThreeDSRequestType() throws {
    let continueUrl = URL(string: "https://www.payu.com?refReqId=refReqId")!
    let redirectUrl = URL(string: "https://www.payu.com?authenticationId=authenticationId")!
    let requestType = WebPaymentsRequest.RequestType.threeDS

    let webPaymentsRequest = WebPaymentsRequest(
      requestType: requestType,
      redirectUrl: redirectUrl,
      continueUrl: continueUrl)

    XCTAssertEqual(webPaymentsRequest.continueUrl, continueUrl)
    XCTAssertEqual(webPaymentsRequest.redirectUrl, redirectUrl)
    XCTAssertEqual(webPaymentsRequest.requestType, requestType)
  }

}
