//
//  PBLPaymentMethodsViewModelTests.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUPaymentMethods

final class PBLPaymentMethodsViewModelTests: XCTestCase {

  private var items: [PaymentMethodsItem]!
  private var configuration: PaymentMethodsConfiguration!
  private var delegate: PBLPaymentMethodsViewModelDelegateMock!
  private var service: PaymentMethodsServiceProtocolMock!
  private var sut: PBLPaymentMethodsViewModel!

  override func setUp() {
    super.setUp()
    items = [
      PaymentMethodItemPayByLink(payByLink: self.makePayByLink()),
      PaymentMethodItemPayByLink(payByLink: self.makePayByLink())
    ]

    configuration = PaymentMethodsConfiguration()
    delegate = mock(PBLPaymentMethodsViewModelDelegate.self)
    service = mock(PaymentMethodsServiceProtocol.self)

    given(service.makePayByLinksPaymentMethodItems(for: any())).willReturn(items!)
    sut = PBLPaymentMethodsViewModel(configuration: configuration, service: service)

    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    configuration = nil
    service = nil
    sut = nil
  }

  func testWhenInitializedThenShouldCallService() {
    verify(service.makePayByLinksPaymentMethodItems(for: configuration)).wasCalled()
  }

  func testNumberOfSectionsReturnsCorrectValue() {
    XCTAssertEqual(sut.numberOfSections(), 1)
  }

  func testNumberOfItemsReturnsCorrectValue() {
    XCTAssertEqual(sut.numberOfItems(in: 0), 2)
  }

  func testItemItIndexPathShouldReturnCorrectValue() {
    XCTAssertEqual(
      sut.item(at: .init(row: 0, section: 0)).value,
      sut.items[0].value)

    XCTAssertEqual(
      sut.item(at: .init(row: 1, section: 0)).value,
      sut.items[1].value)
  }

  func testWhenDidSelectItemAtIndexPathThenShouldInformDelegate() {
    sut.didSelectItem(at: .init(row: 0, section: 0))
    verify(
      delegate
        .paymentMethodsViewModel(
          any(),
          didSelect: sut.items[0].paymentMethod as! PayByLink))
    .wasCalled()

    sut.didSelectItem(at: .init(row: 1, section: 0))
    verify(
      delegate
        .paymentMethodsViewModel(
          any(),
          didSelect: sut.items[1].paymentMethod as! PayByLink))
    .wasCalled()
  }
}

private extension PBLPaymentMethodsViewModelTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
  }

  func makeBlikToken() -> BlikToken {
    BlikToken(
      brandImageUrl: makeBrandImageUrl(),
      type: "UID",
      value: "TOK_\(UUID().uuidString)")
  }

  func makeCardToken() -> CardToken {
    CardToken(
      brandImageUrl: makeBrandImageUrl(),
      cardExpirationMonth: Int.random(in: 1...12),
      cardExpirationYear: Int.random(in: Date().year + 1...Date().year + 10),
      cardNumberMasked: UUID().uuidString,
      cardScheme: UUID().uuidString,
      preferred: false,
      status: .active,
      value: UUID().uuidString
    )
  }

  func makePayByLink(value: String? = nil) -> PayByLink {
    PayByLink(
      brandImageUrl: makeBrandImageUrl(),
      name: UUID().uuidString,
      status: .enabled,
      value: value ?? UUID().uuidString
    )
  }
}
