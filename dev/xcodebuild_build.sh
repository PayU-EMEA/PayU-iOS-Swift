XCODE_SCHEME="PUSDK-Package"
XCODE_DESTINATION="platform=iOS Simulator,OS=26.5,arch=arm64,name=iPhone 17 Pro"

echo "✅ xcodebuild $XCODE_SCHEME ..."
xcodebuild \
  -scheme "$XCODE_SCHEME" \
  -destination "$XCODE_DESTINATION" \
  build
