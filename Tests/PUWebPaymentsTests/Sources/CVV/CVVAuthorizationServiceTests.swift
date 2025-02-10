//
//  CVVAuthorizationServiceTests.swift
//

import Mockingbird
import XCTest

@testable import PUWebPayments

final class CVVAuthorizationServiceTests: XCTestCase {

  private var delegate: CVVAuthorizationServiceDelegateMock!
  private var presenter: CVVAuthorizationPresenterProtocolMock!
  private var repository: CVVAuthorizationRepositoryProtocolMock!
  private var sut: CVVAuthorizationService!

  override func setUp() {
    super.setUp()
    delegate = mock(CVVAuthorizationServiceDelegate.self)
    presenter = mock(CVVAuthorizationPresenterProtocol.self)
    repository = mock(CVVAuthorizationRepositoryProtocol.self)

    sut = CVVAuthorizationService(presenter: presenter, repository: repository)
    sut.delegate = delegate
  }

  func testWhenAuthorizeWithRefReqIdThenShouldCallPresenter() throws {
    let refReqId = UUID().uuidString
    sut.authorize(refReqId: refReqId)

    verify(
      presenter
        .presentCVVAlertViewController(
          from: any(),
          onConfirm: any(),
          onCancel: any())
    )
    .wasCalled()
  }

  func testWhenAuthorizeWithRefReqIdAndConfirmCVVThenShouldCallRepository()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    given(
      presenter
        .presentCVVAlertViewController(
          from: any(),
          onConfirm: any(),
          onCancel: any())
    )
    .will { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    sut.authorize(refReqId: refReqId)

    verify(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: CVVAuthorizationRequest(
            cvv: cvv,
            refReqId: refReqId
          ),
          completionHandler: any())
    )
    .wasCalled()
  }

  func
    testWhenAuthorizeWithRefReqIdAndCancelThenShouldCallDelegateToCompleteWithCancelledResult()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    given(
      presenter
        .presentCVVAlertViewController(
          from: any(),
          onConfirm: any(),
          onCancel: any())
    )
    .will { viewController, onConfirm, onCancel in
      onCancel()
    }

    sut.authorize(refReqId: refReqId)

    verify(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: CVVAuthorizationRequest(
            cvv: cvv,
            refReqId: refReqId
          ),
          completionHandler: any())
    )
    .wasNeverCalled()

    verify(
      delegate
        .cvvAuthorizationService(
          any(),
          didComplete: .cancelled)
    )
    .wasCalled()
  }

  func
    testWhenAuthorizeWithRefReqIdAndAuthorizationIsSuccessThenShouldCallDelegateToCompleteWithSuccessResult()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    given(
      presenter
        .presentCVVAlertViewController(
          from: any(),
          onConfirm: any(),
          onCancel: any())
    )
    .will { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    given(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: any(),
          completionHandler: any())
    )
    .will { cvvAuthorizationRequest, completionHandler in
      completionHandler(.success(.success))
    }

    sut.authorize(refReqId: refReqId)

    verify(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: CVVAuthorizationRequest(
            cvv: cvv,
            refReqId: refReqId
          ),
          completionHandler: any())
    )
    .wasCalled()

    verify(
      delegate
        .cvvAuthorizationService(
          any(),
          didComplete: .success)
    )
    .wasCalled()
  }

  func
    testWhenAuthorizeWithRefReqIdAndAuthorizationIsCancelledThenShouldCallDelegateToCompleteWithCancelledResult()
    throws
  {
    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    given(
      presenter
        .presentCVVAlertViewController(
          from: any(),
          onConfirm: any(),
          onCancel: any())
    )
    .will { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    given(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: any(),
          completionHandler: any())
    )
    .will { cvvAuthorizationRequest, completionHandler in
      completionHandler(.success(.cancelled))
    }

    sut.authorize(refReqId: refReqId)

    verify(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: CVVAuthorizationRequest(
            cvv: cvv,
            refReqId: refReqId

          ),
          completionHandler: any())
    )
    .wasCalled()

    verify(
      delegate
        .cvvAuthorizationService(
          any(),
          didComplete: .cancelled)
    )
    .wasCalled()
  }

  func
    testWhenAuthorizeWithRefReqIdAndAuthorizationIsFailureThenShouldCallDelegateToCompleteWithFailureResult()
    throws
  {
    struct ErrorMock: Error {}

    let refReqId = UUID().uuidString
    let cvv = UUID().uuidString

    given(
      presenter
        .presentCVVAlertViewController(
          from: any(),
          onConfirm: any(),
          onCancel: any())
    )
    .will { viewController, onConfirm, onCancel in
      onConfirm(cvv)
    }

    given(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: any(),
          completionHandler: any())
    )
    .will { cvvAuthorizationRequest, completionHandler in
      completionHandler(.failure(ErrorMock()))
    }

    sut.authorize(refReqId: refReqId)

    verify(
      repository
        .authorizeCVV(
          cvvAuthorizationRequest: CVVAuthorizationRequest(
            cvv: cvv,
            refReqId: refReqId
          ),
          completionHandler: any())
    )
    .wasCalled()

    verify(
      delegate
        .cvvAuthorizationService(
          any(),
          didFail: any())
    )
    .wasCalled()
  }
}
