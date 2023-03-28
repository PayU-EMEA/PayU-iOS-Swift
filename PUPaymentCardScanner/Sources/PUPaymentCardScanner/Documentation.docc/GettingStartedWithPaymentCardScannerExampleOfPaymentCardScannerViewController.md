# Getting Started with PaymentCardScannerViewController

An example on how to interact with PaymentCardScannerViewController

## Example

```swift
import PUPaymentCardScanner
import UIKit

class AwesomeViewController: UIViewController {

  // ... Your code goes here

  func presentPaymentCardScannerViewController() {
  
    // 1. Create `PaymentCardScannerViewController` instance
    let viewController = PaymentCardScannerViewController.Factory().make(option: .numberAndDate)

    // 2. Create `PortraitNavigationController` instance with `PaymentCardScannerViewController` as a rootViewController
    let navigationController = PortraitNavigationController(rootViewController: viewController)

    // 3. Present created `navigationController`
    present(navigationController, animated: true)

    // 4. Set `delegate` to `PaymentCardScannerViewController` instance
    viewController.delegate = self
  }
}

// 5. Implement `PaymentCardScannerViewControllerDelegate` methods
extension AwesomeViewController: PaymentCardScannerViewControllerDelegate {
  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didProcess result: PaymentCardScannerResult) {
    print(result)
  }

  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didFail error: Error) {
    print(error)
  }

  func paymentCardScannerViewControllerDidCancel(_ viewController: PaymentCardScannerViewController) {
    print("paymentCardScannerViewControllerDidCancel")
  }
}
```
