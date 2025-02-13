# Getting Started with PaymentCardWidget

An example on how to interact with PaymentCardWidget

## Requirements

> Important: POS details are required

## Example

```swift
import PUPaymentCard
import UIKit

class AwesomeViewController: ViewController {

  // ... Your code goes here
  
  // 1. Create the `PaymentCardService` instance
  private let configuration = PaymentCardWidget.Configuration()
  private let service = PaymentCardService.Factory().make()

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 2. Create PaymentCardWidget
    view.addSubview(
      PaymentCardWidget.Factory().make(
        configuration: configuration, 
        service: service)
    )
    
    // 3. Add buttons (for ex: "Save and use", "Save")
    // ... Your code goes here
  }
  
  // MARK: - Actions
  // 4. Implement actions
  @objc private func actionSaveAndUse(_ sender: Any) {
    tokenize(tokenType: TokenType.MULTI)
  }

  @objc private func actionUse(_ sender: Any) {
    tokenize(tokenType: TokenType.SINGLE)
  }
  
  // MARK: - Private Methods
  private func tokenize(tokenType: TokenType) {
    service.tokenize(type: tokenType) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let cardToken):
          // 5. Send `cardToken` to backend as a part of OrderCreateRequest 
        case .failure(let error):
          print(error)
      }
    }
  }
}
```
