# PUSDK

Lets you make payments in the PayU ecosystem.

## Requirements

* iOS 15.0 or higher

## Getting Started

The SDK does not create orders. Your server authenticates with PayU, retrieves payment methods and creates orders, and your app passes the results to the SDK. The server side is the same for iOS, Android and Flutter and is described in the PayU Developer Guide:

* [Mobile SDK](https://developers.payu.com/europe/docs/mobile-sdk/) – overview and supported features.
* [Payment Flow](https://developers.payu.com/europe/docs/mobile-sdk/payment-flow/) – how your app, your server, the SDK and PayU work together.
* [Server Integration](https://developers.payu.com/europe/docs/mobile-sdk/server-integration/) – the requests your server sends to PayU.
* [Testing](https://developers.payu.com/europe/docs/mobile-sdk/testing/) – testing in the Sandbox environment.

For the description of each package, see the [iOS SDK documentation](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/).

## [PUSDK](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk) consists of:

* [PUApplePay](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithapplepay)
* [PUCore](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithcore)
* [PUPaymentCard](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithpaymentcard)
* [PUPaymentCardScanner](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithpaymentcardscanner)
* [PUPaymentMethods](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithpaymentmethods)
* [PUTheme](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwiththeme)
* [PUThreeDS](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwiththreeds)
* [PUTranslations](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithtranslations)
* [PUWebPayments](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithwebpayments)

## Installation

### [Swift Package Manager](https://www.swift.org/package-manager/)

To add a package dependency to your Xcode project, select File > Add Packages. You can also navigate to your target’s General pane, and in the `Frameworks, Libraries, and Embedded Content` section, click the + button, select `Add Other`, and choose `Add Package Dependency`. 

* Package URL: `https://github.com/PayU-EMEA/PayU-iOS-Swift.git`
* Dependency Rule: `Up To Next Major Version`

Then choose Package Products you want to use:

* `PUSDK` - when you want to use all Packages (PUApplePay, PUPaymentMethods, PUWebPayments, etc.)
* `{PackageName}` - when you want to use a single package

### CocoaPods

When you want to use all Packages (PUApplePay, PUPaymentMethods, PUWebPayments, etc.):
* `pod 'PUSDK', :git => 'https://github.com/PayU-EMEA/PayU-iOS-Swift.git', :tag => 'VERSION'`

When you want to use a single package:
* `pod 'PUSDK/{PackageName}' , :git => 'https://github.com/PayU-EMEA/PayU-iOS-Swift.git', :tag => 'VERSION'`

## Example

The SDK contains the `Example` project, where you can find examples of how to implement different features, such as: [PUApplePay](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithapplepay), [PUPaymentCard](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithpaymentcard), [PUPaymentMethods](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithpaymentmethods), etc. 

## [Development](./dev/README.md)
