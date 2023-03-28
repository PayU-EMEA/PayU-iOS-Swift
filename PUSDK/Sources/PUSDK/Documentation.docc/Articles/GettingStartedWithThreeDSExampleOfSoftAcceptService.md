# Getting Started with SoftAcceptService

An example on how to interact with SoftAcceptService

## Example

```swift
import PUCore
import PUThreeDS
import UIKit

class AwesomeViewController: UIViewController {

  // 1. Create instance of `SoftAcceptService`
  private let service = SoftAcceptService.Factory().make()

  // 2. When you receive the `OrderCreateResponse` with `WARNING_CONTINUE_3DS` `statusCode` call `SoftAcceptService.authenticate(request:)` method
  private func onDidReceiveOrderCreateResponseWithExpectedStatusCode() {

    // 3. Create `redirectUrl`
    let redirectUrl = // `redirectUri` from OrderCreateResponse, for ex: "https://merch-prod.snd.payu.com/front/threeds/?authenticationId=b4e5781&refReqId=f0bd2a9f"

    // 4. Create `SoftAcceptRequest` instance
    let request = SoftAcceptRequest(redirectUrl: redirectUrl)

    // 5. Set the delegate to `service` and implement `SoftAcceptServiceDelegate` methods
    service.delegate = self

    // 6. Call `authenticate` method
    service.authenticate(request: request)
    
  }
}

// MARK: - SoftAcceptServiceDelegate
extension AwesomeViewController: SoftAcceptServiceDelegate {
  func softAcceptService(_ service: SoftAcceptService, didStartAuthentication request: SoftAcceptRequest) {
    // present dialog, etc.
  }

  func softAcceptService(_ service: SoftAcceptService, didCompleteAuthentication status: SoftAcceptStatus) {
    // In case of `AUTHENTICATION_SUCCESSFUL` you should wait for authorization result before showing any information about payment status.
  }
}
```
