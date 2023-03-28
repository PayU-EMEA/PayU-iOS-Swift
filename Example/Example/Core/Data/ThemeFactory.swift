//
//  ThemeFactory.swift
//  Example
//
//  Created by PayU S.A. on 18/01/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//  

import PUSDK
import UIKit

struct ThemeFactory {

  // MARK: - Public Methods
  func make(_ theme: Theme) -> PUTheme {
    switch theme {
      case .`default`:
        return makeDefaultTheme()
      case .custom:
        return makeCustomTheme()
    }
  }

  // MARK: - Private Methods
  private func makeDefaultTheme() -> PUTheme {
    PUTheme
      .Builder()
      .build()
  }


  private func makeCustomTheme() -> PUTheme {
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
