//
//  PUVisualTheme.swift
//
//  Created by PayU S.A. on 15/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

public struct PUTheme {

  public static var theme = PUTheme.Builder().build()

  // MARK: - BorderTheme
  public struct BorderTheme {

    // MARK: - Style
    public struct Style {

      // MARK: - Public Properties
      public static let defaultRadius: CGFloat = 8.0
      public static let defaultWidth: CGFloat = 1.0

      public static let none = Style.Builder()
        .color(.clear)
        .radius(defaultRadius)
        .width(.zero)
        .build()

      public let color: UIColor
      public let radius: CGFloat
      public let width: CGFloat

      // MARK: - Builder
      public class Builder {

        // MARK: - Private Properties
        private var color: UIColor = .clear
        private var radius: CGFloat = Style.defaultRadius
        private var width: CGFloat = Style.defaultWidth

        // MARK: - Initialization
        public init() {  }

        // MARK: - Public Methods
        public func color(_ value: UIColor) -> Self {
          self.color = value
          return self
        }

        public func radius(_ value: CGFloat) -> Self {
          self.radius = value
          return self
        }

        public func width(_ value: CGFloat) -> Self {
          self.width = value
          return self
        }

        public func build() -> Style {
          return Style(
            color: color,
            radius: radius,
            width: width)
        }
      }
    }
  }

  // MARK: - CardTheme
  public struct CardTheme {

    // MARK: - Style
    public struct Style {

      // MARK: - Public Properties
      public let backgroundColor: UIColor
      public let borderStyle: BorderTheme.Style

      // MARK: - Builder
      public class Builder {

        // MARK: - Private Properties
        private var backgroundColor: UIColor!
        private var borderStyle: BorderTheme.Style!

        // MARK: - Initialization
        public init() {  }

        // MARK: - Public Methods
        public func backgroundColor(_ value: UIColor) -> Self {
          self.backgroundColor = value
          return self
        }

        public func borderStyle(_ value: BorderTheme.Style) -> Self {
          self.borderStyle = value
          return self
        }

        public func build() -> Style {
          return Style(
            backgroundColor: backgroundColor,
            borderStyle: borderStyle)
        }
      }
    }

    // MARK: - Public Properties
    public let normal: Style

    // MARK: - Builder
    public class Builder {

      // MARK: - Private Properties
      private let colorTheme: ColorTheme
      private lazy var normal = Style.Builder()
        .backgroundColor(colorTheme.secondaryGray4)
        .borderStyle(BorderTheme.Style.Builder()
          .color(colorTheme.secondaryGray3)
          .build())
        .build()

      // MARK: - Public Methods
      public init(_ colorTheme: ColorTheme) {
        self.colorTheme = colorTheme
      }

      public func normal(_ value: Style) -> Self {
        self.normal = value
        return self
      }

      public func build() -> CardTheme {
        return CardTheme(
          normal: normal)
      }
    }
  }

  // MARK: - ColorTheme
  public struct ColorTheme {

    // MARK: - Private Properties
    private static let primary2 = UIColor(hex: "#FF438f29")!
    private static let secondaryGray1 = UIColor(hex: "#FF3F3F3F")!
    private static let secondaryGray2 = UIColor(hex: "#FF777777")!
    private static let secondaryGray3 = UIColor(hex: "#FFE3E4E2")!
    private static let secondaryGray4 = UIColor(hex: "#FFF7F7F7")!
    private static let tertiary2 = UIColor(hex: "#FF951247")!

    // MARK: - Private Properties
    public let primary2: UIColor
    public let secondaryGray1: UIColor
    public let secondaryGray2: UIColor
    public let secondaryGray3: UIColor
    public let secondaryGray4: UIColor
    public let tertiary2: UIColor

    // MARK: - Builder
    public class Builder {
      private var primary2: UIColor = ColorTheme.primary2
      private var secondaryGray1: UIColor = ColorTheme.secondaryGray1 | ColorTheme.secondaryGray4
      private var secondaryGray2: UIColor = ColorTheme.secondaryGray2 | ColorTheme.secondaryGray3
      private var secondaryGray3: UIColor = ColorTheme.secondaryGray3 | ColorTheme.secondaryGray2
      private var secondaryGray4: UIColor = ColorTheme.secondaryGray4 | ColorTheme.secondaryGray1
      private var tertiary2: UIColor = ColorTheme.tertiary2

