# PayU SDK Lite

PayU mobile SDK for iOS.
Supports: iOS 10.x and above

## Integration using Cocoapods

PayU SDK for iOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "PayULite"
```

**Notice:** To be able to push apps integrated with PayU SDK Lite into the App Store you have to add an additional step to the app build phases which allows removing unwanted symbols from the framework. To do this follow the steps:
1. In Xcode: Click on your project in the file list, choose your target under TARGETS, click the Build Phases tab and add a New Run Script Phase by clicking the little plus icon in the top left
2. Paste the following script:

    ```
    APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

    # This script loops through the frameworks embedded in the application, tries to find PayU SDK framework and
    # removes unused architectures.
    find "$APP_PATH" -name 'PayU_SDK*.framework' -type d | while read -r FRAMEWORK
    do
    FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
    FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
    echo "Trimming $FRAMEWORK_EXECUTABLE_PATH:"

    EXTRACTED_ARCHS=()

    for ARCH in $ARCHS
    do
    echo " - Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
    lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
    EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
    done

    echo " - Merging extracted architectures: ${ARCHS}"
    lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
    rm "${EXTRACTED_ARCHS[@]}"

    echo " - Replacing original executable with thinned version"
    rm "$FRAMEWORK_EXECUTABLE_PATH"
    mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

    done
    ```

Once you integrated the pod you can use it in your project by adding the import statement:

```
import PayU_SDK_Lite
```

## Documentation:
*  [Usage](docs/markup/README.md)
*  [Script](docs)
