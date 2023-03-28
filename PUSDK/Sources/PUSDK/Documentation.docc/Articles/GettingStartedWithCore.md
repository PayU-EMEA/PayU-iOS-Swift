# PUCore

Constains necessary classes, structures, extensions to interact between packages.

## Overview

This package provides:

* helper classes to format and validate payment card
* helper classes to match the payment card providers
* core models of PayU ecosystem (``ApplePay``, ``BlikCode``, etc.)
* core assets

## Topics

### Examples

- <doc:GettingStartedWithCoreExampleOfSetup>

### Preconditions

- ``PayU``

### Core

- ``BrandImageProvider``
- ``Environment``
- ``POS``

### PaymentMethod

- ``PaymentMethod``

### Models

- ``ApplePay``
- ``BlikCode``
- ``BlikToken``
- ``CardToken``
- ``Installments``
- ``PayByLink``
- ``PaymentCardError``
- ``PaymentCardProvider``
- ``PaymentMethodValue``
- ``PayMethod``

### Helpers

- ``Console``

### Factories

- ``PaymentCardDateParserFactory``
- ``PaymentCardFormatterFactory``
- ``PaymentCardLuhnValidatorFactory``
- ``PaymentCardProviderFinderFactory``
- ``PaymentCardProviderMatcherFactory``
- ``PaymentCardValidatorFactory``
- ``TextFormatterFactory``

### Services

- ``PaymentCardDateParserProtocol``
- ``PaymentCardFormatterProtocol``
- ``PaymentCardLuhnValidatorProtocol``
- ``PaymentCardProviderFinderProtocol``
- ``PaymentCardProviderMatcherProtocol``
- ``PaymentCardValidatorProtocol``
- ``TextFormatterProtocol``
