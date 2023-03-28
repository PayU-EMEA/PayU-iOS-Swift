# Getting Started with PaymentMethodsWidget

An example on how to interact with PaymentMethodsWidget

> Important: POS details are required

## Documentation 

* [Payment methods retrieve](https://developers.payu.com/en/restapi.html#Transparent_retrieve)

| ![](paymentMethods.paymentMethodsWidget) | ![](paymentMethods.paymentMethodsWidget.selected) |
| ---------------------------------------- | ------------------------------------------------- |
| ``PaymentMethodsWidget``                 | ``PaymentMethodsWidget``                          |

## Example

```swift
import PUCore
import PUPaymentMethods
import UIKit

class AwesomeViewController: ViewController {

  // MARK: - Private Properties
  // 1. Create references to `PaymentMethodsWidget`, `PaymentMethodsStorageProtocol` and `PaymentMethodsProcessor`
  private let processor = PaymentMethodsProcessor.Factory().make()
  private let storage: PaymentMethodsStorageProtocol = AwesomeDatabase()
  private var widget: PaymentMethodsWidget!

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // 2. Setup `PaymentMethodsProcessor` instance
    setupPaymentMethodsProcessor()

    // 3. Setup `PaymentMethodsProcessor` instance
    setupPaymentMethodsWidget()
  }

  // MARK: - Private Methods
  private func setupPaymentMethodsProcessor() {
    // 4. Implement `PaymentMethodsProcessorApplePayPaymentRequestProvider` protocol method
    processor.applePayPaymentRequestProvider = self

    // 5. Implement `PaymentMethodsProcessorBlikAuthorizationCodePresenter` protocol method
    processor.blikAuthorizationCodePresenter = self
  }
  
  private func setupPaymentMethodsWidget() {

    // 5. Get `blikTokens`, `cardTokens`, `payByLinks` from the backend
    let blikTokens: [BlikToken] = // ...
    let cardTokens: [CardToken] = // ...
    let payByLinks: [PayByLink] = // ...

    // 7. Create `PaymentMethodsConfiguration` instance
    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens, 
      cardTokens: cardTokens, 
      payByLinks: payByLinks)

    // 8. Create `PaymentMethodsWidget` instance and hold reference to it
    widget = PaymentMethodsWidget.Factory().make(configuration: configuration, storage: storage)

    // 9. Implement `PaymentMethodsWidgetDelegate` protocol methods
    widget.delegate = self

    // 10. Set the `presentingViewController` as `self`
    widget.presentingViewController = self
    

    // 11. Place `widget` somewhere in your ViewController and set constaints
    view.addSubview(widget)
    widget.translatesAutoresizingMaskIntoConstraints = false
    widget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    widget.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
    widget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

    // 12. Add some `Pay` button to the screen, so when user tap it, you'll be able to start transaction
    let awesomeButton = // ...
    awesomeButton.addTarget(self, action: #selector(actionPay(_:)), for: .touchUpInside)
  }

  // MARK: - Actions

  // 13. Handle the case when user tapped the `Pay` button. 
  // If there is selected payment method, then start processing it.
  @objc private func actionPay(_ sender: Any) {
    if let paymentMethod = widget.paymentMethod {
      processPaymentMethod(paymentMethod)
    }
  }

  // 14. Process `PaymentMethod` into `PayMethod` with `PaymentMethodsProcessor`
  private func processPaymentMethod(_ paymentMethod: PaymentMethod) {
    processor.process(
      paymentMethod: paymentMethod,
      onDidProcess: onDidProcess,
      onDidFail: onDidFail)
  }

  // 15. Implement `PaymentMethodsProcessor` callbacks
  private func onDidProcess(_ payMethod: PayMethod) {
    // 16. Send `payMethod` to backend as a part of OrderCreateRequest 
  }

  private func onDidFail(_ error: Error) {
    // Show error to user, etc.
  }
}

// 9.1 Implement `PaymentMethodsWidgetDelegate` protocol methods
extension AwesomeViewController: PaymentMethodsWidgetDelegate {
  func paymentMethodsWidget(_ widget: PaymentMethodsWidget, didSelect paymentMethod: PaymentMethod) {
    // Enable / Disable your `Pay` button
  }

  func paymentMethodsWidget(_ widget: PaymentMethodsWidget, didDelete paymentMethod: PaymentMethod) {
    // Send the request to the backdend to delete the `PaymentMethod`
  }
}

// 4.1. Implement `PaymentMethodsProcessorApplePayPaymentRequestProvider` protocol method
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

// 5.1. Implement `PaymentMethodsProcessorBlikAuthorizationCodePresenter` protocol method
extension AwesomeViewController: PaymentMethodsProcessorBlikAuthorizationCodePresenter {
  func presentingViewController() -> UIViewController? {
    self
  }
}
```
