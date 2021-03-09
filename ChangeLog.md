# PayU SDK Lite Change Log

## Release 0.9.5
Prepared on Wed, 09/03/2020
### Changes:
* Added `PUCardBrandImageProvider` class so from now there is ability to get default brand image providers for `MasterCard`, `Maestro`, `Visa` payment methods. Local stored images for these providers has been removed. 
* Convert fat `.framework` to `.xcframework`

## Release 0.9.4
Prepared on Wed, 03/12/2020
### Changes:
* Added `PUAuthorizationResultExternalApplication` value to `PUAuthorizationResult`
* Added automatic 3rd part applications open for `PEX` and `PBL` payment methods
* `trimSymbols.sh`  has been removed from source files and need to be added [manually](https://github.com/PayU-EMEA/PayU-iOS).

## Release 0.9.3
Prepared on Wed, 16/09/2020
### Changes:
* invalid SSL certificates removed
* fix issue with BLIK logo dissapear in `PUPaymentWidget` in case when there are no `blikTokens` provided to `PUPaymentMethodsConfiguration` instance

## Release 0.9.2
Prepared on Wed, 19/08/2020
### Changes:
* add `PUPaymentMethodParser` to parse payment methods
* make `brand` property on PUCardToken deprecated, merchants should use 'scheme' instead
* replace `refReqId` property with `userInfo` in `PUAuthorizationDelegate` method which might contain error or refReqId
* add  `logoImageProvider` property to `PUVisualStyle` instance to give merchants ability to customize SDK logo in navigationBar
* replace 'MM/YYYY' with 'MM/YY' placeholder in `PUAddCardService`
* add `PUCardExpirationDateValidator` class to validate inputed card expiration date (supports both 'MM/YY' and 'MM/YYYY' formats)
* add `PUActivityIndicatorView` instance to `PUWebAuthorizationViewController` to indicate webView loading state.  
* add `cardBrandImageProvider` and `bankBrandImageProvider` properties to  `PUPaymentMethodsConfiguration` to add ability to change 'card' and 'bank' icons in the `PUPaymentMethodsViewController`

## Release 0.9.1
Prepared on Mon, 08/06/2020
### Changes:
* add new PBL values to accept EURO

## Release 0.9.0
Prepared on Thu, 30/04/2020
### Changes:
* update `PUVisualStyle` properties. Now every styleable ui item has it's own class to be styled with  (`PUCardVisualStyle`, `PUInputVisualStyle`, etc.)
* add dynamic color provider for iOS 13
* add dark-mode support
* add dynamic brand image provider for payment methods (`PUCardToken`, `PUPayByLink`, `PUPexToken`, `PUApplePay`, `PUBlikToken`)
* fix mistake in cz localization
* update card providers logos (mastercard, maestro, visa)
* add headers to card tokenization request 
* add new ssl-pinning root certificate

## Release 0.8.6
Prepared on: Tue, 28/11/2019
### Changes:
* fixes issue with adding new card and cvv authorization in sandbox environment

## Release 0.8.5
Prepared on: Tue, 5/11/2019
### Changes:
* disables dark mode on iOS 13
* enables navigation bar color customization

## Release 0.8.4
Prepared on: Tue, 26/09/2019
### Changes:
* minor buxfixes

## Release 0.8.2
Prepared on: Tue, 19/04/2019

### Changes:
* adds support for new currencies in Apple Pay. Supported currencies: EUR, USD, GBP, PLN, CZK, RON, HUF, HRK, SEK, NOK, DKK
* adds Hungarian language support

## Release 0.8.1
Prepared on: Tue, 27/02/2019

### Changes:
* updates translations

## Release 0.8.0
Prepared on: Tue, 25/02/2019

### Changes:
* adds BLIK 2.0 payment method
* updates card validation logic
    * new patterns for card number validation
    * new pattern for expiration date validation: only "MM/YYYY" format is acceptable, date can't be later than 20 years from now
    * small UX improvements
* updates translations

## Release 0.7.1
Prepared on: Tue, 8/01/2019

### Changes:
* fixes localization

## Release 0.7.0
Prepared on: Fri, 7/12/2018

### Changes:
* PEX (PayU Express) payment methods support
* Small naming changes to improve compatibility with PayU backend JSON request/response field names:
    * payment method arguments changes: `title` -> `name`, `imageUrl` -> `brandImageUrl`, `token`-> `value`, etc
    * payment request arguments changes: `responseUrl` -> `responseUri`
    * changes classes names `PU3DSAuthorizationRequest` -> `PU3dsAuthorizationRequest`, `PUCVVAuthorizationRequest` -> `PUCvvAuthoriationRequest`, etc
    * changes in `PUWebAuthorizationBuilder`: `buildPBLModuleWithAuthorizationRequest` methods are now `viewControllerWithPayByLinkAuthorizationRequest`

## Release 0.6.0
Prepared on: Thu, 8/11/2018.

### Changes:

* Fixed SDK crash on non http/https redirect in web payment web view.
* Fixed nullability on `PUPaymentWidgetService.selectedPaymentMethod` property.
* Updated Trim script to work well with Cocoapods.
* Internal changes to URL matching in PayByLink web view payment. 
