//
//  PaymentMethodsViewModelTests.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUPaymentMethods

final class PaymentMethodsViewModelTests: XCTestCase {

  private var items: [PaymentMethodsItem]!
  private var configuration: PaymentMethodsConfiguration!
  private var delegate: PaymentMethodsViewModelDelegateMock!
  private var service: PaymentMethodsServiceProtocolMock!
  private var storage: PaymentMethodsStorageProtocolMock!
  private var sut: PaymentMethodsViewModel!

  override func setUp() {
    super.setUp()
    items = [
      PaymentMethodItemApplePay(
        applePay: ApplePay(
          payByLink: self.makePayByLink(
            value: PaymentMethodValue.applePay))),
      PaymentMethodItemBlikCode(blikCode: BlikCode()),
      PaymentMethodItemBlikToken(blikToken: makeBlikToken()),
      PaymentMethodItemBlikToken(blikToken: makeBlikToken()),
      PaymentMethodItemBlikToken(blikToken: makeBlikToken()),
      PaymentMethodItemBlikToken(blikToken: makeBlikToken()),
      PaymentMethodItemCardToken(cardToken: makeCardToken()),
      PaymentMethodItemCardToken(cardToken: makeCardToken()),
      PaymentMethodItemCardToken(cardToken: makeCardToken()),
      PaymentMethodItemCard(),
      PaymentMethodItemBankTransfer(enabled: true),
      PaymentMethodItemInstallments(
        installments: Installments(
          payByLink: self.makePayByLink(
            value: PaymentMethodValue.installments))),
      PaymentMethodItemPayByLink(payByLink: self.makePayByLink()),
      PaymentMethodItemPayByLink(payByLink: self.makePayByLink())
    ]

    configuration = PaymentMethodsConfiguration()
    delegate = mock(PaymentMethodsViewModelDelegate.self)
    service = mock(PaymentMethodsServiceProtocol.self)
    storage = mock(PaymentMethodsStorageProtocol.self)

    given(service.makePaymentMethodItems(for: any())).willReturn(items!)
    sut = PaymentMethodsViewModel(configuration: configuration, service: service,storage: storage)

    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    configuration = nil
    service = nil
    storage = nil
    sut = nil
  }

  func testWhenInitializedThenShouldCallService() {
    verify(service.makePaymentMethodItems(for: configuration)).wasCalled()
  }

  func testNumberOfSectionsReturnsCorrectValue() {
    XCTAssertEqual(sut.numberOfSections(), 1)
  }

  func testNumberOfItemsReturnsCorrectValue() {
    XCTAssertEqual(
      sut.numberOfItems(in: 0),
      service.makePaymentMethodItems(for: configuration).count)
  }

  func testItemAtIndexPathReturnsCorrectValue() {
    XCTAssertEqual(
      sut.item(at: .init(row: 0, section: 0)).value,
      service.makePaymentMethodItems(for: configuration)[0].value)

    XCTAssertEqual(
      sut.item(at: IndexPath(row: 5, section: 0)).value,
      service.makePaymentMethodItems(for: configuration)[5].value)
  }

