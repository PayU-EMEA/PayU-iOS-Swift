# Getting Started with PaymentMethodsViewController

An example on how to interact with PaymentMethodsViewController

> Important: POS details are required

## Documentation 

* [Payment methods retrieve](https://developers.payu.com/en/restapi.html#Transparent_retrieve)

| ![](paymentMethods.paymentMethodsViewController) | ![](paymentMethods.PBLPaymentMethodsViewController) |
| ------------------------------------------------ | --------------------------------------------------- |
| ``PaymentMethodsViewController``                 | `PBLPaymentMethodsViewController`                   |

## Example

```swift
import PUCore
import PUPaymentMethods
import UIKit

class AwesomeViewController: UIViewController {

  // MARK: - Private Properties
  // 1. Create references to `PaymentMethodsStorageProtocol` and `PaymentMethodsProcessor`
  private let processor = PaymentMethodsProcessor.Factory().make()
  private let storage: PaymentMethodsStorageProtocol = AwesomeDatabase()

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // 2. Setup `PaymentMethodsProcessor` instance
    setupPaymentMethodsProcessor()
  }

  // MARK: - Private Methods
  private func setupPaymentMethodsProcessor() {
    // 3. Implement `PaymentMethodsProcessorApplePayPaymentRequestProvider` protocol method
    processor.applePayPaymentRequestProvider = self

    // 4. Implement `PaymentMethodsProcessorBlikAuthorizationCodePresenter` protocol method
    processor.blikAuthorizationCodePresenter = self
  }

  // 5. Present `PaymentMethodsViewController` by any of your actions, for ex. `Show Payment Methods` button
  @objc private func presentPaymentMethodsViewController() {
  
    // 6. Get the `blikTokens`, `cardTokens`, `payByLinks` from the backend.
    let blikTokens: [BlikToken] = // ...
    let cardTokens: [CardToken] = // ...
    let payByLinks: [PayByLink] = // ...

    // 7. Create `PaymentMethodsConfiguration` instance
    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens, 
      cardTokens: cardTokens, 
      payByLinks: payByLinks)

    // 8. Present `PaymentMethodsViewController` instance and set delegate to it
    let viewController = PaymentMethodsViewController.Factory().make(configuration, storage: storage)
    navigationController?.pushViewController(viewController, animated: true)

    // 9. Implement `PaymentMethodsViewControllerDelegate` protocol methods
    viewController.delegate = self
  }

  // 11. Process `PaymentMethod` into `PayMethod` with `PaymentMethodsProcessor`
  private func processPaymentMethod(_ paymentMethod: PaymentMethod) {
    processor.process(
      paymentMethod: paymentMethod,
      onDidProcess: onDidProcess,
      onDidFail: onDidFail)
  }

  // 12. Implement `PaymentMethodsProcessor` callbacks
  private func onDidProcess(_ payMethod: PayMethod) {
    // 13. Send `payMethod` to backend as a part of OrderCreateRequest 
  }

  private func onDidFail(_ error: Error) {
    // Show error to user, etc.
  }
}

// 3.1. Implement `PaymentMethodsProcessorApplePayPaymentRequestProvider` protocol method
extension AwesomeViewController: PaymentMethodsProcessorApplePayPaymentRequestProvider {
  func paymentRequest() -> PaymentRequest {
    PaymentRequest(
      countryCode: "pl",
      currencyCode: "PLN",
      merchantIdentifier: "merchantIdentifier",
      paymentSummaryItems: [
        PaymentRequest.SummaryItem(label: "Futomaki", amount: 1599),
        PaymentRequest.SummaryItem(label: "Napkin", amount: 49),
        PaymentRequest.SummaryItem(label: "Order", amount: 1599 + 49)
      ],
      shippingContact: PaymentRequest.Contact(
        emailAddress: "email@address.com")
    )
  }
}

// 4.1. Implement `PaymentMethodsProcessorBlikAuthorizationCodePresenter` protocol method
extension AwesomeViewController: PaymentMethodsProcessorBlikAuthorizationCodePresenter {
  func presentingViewController() -> UIViewController? {
    self
  }
}

// 9.1. Implement `PaymentMethodsViewControllerDelegate` protocol methods
extension AwesomeViewController: PaymentMethodsViewControllerDelegate {
  func viewController(_ viewController: PaymentMethodsViewController, didSelect paymentMethod: PaymentMethod) {
    // 10. Start processing `paymentMethod` with `PaymentMethodsProcessor`
    processPaymentMethod(paymentMethod)
  }

  func viewController(_ viewController: PaymentMethodsViewController, didDelete paymentMethod: PaymentMethod) {
    // Send the request to the backdend to delete the `PaymentMethod`
  }
}
``
