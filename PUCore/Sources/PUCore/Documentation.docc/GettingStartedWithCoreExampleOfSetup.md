# Getting Started with PUCore

An example on how to prepare PUCore

## Overview

To start working with elements, provided by PayU packages, you need to setup the basics of ``PayU``

## Example

```swift
import PUCore

// 1. In your app entry point set necessary properties
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    PayU.currencyCode = "PLN"
    PayU.languageCode = "pl"
    PayU.pos = POS(id: "300746", environment: .sandbox)

    // ... Your code goes here

    return true
  }
}
```
