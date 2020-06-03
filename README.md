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
2. Drag the new Run Script phase below the Embed Pods Framework build phase, expand it and paste the following script:
    ```
    ${PODS_ROOT}/PayULite/libs/trimSymbols.sh
    ```


Once you integrated the pod you can use it in your project by adding the import statement:

```
import PayU_SDK_Lite
```

## Usage documentation

You can find the documentation [here](docs/markup/README.md) or in the docs folder.