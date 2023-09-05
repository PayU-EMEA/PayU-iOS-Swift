# PUSDK

Allows to make payments in PayU ecosystem.

## Requirements

* iOS 11.0 or higher

## Getting Started

* [Payment Flow](https://developers.payu.com/en/mobile_sdk.html)
* [Mobile Integration](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/)
* [Backend Integration](https://developers.payu.com/en/restapi.html)

## [PUSDK](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk) consists of:

* [PUApplePay](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithapplepay)
* [PUCore](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithcore)
* [PUMastercardInstallments](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithmastercardinstallments)
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
* Dependency Rule: `Branch`
* Branch: `main`

Then choose Package Products you want to use:

* `PUSDK` - when you want to use all Packages (PUApplePay, PUPaymentMethods, PUWebPayments, etc.)
* `{PackageName}` - when you want to use single Package

### CocoaPods

When you want to use all Packages (PUApplePay, PUPaymentMethods, PUWebPayments, etc.):
* `pod 'PUSDK', :git => 'https://github.com/PayU-EMEA/PayU-iOS-Swift.git', :branch => 'main'`

When you want to use single Package:
* `pod 'PUSDK/{PackageName}' , :git => 'https://github.com/PayU-EMEA/PayU-iOS-Swift.git', :branch => 'main'`

## Example

The SDK contains the `Example` project, where you can find example of how to implement different feature, such as: [PUApplePay](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithapplepay), [PUPaymentCard](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithpaymentcard), [PUPaymentMethods](https://payu-emea.github.io/PayU-iOS-Swift/documentation/pusdk/gettingstartedwithpaymentmethods), etc. 

1. Clone git repo: `git clone https://github.com/PayU-EMEA/PayU-iOS-Swift.git`
2. Navigate to cloned Folder: `cd PayU-iOS-Swift`
3. Open: `PayU-iOS-Swift/Example/Example.xcodeproj`
4. Update: `Example/Core/Models/Constants.swift`
5. Once you run the app, add your POS details: `Settings -> Environment -> Create -> (Enter POS details) -> Save`
