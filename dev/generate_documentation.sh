# https://developer.apple.com/documentation/xcode/distributing-documentation-to-external-developers
# https://forums.swift.org/t/generate-documentation-failing-on-import-uikit/55202/6

REPOSITORY_NAME="PayU-iOS-Swift"

XCODE_SCHEME="PUSDK"
XCODE_DERIVED_DATA_PATH="docc"
XCODE_DESTINATION="generic/platform=ios"
XCODE_OTPUT_PATH="docs"

# Removes `DerivedData` if exists
echo "✅ Removing ~/Library/Developer/Xcode/DerivedData ..."
rm -rf ~/Library/Developer/Xcode/DerivedData

# Removes `docc` folder if exists
echo "✅ Removing existing $XCODE_DERIVED_DATA_PATH ..."
rm -rf docc

# Removes `docs` folder if exists
echo "✅ Removing existing $XCODE_OTPUT_PATH ..."
rm -rf docs

echo "✅ xcodebuild build $XCODE_SCHEME ..."
# Build
xcodebuild build \
  -scheme "$XCODE_SCHEME" \
  -destination "$XCODE_DESTINATION" \
  -quiet

echo "✅ xcodebuild docbuild $XCODE_SCHEME ..."
# Generate
xcodebuild docbuild \
  -scheme "$XCODE_SCHEME" \
  -derivedDataPath "$XCODE_DERIVED_DATA_PATH" \
  -destination "$XCODE_DESTINATION" \
  -quiet

echo "✅ xcodebuild docbuild $XCODE_SCHEME ..."
# Generate
xcodebuild docbuild \
  -scheme "$XCODE_SCHEME" \
  -derivedDataPath "$XCODE_DERIVED_DATA_PATH" \
  -destination "$XCODE_DESTINATION" \
  -quiet

echo "✅ Transforming documentation for static hosting ..."
# Creates static page for documentation
cd "$XCODE_DERIVED_DATA_PATH"/Build/Products/Debug-iphoneos
$(xcrun --find docc) process-archive \
  transform-for-static-hosting "$XCODE_SCHEME".doccarchive \
  --output-path ../../../../"$XCODE_OTPUT_PATH" \
  --hosting-base-path "$REPOSITORY_NAME"

echo "✅ Removing $XCODE_DERIVED_DATA_PATH ..."
cd ../../../../
rm -rf docc