  func testCanDeleteItemWhenItemIsCardTokenThenReturnsTrue() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemCardToken })!
    let indexPath = IndexPath(row: index, section: 0)
    XCTAssertTrue(sut.canDeleteItem(at: indexPath))
  }

  func testCanDeleteItemWhenItemIsNotCardTokenThenReturnsFalse() {
    XCTAssertFalse(
      sut.canDeleteItem(
        at: IndexPath(
          row: items.firstIndex(where: { $0 is PaymentMethodItemApplePay })!,
          section: 0)))

    XCTAssertFalse(
      sut.canDeleteItem(
        at: IndexPath(
          row: items.firstIndex(where: { $0 is PaymentMethodItemBankTransfer })!,
          section: 0)))

    XCTAssertFalse(
      sut.canDeleteItem(
        at: IndexPath(
          row: items.firstIndex(where: { $0 is PaymentMethodItemBlikCode })!,
          section: 0)))

    XCTAssertFalse(
      sut.canDeleteItem(
        at: IndexPath(
          row: items.firstIndex(where: { $0 is PaymentMethodItemBlikToken })!,
          section: 0)))

    XCTAssertFalse(
      sut.canDeleteItem(
        at: IndexPath(
          row: items.firstIndex(where: { $0 is PaymentMethodItemInstallments })!,
          section: 0)))

    XCTAssertFalse(
      sut.canDeleteItem(
        at: IndexPath(
          row: items.firstIndex(where: { $0 is PaymentMethodItemPayByLink })!,
          section: 0)))

  }

  func testWhenDeleteItemThenShouldDeleteIteFromVisible() {
    XCTAssertEqual(
      sut.numberOfItems(in: 0),
      service.makePaymentMethodItems(for: configuration).count)

    let index = items.firstIndex(where: { $0 is PaymentMethodItemCardToken })!
    let indexPath = IndexPath(row: index, section: 0)
    sut.deleteItem(at: indexPath)

    XCTAssertEqual(
      sut.numberOfItems(in: 0),
      service.makePaymentMethodItems(for: configuration).count - 1)
  }

  func testWhenDeleteItemThenShouldInformDelegate() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemCardToken })!
    let indexPath = IndexPath(row: index, section: 0)
    sut.deleteItem(at: indexPath)
    verify(delegate.viewModel(any(), didDelete: any())).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectApplePayThenShouldComplete() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemApplePay })!
    let indexPath = IndexPath(row: index, section: 0)
    let item = sut.didSelectItem(at: indexPath)

    verify(storage.saveSelectedPaymentMethodValue(item.value!)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectBankTransferThenShouldNavigateToBankTransfer() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemBankTransfer })!
    let indexPath = IndexPath(row: index, section: 0)
    sut.didSelectItem(at: indexPath)

    verify(delegate.viewModel(any(), shouldNavigateToBankTransfer: configuration)).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectBlikCodeThenShouldComplete() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemBlikCode })!
    let indexPath = IndexPath(row: index, section: 0)
    let item = sut.didSelectItem(at: indexPath)

    verify(storage.saveSelectedPaymentMethodValue(item.value!)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectBlikTokenThenShouldComplete() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemBlikToken })!
    let indexPath = IndexPath(row: index, section: 0)
    let item = sut.didSelectItem(at: indexPath)

    verify(storage.saveSelectedPaymentMethodValue(item.value!)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectCardThenShouldNavigateToCard() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemCard })!
    let indexPath = IndexPath(row: index, section: 0)
    sut.didSelectItem(at: indexPath)

    verify(delegate.viewModelShouldNavigateToCard(any())).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectCardTokenThenShouldNavigateToComplete() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemCardToken })!
    let indexPath = IndexPath(row: index, section: 0)
    let item = sut.didSelectItem(at: indexPath)

    verify(storage.saveSelectedPaymentMethodValue(item.value!)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectInstallmentsThenShouldNavigateToComplete() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemInstallments })!
    let indexPath = IndexPath(row: index, section: 0)
    let item = sut.didSelectItem(at: indexPath)

    verify(storage.saveSelectedPaymentMethodValue(item.value!)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }

  func testWhenDidSelectItemWhenDidSelectPayByLinkThenShouldNavigateToComplete() {
    let index = items.firstIndex(where: { $0 is PaymentMethodItemPayByLink })!
    let indexPath = IndexPath(row: index, section: 0)
    let item = sut.didSelectItem(at: indexPath)

    verify(storage.saveSelectedPaymentMethodValue(item.value!)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }

  func testWhenDidSelectCardTokenThenShouldMakeItVisible() {
    let cardToken = makeCardToken()
    let updatedConfiguration = configuration.copyWith(cardToken)
    sut.didSelectCardToken(cardToken)

    verify(service.makePaymentMethodItems(for: updatedConfiguration)).wasCalled()
    verify(delegate.viewModelDidUpdate(any())).wasCalled()
    verify(storage.saveSelectedPaymentMethodValue(cardToken.value)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }

  func testWhenDidSelectPayByLinkThenShouldComplete() {
    let payByLink = makePayByLink()
    sut.didSelectPayByLink(payByLink)

    verify(storage.saveSelectedPaymentMethodValue(payByLink.value)).wasCalled()
    verify(delegate.viewModel(any(), didComplete: any())).wasCalled()
  }
  
}

private extension PaymentMethodsViewModelTests {
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