      // MARK: - Initialization
      public init() {  }

      // MARK: - Public Properties
      public func primary2(_ value: UIColor) -> Self {
        self.primary2 = value
        return self
      }

      public func secondaryGray1(_ value: UIColor) -> Self {
        self.secondaryGray1 = value
        return self
      }

      public func secondaryGray2(_ value: UIColor) -> Self {
        self.secondaryGray2 = value
        return self
      }

      public func secondaryGray3(_ value: UIColor) -> Self {
        self.secondaryGray3 = value
        return self
      }

      public func secondaryGray4(_ value: UIColor) -> Self {
        self.secondaryGray4 = value
        return self
      }

      public func tertiary2(_ value: UIColor) -> Self {
        self.tertiary2 = value
        return self
      }

      public func build() -> ColorTheme {
        return ColorTheme(
          primary2: primary2,
          secondaryGray1: secondaryGray1,
          secondaryGray2: secondaryGray2,
          secondaryGray3: secondaryGray3,
          secondaryGray4: secondaryGray4,
          tertiary2: tertiary2)
      }
    }
  }

  // MARK: - ElevatedButtonTheme
  public struct ElevatedButtonTheme {

    // MARK: - Style
    public struct Style {
      // MARK: - Private Properties
      private static let defaultHeight: CGFloat = 44.0

      // MARK: - Public Properties
      public let backgroundColor: UIColor
      public let borderStyle: BorderTheme.Style
      public let height: CGFloat
      public let textStyle: TextTheme.Style

      // MARK: - Builder
      public class Builder {

        // MARK: - Private Properties
        private var backgroundColor: UIColor!
        private var borderStyle: BorderTheme.Style!
        private var height = Style.defaultHeight
        private var textStyle: TextTheme.Style!

        // MARK: - Initialization
        public init() {  }

        // MARK: - Public Methods
        public func backgroundColor(_ value: UIColor) -> Self {
          self.backgroundColor = value
          return self
        }

        public func borderStyle(_ value: BorderTheme.Style) -> Self {
          self.borderStyle = value
          return self
        }

        public func height(_ value: CGFloat) -> Self {
          self.height = value
          return self
        }

        public func textStyle(_ value: TextTheme.Style) -> Self {
          self.textStyle = value
          return self
        }

        public func build() -> Style {
          return Style(
            backgroundColor: backgroundColor,
            borderStyle: borderStyle,
            height: height,
            textStyle: textStyle)
        }
      }
    }

    // MARK: - Public Properties
    public let primary: Style
    public let secondary: Style
    public let text: Style

    // MARK: - Builder
    public class Builder {

      // MARK: - Private Properties
      private let colorTheme: ColorTheme
      private let textTheme: TextTheme

      private lazy var primary = ElevatedButtonTheme.Style.Builder()
        .backgroundColor(colorTheme.primary2)
        .borderStyle(.none)
        .textStyle(textTheme.button.copyWith(color: colorTheme.secondaryGray4))
        .build()

      private lazy var secondary = ElevatedButtonTheme.Style.Builder()
        .backgroundColor(colorTheme.secondaryGray4)
        .borderStyle(BorderTheme.Style.Builder()
          .color(colorTheme.primary2)
          .build())
        .textStyle(textTheme.button.copyWith(color: colorTheme.secondaryGray1))
        .build()

      private lazy var text = ElevatedButtonTheme.Style.Builder()
        .backgroundColor(.clear)
        .borderStyle(.none)
        .textStyle(textTheme.button.copyWith(color: colorTheme.primary2))
        .build()

      // MARK: - Initialization
      public init(_ colorTheme: ColorTheme, _ textTheme: TextTheme) {
        self.colorTheme = colorTheme
        self.textTheme = textTheme
      }

      // MARK: - Public Methods
      public func primary(_ value: Style) -> Self {
        self.primary = value
        return self
      }

      public func secondary(_ value: Style) -> Self {
        self.secondary = value
        return self
      }

      public func text(_ value: Style) -> Self {
        self.text = text
        return self
      }

      public func build() -> ElevatedButtonTheme {
        return ElevatedButtonTheme(
          primary: primary,
          secondary: secondary,
          text: text)
      }
    }
  }

