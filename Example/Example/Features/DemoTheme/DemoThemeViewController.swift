//
//  DemoThemeViewController.swift
//  Example
//
//  Created by PayU S.A. on 07/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import PUSDK
import UIKit

final class DemoThemeViewController: ViewController {

  // MARK: - Initialization
  required init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBasics()
  }

  // MARK: - Private Methods
  private func setupBasics() {
    title = Feature.demoTheme.title

    let theme = PUTheme.theme

    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false

    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
    scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant:16.0).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16.0).isActive = true

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16.0
    stackView.distribution = .fill
    scrollView.addSubview(stackView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

    // cardTheme

    [theme.cardTheme.normal]
      .map {
        let view = PUCardView(style: $0)
        view.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        return view
      }
      .forEach { stackView.addArrangedSubview($0) }

    // colorTheme

    let colorThemeStackView = UIStackView()
    colorThemeStackView.axis = .horizontal
    colorThemeStackView.spacing = 16.0
    colorThemeStackView.distribution = .fillProportionally
    stackView.addArrangedSubview(colorThemeStackView)

    [theme.colorTheme.primary2,
     theme.colorTheme.secondaryGray1,
     theme.colorTheme.secondaryGray2,
     theme.colorTheme.secondaryGray3,
     theme.colorTheme.secondaryGray4,
     theme.colorTheme.tertiary2]
      .map {
        let view = UIView()
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0).isActive = true
        view.backgroundColor = $0
        return view
      }
      .forEach { colorThemeStackView.addArrangedSubview($0) }

    // buttonTheme

    let primaryButton = PUPrimaryButton()
    primaryButton.setTitle("PUPrimaryButton", for: .normal)
    stackView.addArrangedSubview(primaryButton)

    let secondaryButton = PUSecondaryButton()
    secondaryButton.setTitle("PUSecondaryButton", for: .normal)
    stackView.addArrangedSubview(secondaryButton)

    let textButton = PUTextButton()
    textButton.setTitle("PUTextButton", for: .normal)
    stackView.addArrangedSubview(textButton)

    // textInputTheme
    
    [(text: "One", error: "Lorem ipsum dolor sit amet", hint: "Lorem ipsum dolor sit amet"),
     (text: "Two", error: nil, hint: "Lorem ipsum dolor sit amet")]
      .map {
        let view = PUTextField()
        view.leadingImageProvider = BrandImageProvider.calendar
        view.trailingImageProvider = BrandImageProvider.creditcard
        view.error = $0.error
        view.hint = $0.hint
        view.text = $0.text
        view.placeholder = "Placeholder"
        return view
      }
      .forEach { stackView.addArrangedSubview($0) }

    // textTheme

    [(text: "headline6", style: theme.textTheme.headline6),
     (text: "subtitle1", style: theme.textTheme.subtitle1),
     (text: "subtitle2", style: theme.textTheme.subtitle2),
     (text: "bodyText1", style: theme.textTheme.bodyText1),
     (text: "bodyText2", style: theme.textTheme.bodyText2),
     (text: "caption", style: theme.textTheme.caption),
     (text: "button", style: theme.textTheme.button),
     (text: "overline", style: theme.textTheme.overline)]
      .map {
        let view = PULabel(style: $0.style)
        view.text = $0.text
        return view
      }
      .forEach { stackView.addArrangedSubview($0) }
  }

}
