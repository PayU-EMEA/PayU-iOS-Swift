# Getting Started with OfferViewController

An example on how to interact with PUMastercardInstallments

## Overview

Before you start working with this package, please visit [developers.payu.com](https://developers.payu.com/en/mci.html).

## Example

```swift
import UIKit
import PUCore
import PUMastercardInstallments

class AwesomeViewController: UIViewController {

  // ... Your code goes here

  func presentOfferViewController() {
    // 1. Get the `InstallmentProposal` from backend
    let proposal: InstallmentProposal = // ... Your code goes here

    // 2. Create `OfferViewController` instance, set the `delegate` to it and present it
    let viewController = OfferViewController.Factory().make(proposal: proposal)
    let navigationController = UINavigationController(rootViewController: viewController)
    present(navigationController, animated: true)
    viewController.delegate = self
  }
}

// 3. Implement `OfferViewControllerDelegate` methods
extension AwesomeViewController: OfferViewControllerDelegate {
  func offerViewController(_ viewController: OfferViewController, didComplete result: InstallmentResult) {
    // 4. Send `result` to backend
  }

  func offerViewModelDidCancel(_ viewController: OfferViewController) {
    
  }
}
```
