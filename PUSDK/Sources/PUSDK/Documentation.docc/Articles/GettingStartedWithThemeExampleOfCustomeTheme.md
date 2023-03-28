# Getting Started with custom PUTheme

An example on how to create custom PUTheme

### 1. Create `PUTheme`

```swift
import PUTheme
import UIKit

// 1. Create Theme factory
struct ThemeFactory {

  // MARK: - Public Methods
  
  // 2. Create method which returns custom PUTheme instance with colors, fonts, sizes, etc.
  // PUTheme extensions allows you to set color for both light and dark appearance.
  // Also you can refer to existing theme and styles and just configure it.
  func make() -> PUTheme {
    let colorTheme = PUTheme.ColorTheme
      .Builder()
      .primary2(UIColor.supernova)
      .secondaryGray1(UIColor.shipGray | UIColor.white)
      .secondaryGray2(UIColor.shipGray | UIColor.white)
      .secondaryGray3(UIColor.shipGray | UIColor.white)
      .secondaryGray4(UIColor.white | UIColor.shipGray)
      .tertiary2(UIColor.red)
      .build()

    let textTheme = PUTheme.TextTheme
      .Builder(colorTheme)
      .build()

    return PUTheme
      .Builder()
      .buttonTheme(
        PUTheme.ElevatedButtonTheme
          .Builder(colorTheme, textTheme)
          .primary(
            PUTheme.ElevatedButtonTheme.Style
              .Builder()
              .backgroundColor(colorTheme.primary2)
              .borderStyle(
                PUTheme.BorderTheme.Style
                  .Builder()
                  .color(.clear)
                  .radius(0)
                  .width(0)
                  .build())
              .textStyle(textTheme.button.copyWith(color: colorTheme.secondaryGray4))
              .build())
          .secondary(
            PUTheme.ElevatedButtonTheme.Style
              .Builder()
              .backgroundColor(colorTheme.secondaryGray4)
              .borderStyle(
                PUTheme.BorderTheme.Style
                  .Builder()
                  .color(colorTheme.primary2)
                  .radius(0)
                  .width(1)
                  .build())
              .textStyle(textTheme.button)
              .build())
          .build())
      .cardTheme(
        PUTheme.CardTheme
          .Builder(colorTheme)
          .normal(
            PUTheme.CardTheme.Style
              .Builder()
              .backgroundColor(colorTheme.secondaryGray4)
              .borderStyle(PUTheme.BorderTheme.Style
                .Builder()
                .color(colorTheme.primary2)
                .radius(0)
                .width(1)
                .build())
              .build())
          .build())
      .colorTheme(colorTheme)
      .textInputTheme(
        PUTheme.TextInputTheme
          .Builder(colorTheme, textTheme)
          .normal(
            PUTheme.TextInputTheme.Style
              .Builder()
              .backgroundColor(colorTheme.secondaryGray4)
              .borderStyle(
                PUTheme.BorderTheme.Style
                  .Builder()
                  .color(colorTheme.primary2)
                  .radius(0)
                  .width(1)
                  .build())
              .textStyle(textTheme.bodyText1)
              .build())
          .error(
            PUTheme.TextInputTheme.Style
              .Builder()
              .backgroundColor(colorTheme.secondaryGray4)
              .borderStyle(
                PUTheme.BorderTheme.Style
                  .Builder()
                  .color(colorTheme.tertiary2)
                  .radius(0)
                  .width(1)
                  .build())
              .textStyle(textTheme.bodyText1)
              .build())
          .build())
      .textTheme(textTheme)
      .build()
  }
}
```

### 2. Set `PUTheme`

```swift
import PUCore
import PUTheme

// 3. Set the custome PUTheme somewhere in your app, for ex. in `AppDelegate`
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
      PUTheme.theme = ThemeFactory().make()

    // ... Your code goes here

    return true
  }
}
```
