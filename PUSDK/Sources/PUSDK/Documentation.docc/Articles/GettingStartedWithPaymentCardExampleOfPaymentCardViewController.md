# Getting Started with PaymentCardViewController

An example on how to interact with PaymentCardViewController

## Requirements

> Important: POS details are required

| ![](paymentCard.paymentCardViewController) | ![](paymentCard.paymentCardViewController.error) | 
| ------------------------------------------ | ------------------------------------------------ | 
| ``PaymentCardViewController``              | ``PaymentCardViewController``                    |

## Example

```swift
import PUPaymentCard
import UIKit

class AwesomeViewController: UIViewController {

  // ... Your code goes here

  func presentPaymentCardViewController() {
  
    // 2. Create `PaymentCardViewController` instance, set the `delegate` to it and present it
    let configuration = PaymentCardViewController.Configuration()
    let viewController = PaymentCardViewController.Factory().make(configuration: configuration)
    let navigationController = UINavigationController(rootViewController: viewController)
    present(navigationController, animated: true)
    viewController.delegate = self
  }
}

extension AwesomeViewController: PaymentCardViewControllerDelegate {
  func paymentCardViewController(_ viewController: PaymentCardViewController, didComplete cardToken: CardToken) {
    // 3. Send `cardToken` to backend as a part of OrderCreateRequest
  }
}
```
