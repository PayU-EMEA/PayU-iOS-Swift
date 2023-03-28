//
//  PUTextField.swift
//
//  Created by PayU S.A. on 15/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

open class PUTextField: UITextField {

  // MARK: - Overrides
  public override var intrinsicContentSize: CGSize {
    CGSize(
      width: super.intrinsicContentSize.width,
      height: style.textFieldHeight + style.textFieldBottom)
  }

  var borderLayer = CALayer()

  // MARK: - Constants
  private var accessoryPadding: CGFloat { style.accessoryPadding }
  private var accessorySize: CGFloat { style.accessorySize }
  
  // MARK: - Private Properties
  private var shouldDisplayLeading: Bool { leadingImageProvider != nil }
  private var shouldDisplayTrailing: Bool { trailingImageProvider != nil }

  private lazy var leadingImageView = makeImageView()
  private lazy var trailingImageView = makeImageView()

  private lazy var errorAccessoryView = makeBottomAccessoryView(.left)
  private lazy var hintAccessoryView = makeBottomAccessoryView(.right)

  // MARK: - Public Properties
  public var error: String? { didSet { didUpdateBottomAccessoryView() } }
  public var hint: String? { didSet { didUpdateBottomAccessoryView() } }

  public var style = PUTheme.theme.textInputTheme.normal { didSet { apply(style: style) } }

  public var leadingImageProvider: BrandImageProvider? { didSet { didUpdateLeadingImageProvider() } }
  public var trailingImageProvider: BrandImageProvider? { didSet { didUpdateTrailingImageProvider() } }

  public var onErrorAccessoryViewTap: (() -> Void)?
  public var onHintAccessoryViewTap: (() -> Void)?

  // MARK: - Initialization
  public override init(frame: CGRect) {
    super.init(frame: frame)
    prepareAppearance()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    prepareAppearance()
  }

  // MARK: - View Lifecycle
  public override func awakeFromNib() {
    super.awakeFromNib()
    prepareAppearance()
  }

  // MARK: - Overrides
  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    apply(style: style)
  }

  // MARK: - Appearance
  private func prepareAppearance() {
    apply(style: style)

    borderStyle = .none
    leftViewMode = .always
    rightViewMode = .always
    layer.addSublayer(borderLayer)

    leftView = leadingImageView
    rightView = trailingImageView

    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
    stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    stackView.addArrangedSubview(errorAccessoryView)
    stackView.addArrangedSubview(hintAccessoryView)

    errorAccessoryView.addTarget(self, action: #selector(PUTextField.actionErrorAccessoryView(_:)), for: .touchUpInside)
    hintAccessoryView.addTarget(self, action: #selector(PUTextField.actionHintAccessoryView(_:)), for: .touchUpInside)
  }

  // MARK: - Layout
  open override func layoutSubviews() {
    super.layoutSubviews()
    borderLayer.frame = borderRect(forBounds: bounds)
  }


  // MARK: - Actions
  @objc private func actionErrorAccessoryView(_ sender: Any) {
    onErrorAccessoryViewTap?()
  }

  @objc private func actionHintAccessoryView(_ sender: Any) {
    onHintAccessoryViewTap?()
  }

  // MARK: - Private Methods
  private func didUpdateBottomAccessoryView() {
    style = error == nil
    ? PUTheme.theme.textInputTheme.normal
    : PUTheme.theme.textInputTheme.error


    errorAccessoryView.tintColor = PUTheme.theme.colorTheme.tertiary2
    errorAccessoryView.setTitle(error, for: .normal)
    errorAccessoryView.isHidden = error == nil

    hintAccessoryView.tintColor = PUTheme.theme.colorTheme.primary2
    hintAccessoryView.setTitle(hint, for: .normal)
    hintAccessoryView.isHidden = hint == nil
  }

  private func didUpdateLeadingImageProvider() {
    leadingImageView.brandImageProvider = leadingImageProvider
    leadingImageView.isHidden = leadingImageProvider == nil
  }

  private func didUpdateTrailingImageProvider() {
    trailingImageView.brandImageProvider = trailingImageProvider
    trailingImageView.isHidden = trailingImageProvider == nil
  }

  private func makeImageView() -> PUImageView {
    let imageView = PUImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    return imageView
  }

  private func makeBottomAccessoryView(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> UIButton {
    let button = UIButton(type: .system)
    let color = PUTheme.theme.colorTheme.primary2
    let style = PUTheme.theme.textTheme.overline.copyWith(color: color)

    button.titleLabel?.apply(style: style)
    button.titleLabel?.lineBreakMode = .byTruncatingTail
//    button.titleLabel?.numberOfLines = 2
    button.tintColor = PUTheme.theme.colorTheme.primary2
    button.contentHorizontalAlignment = contentHorizontalAlignment
    return button
  }

  // MARK: - Accessory View Rect
  public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    return shouldDisplayLeading
    ? CGRect(
      x: bounds.minX + accessoryPadding,
      y: bounds.midY - accessorySize / 2 - style.textFieldBottom / 2,
      width: accessorySize,
      height: accessorySize)
    : .zero
  }

  public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    return shouldDisplayTrailing
    ? CGRect(
      x: bounds.maxX - accessoryPadding - accessorySize,
      y: bounds.midY - accessorySize / 2 - style.textFieldBottom / 2,
      width: accessorySize,
      height: accessorySize)
    : .zero
  }

  // MARK: - View Rect
  public override func borderRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(
      x: bounds.minX,
      y: bounds.minY,
      width: bounds.width,
      height: bounds.height - style.textFieldBottom)
  }

  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
  }

  public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
  }

  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(
      x: leftViewRect(forBounds: bounds).maxX + accessoryPadding,
      y: bounds.minY,
      width: bounds.width - leftOffset() - rightOffset(),
      height: bounds.height - style.textFieldBottom)
  }

  private func leftOffset() -> CGFloat {
    return shouldDisplayLeading
    ? accessoryPadding + accessorySize + accessoryPadding
    : accessoryPadding
  }

  private func rightOffset() -> CGFloat {
    return shouldDisplayTrailing
    ? accessoryPadding + accessorySize + accessoryPadding
    : accessoryPadding
  }
}
