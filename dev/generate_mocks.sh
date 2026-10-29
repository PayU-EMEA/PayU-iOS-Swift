#!/bin/bash
# Generates test mocks with Mockolo for protocols annotated with `/// @mockable`.
# https://github.com/uber/mockolo

set -eu

MOCKOLO_VERSION="2.7.0"
MOCKOLO_DIR=".build/mockolo/${MOCKOLO_VERSION}"
MOCKOLO="${MOCKOLO_DIR}/mockolo"

if [ ! -x "${MOCKOLO}" ]; then
  mkdir -p "${MOCKOLO_DIR}"
  curl -sSL "https://github.com/uber/mockolo/releases/download/${MOCKOLO_VERSION}/mockolo.macos-universal.tar.gz" \
    | tar xz -C "${MOCKOLO_DIR}"
fi

# generate <TestTarget> <SourceModule>...
# Mocks every annotated protocol of the source modules into Tests/<TestTarget>/Mocks.
generate() {
  local target="$1"
  shift
  local sources=()
  for module in "$@"; do
    sources+=("${module}/Sources/${module}")
  done
  mkdir -p "Tests/${target}/Mocks"
  "${MOCKOLO}" \
    --sourcedirs "${sources[@]}" \
    --destination "Tests/${target}/Mocks/Mocks.generated.swift" \
    --testable-imports "$@" \
    --enable-args-history \
    --mock-final \
    --logging-level 3
}

generate PUCoreTests PUCore
generate PUPaymentCardTests PUAPI PUCore PUPaymentCard
generate PUPaymentCardScannerTests PUCore PUPaymentCardScanner
generate PUPaymentMethodsTests PUApplePay PUCore PUPaymentMethods PUTranslations
generate PUThreeDSTests PUAPI PUThreeDS
generate PUTranslationsTests PUCore PUTranslations
generate PUWebPaymentsTests PUAPI PUWebPayments