  // MARK: - TextInputTheme
  public struct TextInputTheme {

    // MARK: - Style
    public struct Style {
      public let accessoryPadding: CGFloat
      public let accessorySize: CGFloat
      public let backgroundColor: UIColor
      public let borderStyle: BorderTheme.Style
      public let textFieldHeight: CGFloat
      public let textFieldBottom: CGFloat
      public let textStyle: TextTheme.Style

      // MARK: - Builder
      public class Builder {
        private var accessoryPadding: CGFloat = 8.0
        private var accessorySize: CGFloat = 24
        private var backgroundColor: UIColor!
        private var borderStyle: BorderTheme.Style!
        private var textFieldHeight: CGFloat = 44.0
        private var textFieldBottom: CGFloat = 24.0
        private var textStyle: TextTheme.Style!

        // MARK: - Initialization
        public init() {  }

        // MARK: - Public Methods
        public func accessoryPadding(_ value: CGFloat) -> Self {
          self.accessoryPadding = value
          return self
        }

        public func accessorySize(_ value: CGFloat) -> Self {
          self.accessorySize = value
          return self
        }

        public func backgroundColor(_ value: UIColor) -> Self {
          self.backgroundColor = value
          return self
        }

        public func borderStyle(_ value: BorderTheme.Style) -> Self {
          self.borderStyle = value
          return self
        }

        public func textFieldHeight(_ value: CGFloat) -> Self {
          self.textFieldHeight = value
          return self
        }

        public func textFieldBottom(_ value: CGFloat) -> Self {
          self.textFieldBottom = value
          return self
        }

        public func textStyle(_ value: TextTheme.Style) -> Self {
          self.textStyle = value
          return self
        }

        public func build() -> Style {
          return Style(
            accessoryPadding: accessoryPadding,
            accessorySize: accessorySize,
            backgroundColor: backgroundColor,
            borderStyle: borderStyle,
            textFieldHeight: textFieldHeight,
            textFieldBottom: textFieldBottom,
            textStyle: textStyle)
        }
      }
    }

    // MARK: - Public Properties
    public let error: TextInputTheme.Style
    public let normal: TextInputTheme.Style

    // MARK: - Builder
    public class Builder {

      // MARK: - Private Properties
      private let colorTheme: ColorTheme
      private let textTheme: TextTheme

      private lazy var error = Style.Builder()
        .backgroundColor(colorTheme.secondaryGray4)
        .borderStyle(
          BorderTheme.Style.Builder()
            .color(colorTheme.tertiary2)
            .build())
        .textStyle(textTheme.bodyText1)
        .build()

      private lazy var normal = Style.Builder()
        .backgroundColor(colorTheme.secondaryGray4)
        .borderStyle(
          BorderTheme.Style.Builder()
            .color(colorTheme.secondaryGray3)
            .build())
        .textStyle(textTheme.bodyText1)
        .build()

      // MARK: - Initialization
      public init(_ colorTheme: ColorTheme, _ textTheme: TextTheme) {
        self.colorTheme = colorTheme
        self.textTheme = textTheme
      }

      // MARK: - Public Methods
      public func error(_ value: Style) -> Self {
        self.error = value
        return self
      }

      public func normal(_ value: Style) -> Self {
        self.normal = value
        return self
      }

      public func build() -> TextInputTheme {
        return TextInputTheme(
          error: error,
          normal: normal)
      }
    }
  }

  // MARK: - TextTheme
  public struct TextTheme {

    // MARK: - Style
    public struct Style {

      // MARK: - Public Properties
      public let color: UIColor
      public let font: UIFont

      // MARK: - Public Methods
      public func copyWith(color: UIColor) -> Style {
        return Self.init(
          color: color,
          font: font)
      }

      // MARK: - Builder
      public class Builder {

        // MARK: - Private Properties
        private var color: UIColor!
        private var font: UIFont!

        // MARK: - Initialization
        public init() {  }

        // MARK: - Public Methods
        public func color(_ value: UIColor) -> Self {
          self.color = value
          return self
        }

        public func font(_ value: UIFont) -> Self {
          self.font = value
          return self
        }

        public func build() -> Style {
          return Style(
            color: color,
            font: font)
        }
      }
    }

