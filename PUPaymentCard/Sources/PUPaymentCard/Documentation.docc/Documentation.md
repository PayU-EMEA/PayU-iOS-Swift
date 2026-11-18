# ``PUPaymentCard``

Contains necessary classes, structures, extensions to allow users to enter / scan card details and later put the result to OrderCreateRequest

> Important: POS details are required

## Documentation

* [Card Payments](https://developers.payu.com/europe/docs/card-payments/)

## Overview

This package provides models and UI that allows users to enter / scan card details

| ![](paymentCard.paymentCardViewController) | ![](paymentCard.paymentCardViewController.error) | 
| ------------------------------------------ | ------------------------------------------------ | 
| ``PaymentCardViewController``              | ``PaymentCardViewController``                    |

## Topics

### Examples

- <doc:GettingStartedWithPaymentCardExampleOfPaymentCardViewController>
- <doc:GettingStartedWithPaymentCardExampleOfPaymentCardWidget>

### Models

- ``PaymentCardViewController/Configuration``
- ``PaymentCardWidget/Configuration``

### Service

- ``PaymentCardService``
- ``PaymentCardServiceProtocol``

### ViewController

- ``PaymentCardViewController``
- ``PaymentCardViewControllerDelegate``

### Widgets

- ``PaymentCardWidget``
- ``TermsAndConditionsView``
