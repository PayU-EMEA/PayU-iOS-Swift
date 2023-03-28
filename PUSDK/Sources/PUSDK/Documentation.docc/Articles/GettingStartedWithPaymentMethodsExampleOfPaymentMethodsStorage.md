# Getting Started with PaymentMethodsStorage

An example on how to interact with PaymentMethodsStorageProtocol

## Example

```swift
import PUPaymentMethods

// 1. Create Database which conforms to `PaymentMethodsStorageProtocol` protocol
class AwesomeDatabase: PaymentMethodsStorageProtocol {
  private var map: [String : String] = [:]
  
  // 2. Implement `PaymentMethodsStorageProtocol` protocol methods in associating with `currentUserId`
  func saveSelectedPaymentMethodValue(_ value: String) {
      map[currentUserId] = value
  }

  func getSelectedPaymentMethodValue() -> String? {
      map[currentUserId]
  }
}
```