    // MARK: - Public Properties
    public let headline6: Style
    public let subtitle1: Style
    public let subtitle2: Style
    public let bodyText1: Style
    public let bodyText2: Style
    public let caption: Style
    public let button: Style
    public let overline: Style

    // MARK: - Builder
    public class Builder {

      // MARK: - Private Properties
      private let colorTheme: ColorTheme

      private lazy var headline6 = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray1)
        .font(.defaultFont(size: 24.0, weight: .regular))
        .build()

      private lazy var subtitle1 = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray1)
        .font(.defaultFont(size: 16.0, weight: .regular))
        .build()

      private lazy var subtitle2 = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray1)
        .font(.defaultFont(size: 14.0, weight: .regular))
        .build()

      private lazy var bodyText1 = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray1)
        .font(.defaultFont(size: 16.0, weight: .regular))
        .build()

      private lazy var bodyText2 = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray2)
        .font(.defaultFont(size: 14.0, weight: .regular))
        .build()

      private lazy var caption = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray2)
        .font(.defaultFont(size: 14.0, weight: .regular))
        .build()

      private lazy var button = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray3)
        .font(.defaultFont(size: 14.0, weight: .regular))
        .build()

      private lazy var overline = TextTheme
        .Style
        .Builder()
        .color(colorTheme.secondaryGray1)
        .font(.defaultFont(size: 12.0, weight: .regular))
        .build()


      // MARK: - Public Methods
      public init(_ colorTheme: ColorTheme) {
        self.colorTheme = colorTheme
      }

      public func headline6(_ value: Style) -> Self {
        self.headline6 = value
        return self
      }

      public func subtitle1(_ value: Style) -> Self {
        self.subtitle1 = value
        return self
      }

      public func subtitle2(_ value: Style) -> Self {
        self.subtitle2 = value
        return self
      }

      public func bodyText1(_ value: Style) -> Self {
        self.bodyText1 = value
        return self
      }

      public func bodyText2(_ value: Style) -> Self {
        self.bodyText2 = value
        return self
      }

      public func caption(_ value: Style) -> Self {
        self.caption = value
        return self
      }

      public func button(_ value: Style) -> Self {
        self.button = value
        return self
      }

      public func overline(_ value: Style) -> Self {
        self.overline = value
        return self
      }


      public func build() -> TextTheme {
        return TextTheme(
          headline6: headline6,
          subtitle1: subtitle1,
          subtitle2: subtitle2,
          bodyText1: bodyText1,
          bodyText2: bodyText2,
          caption: caption,
          button: button,
          overline: overline)
      }
    }
  }


  // MARK: - Public Properties
  public let buttonTheme: ElevatedButtonTheme
  public let cardTheme: CardTheme
  public let colorTheme: ColorTheme
  public let textInputTheme: TextInputTheme
  public let textTheme: TextTheme

  // MARK: - Builder
  public class Builder {

    // MARK: - Private Properties
    private lazy var buttonTheme = PUTheme.ElevatedButtonTheme.Builder(colorTheme, textTheme).build()
    private lazy var cardTheme = PUTheme.CardTheme.Builder(colorTheme).build()
    private lazy var colorTheme = PUTheme.ColorTheme.Builder().build()
    private lazy var textInputTheme = PUTheme.TextInputTheme.Builder(colorTheme, textTheme).build()
    private lazy var textTheme = PUTheme.TextTheme.Builder(colorTheme).build()

    // MARK: - Initialization
    public init() {
      UIFont.registerFonts()
    }

    // MARK: - Public Methods
    public func buttonTheme(_ value: ElevatedButtonTheme) -> Self {
      self.buttonTheme = value
      return self
    }

    public func cardTheme(_ value: CardTheme) -> Self {
      self.cardTheme = value
      return self
    }

    public func colorTheme(_ value: ColorTheme) -> Self {
      self.colorTheme = value
      return self
    }

    public func textInputTheme(_ value: TextInputTheme) -> Self {
      self.textInputTheme = value
      return self
    }

    public func textTheme(_ value: TextTheme) -> Self {
      self.textTheme = value
      return self
    }

    public func build() -> PUTheme {
      return PUTheme(
        buttonTheme: buttonTheme,
        cardTheme: cardTheme,
        colorTheme: colorTheme,
        textInputTheme: textInputTheme,
        textTheme: textTheme)
    }
  }
}
