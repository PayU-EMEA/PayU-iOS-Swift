# How to translate String?

An example on how to translate strings

## Singular

```swift
import PUTranslations

let string = "card_number".localized()
print(string) // prints `Card number
```

## Plural

```swift
import PUTranslations

let formattedString = "number_of_installments".localized(numberCategory: .plural)
let oneInstallment = String(format: formattedString, 1)
let twoInstallments = String(format: formattedString, 2)

print(oneInstallment) // prints `1 installment`
print(twoInstallments) // prints `2 installments`
```
