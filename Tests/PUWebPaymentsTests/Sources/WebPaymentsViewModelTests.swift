//
//  WebPaymentsViewModelTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
import WebKit
@testable import PUWebPayments

final class WebPaymentsViewModelTests: XCTestCase {

  private var requestType: WebPaymentsRequest.RequestType!
  private var continueUrl: URL!
  private var redirectUrl: URL!

  private var delegate: WebPaymentsViewModelDelegateMock!
  private var matcher: WebPaymentsUrlMatcherMock!
  private var urlOpener: WebPaymentsUrlOpenerMock!
  private var request: WebPaymentsRequest!
  private var sut: WebPaymentsViewModel!

  override func setUp() {
    super.setUp()

    requestType = .payByLink
    continueUrl = URL(string: "https://www.payu.com")!
    redirectUrl = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!

    delegate = mock(WebPaymentsViewModelDelegate.self)
    matcher = mock(WebPaymentsUrlMatcher.self)
    urlOpener = mock(WebPaymentsUrlOpener.self)
    request = WebPaymentsRequest(requestType: requestType, redirectUrl: redirectUrl, continueUrl: continueUrl)
    sut = WebPaymentsViewModel(matcher: matcher, urlOpener: urlOpener, request: request)

    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    requestType = nil
    continueUrl = nil
    redirectUrl = nil

    reset(matcher)
    reset(urlOpener)
    reset(delegate)

    request = nil
    sut = nil
  }

  func testNavigationPolicyForUrlShouldInformDelegateThatCurrentUrlDidUpdate() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.notMatched)
    sut.navigationPolicy(for: url, inMainFrame: true) { _ in }
    verify(delegate.webPaymentsViewModel(any(), didUpdate: url)).wasCalled()
  }

  func testNavigationPolicyForUrlReturnsAllowForNotMatchedMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    given(matcher.result(any())).willReturn(.notMatched)
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .allow)
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
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
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
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
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
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .allow)
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
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .allow)
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
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
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
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
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
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: false) { policy = $0 }
    XCTAssertEqual(policy, .allow)
    verify(matcher.result(url)).wasCalled()
    verify(
      delegate
        .webPaymentsViewModelShouldPresentProviderRedirectDialog(
          any(),
          url))
    .wasNeverCalled()
  }

  func testNavigationPolicyWithDecisionHandlerCancelsAndCompletesWhenUniversalLinkWasOpened() throws {
    let url = URL(string: "https://bank.example.com/login")!
    given(matcher.result(any())).willReturn(.notMatched)
    given(urlOpener.openUniversalLink(any(), completion: any())).will { (_: URL, completion: @escaping (Bool) -> Void) in
      completion(true)
    }

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }

    XCTAssertEqual(policy, .cancel)
    verify(urlOpener.openUniversalLink(url, completion: any())).wasCalled()
    verify(
      delegate
        .webPaymentsViewModel(
          any(),
          didComplete: WebPaymentsResult(
            status: .externalApplication,
            url: url)))
    .wasCalled()
  }

  func testNavigationPolicyWithDecisionHandlerAllowsWhenUniversalLinkWasNotOpened() throws {
    let url = URL(string: "https://bank.example.com/login")!
    given(matcher.result(any())).willReturn(.notMatched)
    given(urlOpener.openUniversalLink(any(), completion: any())).will { (_: URL, completion: @escaping (Bool) -> Void) in
      completion(false)
    }

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }

    XCTAssertEqual(policy, .allow)
    verify(delegate.webPaymentsViewModel(any(), didComplete: any())).wasNeverCalled()
  }

  func testNavigationPolicyWithDecisionHandlerDoesntOpenUniversalLinkOutsideMainFrame() throws {
    let url = URL(string: "https://bank.example.com/login")!
    given(matcher.result(any())).willReturn(.notMatched)

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: false) { policy = $0 }

    XCTAssertEqual(policy, .allow)
    verify(urlOpener.openUniversalLink(any(), completion: any())).wasNeverCalled()
  }

  func testNavigationPolicyWithDecisionHandlerDoesntOpenUniversalLinkForRedirectAndContinueUrlHosts() throws {
    let urls = [
      URL(string: "https://www.payu.com/pay?orderId=1")!,
      continueUrl!
    ]
    given(matcher.result(any())).willReturn(.notMatched)

    for url in urls {
      var policy: WKNavigationActionPolicy?
      sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
      XCTAssertEqual(policy, .allow)
    }
    verify(urlOpener.openUniversalLink(any(), completion: any())).wasNeverCalled()
  }

  func testNavigationPolicyWithDecisionHandlerDoesntOpenUniversalLinkForMatchedUrl() throws {
    let url = URL(string: "https://bank.example.com/login")!
    given(matcher.result(any())).willReturn(.continue3DS)

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }

    XCTAssertEqual(policy, .allow)
    verify(urlOpener.openUniversalLink(any(), completion: any())).wasNeverCalled()
  }

  func testNavigationPolicyForExternalApplicationMatcherResultOpensUrl() throws {
    let url = URL(string: "bankapp://pay")!
    given(matcher.result(any())).willReturn(.externalApplication)
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
    verify(urlOpener.open(url)).wasCalled()
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
