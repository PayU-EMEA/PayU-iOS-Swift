//
//  PaymentCardNetworkTargetTests.swift
//

import XCTest

@testable import PUPaymentCard

final class PaymentCardNetworkTargetTests: XCTestCase {
  func testShouldHaveCorrectRequest() throws {
    let httpBody =
      "{\"posId\":\"453872304\",\"type\":\"SINGLE\",\"card\":{\"cvv\":\"274\",\"number\":\"5434021016824014\",\"expirationMonth\":\"04\",\"expirationYear\":\"2025\"}}"

    let sut = PaymentCardNetworkTarget.tokenize(makeTokenCreateRequest())
    XCTAssertEqual(sut.path, "api/front/tokens")
    XCTAssertEqual(sut.httpMethod, "POST")
    XCTAssertEqual(sut.httpHeaders["Content-Type"], "application/json")
    XCTAssertEqualJSON(sut.httpBody, httpBody.data(using: .utf8))
  }

}

extension PaymentCardNetworkTargetTests {
  fileprivate func makeTokenCreateRequest() -> TokenCreateRequest {
    TokenCreateRequest(
      posId: "453872304",
      type: TokenType.SINGLE.rawValue,
      card: PaymentCard(
        number: "5434021016824014",
        expirationMonth: "04",
        expirationYear: "2025",
        cvv: "274"
      )
    )
  }

  fileprivate func XCTAssertEqualJSON(
    _ data1: Data?, _ data2: Data?,
    _ message: @escaping @autoclosure () -> String = "",
    file: StaticString = #file, line: UInt = #line
  ) {
    do {
      if let data1 = data1, let data2 = data2 {
        let json1 =
          try JSONSerialization.jsonObject(with: data1, options: [])
          as? [String: Any]
        let json2 =
          try JSONSerialization.jsonObject(with: data2, options: [])
          as? [String: Any]

        XCTAssertTrue(
          NSDictionary(dictionary: json1 ?? [:]).isEqual(to: json2 ?? [:]),
          message(), file: file, line: line)
      } else {
        XCTFail("One of Data is nil.", file: file, line: line)
      }
    } catch {
      XCTFail("JSON parse error: \(error)", file: file, line: line)
    }
  }
}
