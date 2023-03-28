# Getting Started with ApplePayService

An example on how to pay via Apple Pay

## Overview

To complete payment via Apple Pay, you need to pass ``PaymentRequest`` to ``ApplePayServiceProtocol/makePayment(paymentRequest:onDidAuthorize:onDidCancel:onDidFail:)``

## Backend Integration

* [Documentation](https://developers.payu.com/en/apple_pay.html)

## Example

```swift
import PUApplePay

// 1. Create ApplePayService instance
let service = ApplePayServiceFactory().make()

// 2. Create PaymentRequest instance
let paymentRequest = PaymentRequest(
  countryCode: "PL",
  currencyCode: "PLN",
  merchantIdentifier: "merchantIdentifier",
  paymentSummaryItems: [
    PaymentRequest.SummaryItem(
      label: "Futomaki",
      amount: 1599),
    PaymentRequest.SummaryItem(
      label: "Napkin",
      amount: 49),
    PaymentRequest.SummaryItem(
      label: "Order",
      amount: 1599 + 49)
  ],
  shippingContact: PaymentRequest.Contact(
    emailAddress: "email@address.com")
)

// 3. Call authorization
service.makePayment(
  paymentRequest: paymentRequest,
  onDidAuthorize: onDidAuthorizeApplePay,
  onDidCancel: onDidCancelApplePay,
  onDidFail: onDidFailApplePay)

// 4. Handle callbacks
private func onDidAuthorizeApplePay(_ authorizationCode: String) {
  print("onDidAuthorizeApplePay: \(authorizationCode)")
}

private func onDidCancelApplePay() {
  print("onDidCancelApplePay")
}

private func onDidFailApplePay(_ error: Error) {
  print("onDidFailApplePay")
}

// 5. Send ``PayMethod`` to PayU server
let payMethod = PayMethod(
  type: .pbl,
  value: PaymentMethodValue.applePay,
  authorizationCode: authorizationCode)

```
