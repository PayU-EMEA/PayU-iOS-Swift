# Getting Started with BlikAlertViewControllerPresenter

An example on how to interact with BlikAlertViewControllerPresenter

## Example

```swift
import PUPaymentMethods
import UIKit

class AwesomeViewController: UIViewController {

  // 1. Create the `BlikAlertViewControllerPresenter` instance
  private let blikAlertViewControllerPresenter = BlikAlertViewControllerPresenter.Factory().make()

  // ... Your code goes here

  func presentBlikAlertViewControllerPresenter() {
  
    // 2. Call `presentBlikAlertViewController` method of `BlikAlertViewControllerPresenter`
    blikAlertViewControllerPresenter.presentBlikAlertViewController(
      from: self,
      onDidConfirm: onDidConfirmBlik,
      onDidCancel: onDidCancelBlik)
  }

  // 3. Implement callbacks
  private func onDidConfirmBlik(_ blikAuthorizationCode: String) {
    print(blikAuthorizationCode)
  }

  private func onDidCancelBlik() {
    print("onDidCancelBlik")
  }
}
```
