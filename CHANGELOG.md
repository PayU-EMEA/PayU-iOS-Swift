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
* [Fix] Show Blick Code input
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
