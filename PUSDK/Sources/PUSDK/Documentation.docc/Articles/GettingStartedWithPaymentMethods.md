# PUPaymentMethods

Constains necessary classes, structures, extensions to allow users to select the payment method from the list. It has the business logic of ordering, etc.

> Important: POS details are required

## Documentation 

* [Payment methods retrieve](https://developers.payu.com/en/restapi.html#Transparent_retrieve)

## Overview

This package provides models and UI that allows users to select the payment method from the list

| ![](paymentMethods.paymentMethodsViewController) | ![](paymentMethods.PBLPaymentMethodsViewController) | ![](paymentMethods.paymentMethodsWidget) |
| ------------------------------------------------ | --------------------------------------------------- | ---------------------------------------- |
| ``PaymentMethodsViewController``                 | `PBLPaymentMethodsViewController`                   | ``PaymentMethodsWidget``                 |

## Topics

### Examples

- <doc:GettingStartedWithPaymentMethodsExampleOfBlikAlertViewControllerPresenter>
- <doc:GettingStartedWithPaymentMethodsExampleOfPaymentMethodsStorage>
- <doc:GettingStartedWithPaymentMethodsExampleOfPaymentMethodsViewController>
- <doc:GettingStartedWithPaymentMethodsExampleOfPaymentMethodsWidget>

### Core

- ``PaymentMethodsConfiguration``
- ``PaymentMethodsProcessor``
- ``PaymentMethodsStorageProtocol``

### BLIK

- ``BlikAlertViewControllerPresenter``
- ``BlikAlertViewControllerPresenterProtocol``

### ViewController

- ``PaymentMethodsViewController``
- ``PaymentMethodsViewControllerDelegate``

### Widget

- ``PaymentMethodsWidget``
- ``PaymentMethodsWidgetDelegate``

### Protocols 

- ``PaymentMethodsProcessorProtocol``
- ``PaymentMethodsProcessorBlikAuthorizationCodePresenter``
- ``PaymentMethodsProcessorApplePayPaymentRequestProvider``
