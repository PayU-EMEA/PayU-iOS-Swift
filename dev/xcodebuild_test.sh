XCODE_SCHEME="PUSDK-Package"
XCODE_DESTINATION="platform=iOS Simulator,OS=18.5,arch=arm64,name=iPhone 16 Pro"

echo "✅ xcodebuild test $XCODE_SCHEME ..."
xcodebuild \
  -scheme "$XCODE_SCHEME" \
  -destination "$XCODE_DESTINATION" \
  -testLanguage en \
  -testRegion en_US \
  test
