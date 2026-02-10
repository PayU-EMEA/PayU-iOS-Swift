## 2.3.11
* Fix issue with enter blik code on payment with blik token
* Allow enable blikCode payment method using PayU configuration class
* Upgrade Kingfisher 

## 2.3.10
* Add Lithuanian language
* Do not require ShippingContact for ApplePay
* Fix problem with switch to the next field in the card input


## 2.3.9
* Fix Logo in the navigation bar for iOS 26

## 2.3.8
* Fix Sectigo certificate for older iOS versions

## 2.3.7
* Fix Blik code issue
* Update PayU logo

## 2.3.6
* Fix Sectigo certificate format
* Upgrade Kingfisher

## 2.3.5
* Handle WebView navigation actions from within iframes and other about URI scheme matching URLs, like about:srcdoc
* Don't display URLs from outside the main frame in the WebView's address bar
* Handle a case where there's no URL in the WebView's navigation action with a .cancel decision

## 2.3.4
* Continuation of credit applications in the browser for given providers

## 2.3.3
* New certificate for ssl pinning, new sandbox url

## 2.3.2
* Adjustments for camera support
* Upgrade Kingfisher

## 2.3.1
* Upgrade Kingfisher

## 2.3.0
* [Add] Explicitly Token type for `PaymentCardService.tokenize`
* Function `tokenize(agreement: Bool, completionHandler: @escaping (Result<CardToken, Error>)` is deprecated. Use the `tokenize(type: TokenType, completionHandler: @escaping (Result<CardToken, Error>)` instead.
* [Fix] Stored ApplePay method

## 2.2.0
* Upgrade Kingfisher
* Update iOS version to 13

## 2.1.0
* [Fix] Hidden card data when screenshot
* Update iOS version to 12
* Removed Mastercard Installments

## 2.0.6
* [Fix] Show Blik Code input
* [Fix] Remembering the last selected payment method on Payment Methods Widget

## 2.0.5
* Added PrivacyInfo

## 2.0.4
* Fixed cs translation

## 2.0.3
* Cleared translations
* Added new languages - Bulgarian, Greek, Croatian, Russian, Slovak
* Updated Kingfisher version

## 2.0.2
* Fixed of keyboard not hiding
* Auto focus to next field on card widget

## 2.0.1
* Updated links to terms and condition

## 2.0.0
* Updated source code from Objective-C to Swift
* Migrated `.xcframework` to `Swift Package`
