//
//  WebPaymentsViewModelTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
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

    delegate = WebPaymentsViewModelDelegateMock()
    matcher = WebPaymentsUrlMatcherMock()
    urlOpener = WebPaymentsUrlOpenerMock()
    request = WebPaymentsRequest(requestType: requestType, redirectUrl: redirectUrl, continueUrl: continueUrl)
    sut = WebPaymentsViewModel(matcher: matcher, urlOpener: urlOpener, request: request)

    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    requestType = nil
    continueUrl = nil
    redirectUrl = nil

    matcher = nil
    urlOpener = nil
    delegate = nil

    request = nil
    sut = nil
  }

  func testNavigationPolicyForUrlShouldInformDelegateThatCurrentUrlDidUpdate() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .notMatched }
    sut.navigationPolicy(for: url, inMainFrame: true) { _ in }
    XCTAssertTrue(delegate.webPaymentsViewModelDidUpdateArgValues.contains { $0.currentUrl == url })
  }

  func testNavigationPolicyForUrlReturnsAllowForNotMatchedMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .notMatched }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .allow)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertEqual(delegate.webPaymentsViewModelCallCount, 0)
  }

  func testNavigationPolicyForUrlReturnsCancelForSuccessMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .success }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertTrue(
      delegate.webPaymentsViewModelArgValues
        .contains { $0.result == WebPaymentsResult(status: .success, url: sut.currentUrl) }
    )
  }

  func testNavigationPolicyForUrlReturnsCancelForFailureMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .failure }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertTrue(
      delegate.webPaymentsViewModelArgValues
        .contains { $0.result == WebPaymentsResult(status: .failure, url: sut.currentUrl) }
    )
  }

  func testNavigationPolicyForUrlReturnsAllowForContinue3DSMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .continue3DS }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .allow)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertTrue(
      delegate.webPaymentsViewModelArgValues
        .contains { $0.result == WebPaymentsResult(status: .continue3DS, url: sut.currentUrl) }
    )
  }

  func testNavigationPolicyForUrlReturnsAllowForContinueCVVMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .continueCvv }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .allow)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertTrue(
      delegate.webPaymentsViewModelArgValues
        .contains { $0.result == WebPaymentsResult(status: .continueCvv, url: sut.currentUrl) }
    )
  }

  func testNavigationPolicyForUrlReturnsCancelForExternalApplicationMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .externalApplication }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertTrue(
      delegate.webPaymentsViewModelArgValues
        .contains { $0.result == WebPaymentsResult(status: .externalApplication, url: sut.currentUrl) }
    )
  }
    
  func testNavigationPolicyForUrlReturnsCancelAndPresentsDialogForCreditExternalApplicationMatcherResult() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .creditExternalApplication }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertTrue(
      delegate.webPaymentsViewModelShouldPresentProviderRedirectDialogArgValues
        .contains { $0.url == url }
    )
  }
  
  func testNavigationPolicyForNotMatchedUrlOutsideMainFrameDoesntUpdateAddressBar() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    matcher.resultHandler = { _ in .notMatched }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: false) { policy = $0 }
    XCTAssertEqual(policy, .allow)
    XCTAssertTrue(matcher.resultArgValues.contains(url))
    XCTAssertFalse(
      delegate.webPaymentsViewModelShouldPresentProviderRedirectDialogArgValues
        .contains { $0.url == url }
    )
  }

  func testNavigationPolicyWithDecisionHandlerCancelsAndCompletesWhenUniversalLinkWasOpened() throws {
    let url = URL(string: "https://bank.example.com/login")!
    matcher.resultHandler = { _ in .notMatched }
    urlOpener.openUniversalLinkHandler = { _, completion in
      completion(true)
    }

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }

    XCTAssertEqual(policy, .cancel)
    XCTAssertTrue(urlOpener.openUniversalLinkArgValues.contains(url))
    XCTAssertTrue(
      delegate.webPaymentsViewModelArgValues
        .contains { $0.result == WebPaymentsResult(status: .externalApplication, url: url) }
    )
  }

  func testNavigationPolicyWithDecisionHandlerAllowsWhenUniversalLinkWasNotOpened() throws {
    let url = URL(string: "https://bank.example.com/login")!
    matcher.resultHandler = { _ in .notMatched }
    urlOpener.openUniversalLinkHandler = { _, completion in
      completion(false)
    }

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }

    XCTAssertEqual(policy, .allow)
    XCTAssertEqual(delegate.webPaymentsViewModelCallCount, 0)
  }

  func testNavigationPolicyWithDecisionHandlerDoesntOpenUniversalLinkOutsideMainFrame() throws {
    let url = URL(string: "https://bank.example.com/login")!
    matcher.resultHandler = { _ in .notMatched }

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: false) { policy = $0 }

    XCTAssertEqual(policy, .allow)
    XCTAssertEqual(urlOpener.openUniversalLinkCallCount, 0)
  }

  func testNavigationPolicyWithDecisionHandlerDoesntOpenUniversalLinkForRedirectAndContinueUrlHosts() throws {
    let urls = [
      URL(string: "https://www.payu.com/pay?orderId=1")!,
      continueUrl!
    ]
    matcher.resultHandler = { _ in .notMatched }

    for url in urls {
      var policy: WKNavigationActionPolicy?
      sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
      XCTAssertEqual(policy, .allow)
    }
    XCTAssertEqual(urlOpener.openUniversalLinkCallCount, 0)
  }

  func testNavigationPolicyWithDecisionHandlerDoesntOpenUniversalLinkForMatchedUrl() throws {
    let url = URL(string: "https://bank.example.com/login")!
    matcher.resultHandler = { _ in .continue3DS }

    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }

    XCTAssertEqual(policy, .allow)
    XCTAssertEqual(urlOpener.openUniversalLinkCallCount, 0)
  }

  func testNavigationPolicyForExternalApplicationMatcherResultOpensUrl() throws {
    let url = URL(string: "bankapp://pay")!
    matcher.resultHandler = { _ in .externalApplication }
    var policy: WKNavigationActionPolicy?
    sut.navigationPolicy(for: url, inMainFrame: true) { policy = $0 }
    XCTAssertEqual(policy, .cancel)
    XCTAssertTrue(urlOpener.openArgValues.contains(url))
  }

  func testDidTapBackShouldCallDelegateToPresentBackAlertDialog() throws {
    sut.didTapBack()
    XCTAssertGreaterThan(delegate.webPaymentsViewModelShouldPresentBackAlertDialogCallCount, 0)
  }

  func testDidTapConfirmBackShouldCallDelegateToCompleteWithCancelStatus() throws {
    sut.didTapConfirmBack()

    XCTAssertTrue(
      delegate.webPaymentsViewModelArgValues
        .contains { $0.result == WebPaymentsResult(status: .cancelled, url: sut.currentUrl) }
    )
  }

  func testDidFailNavigationWithErrorShouldCallDelegateToUpdateCurrentUrl() throws {
    struct ErrorMock: Error {
      static let error = NSError(
        domain: "domain",
        code: NSURLErrorSecureConnectionFailed
      )
    }

    sut.didFailNavigation(with: ErrorMock.error)
    XCTAssertTrue(delegate.webPaymentsViewModelDidUpdateArgValues.contains { $0.currentUrl == sut.currentUrl })
    XCTAssertGreaterThan(delegate.webPaymentsViewModelShouldPresentSSLAlertDialogCallCount, 0)
  }
    
  func testDidProceedWithInstallmentsExternalApplicationShouldCompleteWithExternalApplicationStatus() throws {
    let url = URL(string: "https://www.payu.com?authenticationId=\(UUID().uuidString)")!
    sut.didProceedWithCreditExternalApplication(url)
      XCTAssertTrue(
        delegate.webPaymentsViewModelArgValues
          .contains { $0.result == WebPaymentsResult(status: .externalBrowser, url: sut.currentUrl) }
      )
  }
    
  func testDidAbortInstallmentsExternalApplicationShouldCompleteWithExternalApplicationStatus() throws {
    sut.didAbortCreditExternalApplication()
      XCTAssertTrue(
        delegate.webPaymentsViewModelArgValues
          .contains { $0.result == WebPaymentsResult(status: .cancelled, url: sut.currentUrl) }
      )
  }
}
