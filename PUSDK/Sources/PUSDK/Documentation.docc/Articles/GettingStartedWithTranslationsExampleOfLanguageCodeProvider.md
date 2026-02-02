# Getting Started with LanguageCodeProvider

An example on how to use custom ``LanguageCodeProvider``

## Overview

``LanguageCodeProvider`` protocol allows to override default ``DefaultLanguageCodeProvider`` and set custom business logic around `languageCode` for translations.

## Example

```swift
import PUTranslations

// 1. Create object which implements ``LanguageCodeProvider`` 
// protocol methods (for ex. you want PayU elements to be in English)
struct CustomLanguageCodeProvider: LanguageCodeProvider {
  func languageCode() -> String { "en" }
}

// 2. Use it
let string = "card_number".localized(languageCodeProvider: CustomLanguageCodeProvider())
print(string) // prints `Card number`
```
