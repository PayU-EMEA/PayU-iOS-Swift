//
//  WebPaymentsViewModelTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUWebPayments

final class WebPaymentsViewModelTests: XCTestCase {

  private var requestType: WebPaymentsRequest.RequestType!
  private var continueUrl: URL!
  private var redirectUrl: URL!

  private var delegate: WebPaymentsViewModelDelegateMock!
  private var matcher: WebPaymentsUrlMatcherMock!
  private var request: WebPaymentsRequest!
  private var sut: WebPaymentsViewModel!

  override func setUp() {
    super.setUp()

    requestType = .payByLink
    continueUrl = URL(string: "https://www.payu.com")!
    redirectUrl = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!

    delegate = mock(WebPaymentsViewModelDelegate.self)
    matcher = mock(WebPaymentsUrlMatcher.self)
    request = WebPaymentsRequest(requestType: requestType, redirectUrl: redirectUrl, continueUrl: continueUrl)
    sut = WebPaymentsViewModel(matcher: matcher, request: request)

    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    requestType = nil
    continueUrl = nil
    redirectUrl = nil

    reset(matcher)
    reset(delegate)

    request = nil
    sut = nil
  }

  func testNavigationPolicyForUrlShouldInformDelegateThatCurrentUrlDidUpdate() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.notMatched)
    _ = sut.navigationPolicy(for: url, inMainFrame: true)
    verify(delegate.webPaymentsViewModel(any(), didUpdate: url)).wasCalled()
  }

  func testNavigationPolicyForUrlReturnsAllowForNotMatchedMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.notMatched)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: true), .allow)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: any()))
    .wasNeverCalled()
  }

  func testNavigationPolicyForUrlReturnsCancelForSuccessMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.success)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: true), .cancel)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: WebPaymentsResult(
            status: .success,
            url: sut.currentUrl)))
    .wasCalled()
  }

  func testNavigationPolicyForUrlReturnsCancelForFailureMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.failure)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: true), .cancel)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: WebPaymentsResult(
            status: .failure,
            url: sut.currentUrl)))
    .wasCalled()
  }

  func testNavigationPolicyForUrlReturnsAllowForContinue3DSMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.continue3DS)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: true), .allow)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: WebPaymentsResult(
            status: .continue3DS,
            url: sut.currentUrl)))
    .wasCalled()
  }

  func testNavigationPolicyForUrlReturnsAllowForContinueCVVMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.continueCvv)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: true), .allow)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: WebPaymentsResult(
            status: .continueCvv,
            url: sut.currentUrl)))
    .wasCalled()
  }

  func testNavigationPolicyForUrlReturnsCancelForExternalApplicationMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.externalApplication)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: true), .cancel)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: WebPaymentsResult(
            status: .externalApplication,
            url: sut.currentUrl)))
    .wasCalled()
  }
    
  func testNavigationPolicyForUrlReturnsCancelAndPresentsDialogForCreditExternalApplicationMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.creditExternalApplication)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: true), .cancel)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModelShouldPresentProviderRedirectDialog(
          any(),
          url))
    .wasCalled()
  }
  
  func testNavigationPolicyForNotMatchedUrlOutsideMainFrameDoesntUpdateAddressBar() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.notMatched)
    XCTAssertEqual(sut.navigationPolicy(for: url, inMainFrame: false), .allow)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModelShouldPresentProviderRedirectDialog(
          any(),
          url))
    .wasNeverCalled()
  }

  func testDidTapBackShouldCallDelegateToPresentBackAlertDialog() throws {
    sut.didTapBack()
    verify(delegate.webPaymentsViewModelShouldPresentBackAlertDialog(any())).wasCalled()
  }

  func testDidTapConfirmBackShouldCallDelegateToCompleteWithCancelStatus() throws {
    sut.didTapConfirmBack()

    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: WebPaymentsResult(
            status: .cancelled,
            url: sut.currentUrl)))
    .wasCalled()
  }

  func testDidFailNavigationWithErrorShouldCallDelegateToUpdateCurrentUrl() throws {
    struct ErrorMock: Error {
      static let error = NSError(
        domain: "domain",
        code: NSURLErrorSecureConnectionFailed
      )
    }

    sut.didFailNavigation(with: ErrorMock.error)
    verify(delegate.webPaymentsViewModel(any(), didUpdate: sut.currentUrl)).wasCalled()
    verify(delegate.webPaymentsViewModelShouldPresentSSLAlertDialog(any())).wasCalled()
  }
    
  func testDidProceedWithInstallmentsExternalApplicationShouldCompleteWithExternalApplicationStatus() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    sut.didProceedWithCreditExternalApplication(url)
      verify(
        delegate
          .webPaymentsViewModel(
            any(),
            didComplete: WebPaymentsResult(
              status: .externalBrowser,
              url: sut.currentUrl)))
      .wasCalled()
  }
    
  func testDidAbortInstallmentsExternalApplicationShouldCompleteWithExternalApplicationStatus() throws {
    sut.didAbortCreditExternalApplication()
      verify(
        delegate
          .webPaymentsViewModel(
            any(),
            didComplete: WebPaymentsResult(
              status: .cancelled,
              url: sut.currentUrl)))
      .wasCalled()
  }
}
