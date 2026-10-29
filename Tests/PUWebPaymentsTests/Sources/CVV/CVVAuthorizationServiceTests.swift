//
//  CVVAuthorizationServiceTests.swift
//

import XCTest

@testable import PUWebPayments

final class CVVAuthorizationServiceTests: XCTestCase {

  private var delegate: CVVAuthorizationServiceDelegateMock!
  private var presenter: CVVAuthorizationPresenterProtocolMock!
  private var repository: CVVAuthorizationRepositoryProtocolMock!
  private var sut: CVVAuthorizationService!

  override func setUp() {
    super.setUp()
    delegate = CVVAuthorizationServiceDelegateMock()
    presenter = CVVAuthorizationPresenterProtocolMock()
    repository = CVVAuthorizationRepositoryProtocolMock()

    sut = CVVAuthorizationService(presenter: presenter, repository: repository)
    sut.delegate = delegate
  }

  func testWhenAuthorizeWithRefReqIdThenShouldCallPresenter() throws {
    let refReqId = UUID().uuidString
    sut.authorize(refReqId: refReqId)

    XCTAssertGreaterThan(presenter.presentCVVAlertViewControllerCallCount, 0)
  }

  func testWhenAuthorizeWithRefReqIdAndConfirmCVVThenShouldCallRepository()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    presenter.presentCVVAlertViewControllerHandler = { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    sut.authorize(refReqId: refReqId)

    XCTAssertTrue(
      repository.authorizeCVVArgValues
        .contains(CVVAuthorizationRequest(cvv: cvv, refReqId: refReqId))
    )
  }

  func
    testWhenAuthorizeWithRefReqIdAndCancelThenShouldCallDelegateToCompleteWithCancelledResult()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    presenter.presentCVVAlertViewControllerHandler = { viewController, onConfirm, onCancel in
      onCancel()
    }

    sut.authorize(refReqId: refReqId)

    XCTAssertFalse(
      repository.authorizeCVVArgValues
        .contains(CVVAuthorizationRequest(cvv: cvv, refReqId: refReqId))
    )

    XCTAssertTrue(
      delegate.cvvAuthorizationServiceArgValues
        .contains { $0.status == .cancelled }
    )
  }

  func
    testWhenAuthorizeWithRefReqIdAndAuthorizationIsSuccessThenShouldCallDelegateToCompleteWithSuccessResult()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    presenter.presentCVVAlertViewControllerHandler = { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    repository.authorizeCVVHandler = { cvvAuthorizationRequest, completionHandler in
      completionHandler(.success(.success))
    }

    sut.authorize(refReqId: refReqId)

    XCTAssertTrue(
      repository.authorizeCVVArgValues
        .contains(CVVAuthorizationRequest(cvv: cvv, refReqId: refReqId))
    )

    XCTAssertTrue(
      delegate.cvvAuthorizationServiceArgValues
        .contains { $0.status == .success }
    )
  }

  func
    testWhenAuthorizeWithRefReqIdAndAuthorizationIsCancelledThenShouldCallDelegateToCompleteWithCancelledResult()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    presenter.presentCVVAlertViewControllerHandler = { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    repository.authorizeCVVHandler = { cvvAuthorizationRequest, completionHandler in
      completionHandler(.success(.cancelled))
    }

    sut.authorize(refReqId: refReqId)

    XCTAssertTrue(
      repository.authorizeCVVArgValues
        .contains(CVVAuthorizationRequest(cvv: cvv, refReqId: refReqId))
    )

    XCTAssertTrue(
      delegate.cvvAuthorizationServiceArgValues
        .contains { $0.status == .cancelled }
    )
  }

  func
    testWhenAuthorizeWithRefReqIdAndAuthorizationIsFailureThenShouldCallDelegateToCompleteWithFailureResult()
    throws
  {
    struct ErrorMock: Error {}

    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    presenter.presentCVVAlertViewControllerHandler = { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    repository.authorizeCVVHandler = { cvvAuthorizationRequest, completionHandler in
      completionHandler(.failure(ErrorMock()))
    }

    sut.authorize(refReqId: refReqId)

    XCTAssertTrue(
      repository.authorizeCVVArgValues
        .contains(CVVAuthorizationRequest(cvv: cvv, refReqId: refReqId))
    )

    XCTAssertGreaterThan(delegate.cvvAuthorizationServiceDidFailCallCount, 0)
  }
}
