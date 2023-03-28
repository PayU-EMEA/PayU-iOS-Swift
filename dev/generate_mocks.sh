# https://mockingbirdswift.com/spm-package-quickstart

#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUCoreTests/Mocks \
  --testbundle PUCoreTests \
  --targets PUCore

  #!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUMastercardInstallmentsTests/Mocks \
  --testbundle PUMastercardInstallmentsTests \
  --targets PUMastercardInstallments

#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUPaymentCardTests/Mocks \
  --testbundle PUPaymentCardTests \
  --targets PUAPI PUCore PUPaymentCard

#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUPaymentCardScannerTests/Mocks \
  --testbundle PUPaymentCardScannerTests \
  --targets PUCore PUPaymentCardScanner

#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUPaymentMethodsTests/Mocks \
  --testbundle PUPaymentMethodsTests \
  --targets PUApplePay PUCore PUPaymentMethods PUTranslations

#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUThreeDSTests/Mocks \
  --testbundle PUThreeDSTests \
  --targets PUAPI PUThreeDS

#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUTranslationsTests/Mocks \
  --testbundle PUTranslationsTests \
  --targets PUCore PUTranslations

#!/bin/bash
set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/mockingbird/mockingbird generate \
  --project project.json \
  --output-dir Tests/PUWebPaymentsTests/Mocks \
  --testbundle PUWebPaymentsTests \
  --targets PUAPI PUWebPayments
