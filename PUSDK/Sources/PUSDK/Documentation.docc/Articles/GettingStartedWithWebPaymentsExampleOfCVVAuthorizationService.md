# Getting Started with CVVAuthorizationService

An example on how to interact with SoftAcceptService

## Example

```swift
import PUWebPayments
import UIKit

class AwesomeViewController: UIViewController {

  // 1. Create instance of `CVVAuthorizationService`
  private let service = CVVAuthorizationService.Factory().make()

  // 2. When you receive the `OrderCreateResponse` with `WARNING_CONTINUE_CVV` `statusCode` call `CVVAuthorizationService.authorize(refReqId:)` method
  private func onDidReceiveOrderCreateResponseWithExpectedStatusCode() {

    // 3. Set the `delegate` and `presentingViewController` to service
    service.delegate = self
    service.presentingViewController = self

    // 4. Create `redirectUrl`
    let redirectUrl = // `redirectUri` from OrderCreateResponse, for ex: "https://merch-prod.snd.payu.com/front/threeds?refReqId=19a1b4d3c416b6df943d6b337831"

    // 5. Extract `refReqId` from `redirectUrl`
    let extractor = CVVAuthorizationExtractor()
    let refReqId = extractor.extractRefReqId(redirectUrl)!

    // 6. Set the delegate to `service` and implement `SoftAcceptServiceDelegate` methods
    service.delegate = self

    // 7. Call `authenticate` method
    service.authenticate(request: request)
    
  }
}

// MARK: - SoftAcceptServiceDelegate
extension AwesomeViewController: CVVAuthorizationServiceDelegate {
  func cvvAuthorizationService(_ service: CVVAuthorizationService, didComplete status: CVVAuthorizationResult) {
    // Chech the transaction status, etc.
  }

  func cvvAuthorizationService(_ service: CVVAuthorizationService, didFail error: Error) {
    // Show error to user
  }
}
```
