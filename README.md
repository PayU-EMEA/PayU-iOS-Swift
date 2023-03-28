# PUSDK

Allows to make payments in PayU ecosystem.

## Requirements

* iOS 11.0 or higher

## Getting Started

* [Payment Flow](https://developers.payu.com/en/mobile_sdk.html)
* [Mobile Integration](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/)
* [Backend Integration](https://developers.payu.com/en/restapi.html)

## [PUSDK](https://payu-emea.github.io/PayU-iOS/documentation/pusdk) consists of:

* [PUApplePay](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithapplepay)
* [PUCore](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithcore)
* [PUMastercardInstallments](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithmastercardinstallments)
* [PUPaymentCard](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithpaymentcard)
* [PUPaymentCardScanner](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithpaymentcardscanner)
* [PUPaymentMethods](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithpaymentmethods)
* [PUTheme](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwiththeme)
* [PUThreeDS](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwiththreeds)
* [PUTranslations](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithtranslations)
* [PUWebPayments](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithwebpayments)

## Installation

### [Swift Package Manager](https://www.swift.org/package-manager/)

To add a package dependency to your Xcode project, select File > Add Packages. You can also navigate to your target’s General pane, and in the `Frameworks, Libraries, and Embedded Content` section, click the + button, select `Add Other`, and choose `Add Package Dependency`. 

* Package URL: `https://github.com/PayU-EMEA/PayU-iOS.git`
* Dependency Rule: `Branch`
* Branch: `release/2.0.0`

Then choose Package Products you want to use:

* `PUSDK` - when you want to use the whole Package (Apple Pay, Payment Methods, Web Payments, etc.)
* `{PackageName}` - when you want to use just one special Package

### CocoaPods

* `pod 'PUSDK', :git => 'https://github.com/PayU-EMEA/PayU-iOS.git', :branch => 'release/2.0.0'`
* `pod 'PUSDK/{PackageName}' , :git => 'https://github.com/PayU-EMEA/PayU-iOS.git', :branch => 'release/2.0.0'`

## Example

The SDK contains the `Example` project, where you can find examlpe of how to imppement different feature, such as: [PUApplePay](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithapplepay), [PUPaymentCard](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithpaymentcard), [PUPaymentMethods](https://payu-emea.github.io/PayU-iOS/documentation/pusdk/gettingstartedwithpaymentmethods), etc. 

1. Clone git repo: `git clone https://github.com/PayU-EMEA/PayU-iOS/tree/release/2.0.0`
2. Open: `PayU-iOS/Example/Example.xcodeproj`
3. Update: `Example/Core/Models/Constants.swift`
4. Once you run the app, add your POS details: `Settings -> Environment -> Create -> (Enter POS details) -> Save`
