# Getting Started with WebPaymentsViewController

An example on how to interact with WebPaymentsViewController

## Example

```swift
import Foundation
import PUCore
import PUThreeDS
import PUWebPayments
import UIKit

class AwesomeViewController: UIViewController {

  // 1. Create `CVVAuthorizationService` and `SoftAcceptService` instances
  private let cvvAuthorizationService = CVVAuthorizationService.Factory().make()
  private let softAcceptService = SoftAcceptService.Factory().make()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 2. Setup `CVVAuthorizationService` and `SoftAcceptService` instances
    self.cvvAuthorizationService.delegate = self
    self.cvvAuthorizationService.presentingViewController = self
    self.softAcceptService.delegate = self
  }

  // 3. Start processing `OrderCreateResponse` received from the backend
  func process(_ orderCreateResponse: OrderCreateResponse) {
    orderCreateResponse.redirectUri == nil
    
    // 4. If the `redirectUri` does not exist - then, in most cases, the `statusCode` is `SUCCESS` and this means that transaction has been completed successfully
    ? processWithoutRedirectUrl(orderCreateResponse)
    
    // 5. Otherwise - process `redirectUri` based on the `statusCode`
    : processWithRedirectUrl(orderCreateResponse)
  }

  private func processWithoutRedirectUrl(_ orderCreateResponse: OrderCreateResponse) {
    // Complete transaction
  }

  private func processWithRedirectUrl(_ orderCreateResponse: OrderCreateResponse) {
  
    // 6. Check the `statusCode` of the `OrderCreateResponse`
    switch orderCreateResponse.status.statusCode {
    
      // 7. `SUCCESS` - means, that you need to redirect user to `WebPaymentsViewController` with `payByLink` requestType
      case .success:
        processWebPayment(.payByLink, orderCreateResponse)

      // 8. `WARNING_CONTINUE_3DS` - means, that you need to process the `3DS` flow as below
      case .warningContinue3DS:
        orderCreateResponse.iframeAllowed == true
        
        // 8.1 When `iframeAllowed` from `OrderCreateResponse` is TRUE, then process with `SoftAcceptService` 
        ? process3DS2Payment(orderCreateResponse.redirectUrl!)
        
        // 8.1 When `iframeAllowed` from `OrderCreateResponse` is FALSE, then you need to redirect user to `WebPaymentsViewController` with `threeDS` requestType
        : processWebPayment(.threeDS, orderCreateResponse)

      // 9. `WARNING_CONTINUE_CVV` - means, that you need to process the `CVV` flow as below
      case .warningContinueCVV:
        processCVVPayment(orderCreateResponse.redirectUrl!)
      
      // 10. `WARNING_CONTINUE_REDIRECT` - means, that you need to redirect user to `WebPaymentsViewController` with `payByLink` requestType   
      case .warningContinueRedirect:
        processWebPayment(.payByLink, orderCreateResponse)
    }
  }

  private func process3DS2Payment(_ redirectUrl: URL?) {
    guard let redirectUrl = redirectUrl else { return }
    let request = SoftAcceptRequest(redirectUrl: redirectUrl)
    softAcceptService.authenticate(request: request)
  }
  
    private func processCVVPayment(_ redirectUrl: URL) {
    let extractor = CVVAuthorizationExtractor()
    let refReqId = extractor.extractRefReqId(redirectUrl)!
    cvvAuthorizationService.authorize(refReqId: refReqId)
  }

  private func processWebPayment(_ requestType: WebPaymentsRequest.RequestType, _ orderCreateResponse: OrderCreateResponse) {
    let redirectUrl = URL(string: orderCreateResponse.redirectUri!)!
    let continueUrl = URL(string: Constants.Order.continueUrl)!
    let request = WebPaymentsRequest(requestType: requestType, redirectUrl: redirectUrl, continueUrl: continueUrl)
    let viewController = WebPaymentsViewController.Factory().make(request: request)
    let navigationController = UINavigationController(rootViewController: viewController)
    presentingViewController?.present(navigationController, animated: true)
    viewController.delegate = self
  }

}

extension AwesomeViewController: WebPaymentsViewControllerDelegate {
  func webPaymentsViewController(_ viewController: WebPaymentsViewController, didComplete result: WebPaymentsResult) {
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
    
      // 11. Complete the transaction or continue with one of the services (`CVVAuthorizationService`, `SoftAcceptService`, etc.)
      
      switch result.status {
        case .success:
          // The transaction was success. Navigate user to completion page, etc.

        case .failure:
          // The transaction was failed by error. Show it to user

        case .cancelled:
          // The transaction was cancelled by user

        case .continue3DS:
          // The transaction needs to be authorized by `SoftAcceptService`
          self.process3DS2Payment(result.url)

        case .continueCvv:
          // The transaction needs to be authorized by `CVVAuthorizationService`
          self.processCVVPayment(result.url)

        case .externalApplication:
          // The transaction was completed with redirection to the external app, for ex: Bank application

        case .creditExternalApplication:
          // The user was redirected to the browser to continue the application on the provider's form
      }
    }
  }
}

extension AwesomeViewController: SoftAcceptServiceDelegate {
  func softAcceptService(_ service: SoftAcceptService, didStartAuthentication request: SoftAcceptRequest) {
    // Show `UIActivityIndicatorView`, etc.
  }

  func softAcceptService(_ service: SoftAcceptService, didCompleteAuthentication status: SoftAcceptStatus) {
    // Complete the transaction or not based on the `status` 
  }
}
```
