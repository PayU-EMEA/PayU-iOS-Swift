//
//  TokenCreateResponseTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUAPI
@testable import PUPaymentCard

final class TokenCreateResponseTests: XCTestCase {

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    let sut = TokenCreateResponse(
      status: NetworkClientStatus(
        statusCode: "statusCode",
        codeLiteral: "codeLiteral",
        code: "code"),
      data: TokenCreateResponse.Result.init(
        token: "TOK_QWERTYUIOP98765",
        mask: "0000 **** **** 9999",
        type: "QQ"))


    XCTAssertEqual(sut.status.statusCode, "statusCode")
    XCTAssertEqual(sut.status.codeLiteral, "codeLiteral")
    XCTAssertEqual(sut.status.code, "code")

    XCTAssertEqual(sut.data?.token, "TOK_QWERTYUIOP98765")
    XCTAssertEqual(sut.data?.mask, "0000 **** **** 9999")
    XCTAssertEqual(sut.data?.type, "QQ")
  }

}
