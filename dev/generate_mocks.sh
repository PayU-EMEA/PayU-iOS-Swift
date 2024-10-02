# https://mockingbirdswift.com/spm-package-quickstart

set -eu
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUCoreTests/Mocks \
  --testbundle PUCoreTests \
  --targets PUCore

set -eu
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUPaymentCardTests/Mocks \
  --testbundle PUPaymentCardTests \
  --targets PUAPI PUCore PUPaymentCard

set -eu
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUPaymentCardScannerTests/Mocks \
  --testbundle PUPaymentCardScannerTests \
  --targets PUCore PUPaymentCardScanner

set -eu
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUPaymentMethodsTests/Mocks \
  --testbundle PUPaymentMethodsTests \
  --targets PUApplePay PUCore PUPaymentMethods PUTranslations

set -eu
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUThreeDSTests/Mocks \
  --testbundle PUThreeDSTests \
  --targets PUAPI PUThreeDS

set -eu
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUTranslationsTests/Mocks \
  --testbundle PUTranslationsTests \
  --targets PUCore PUTranslations

set -eu
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUWebPaymentsTests/Mocks \
  --testbundle PUWebPaymentsTests \
  --targets PUAPI PUWebPayments
