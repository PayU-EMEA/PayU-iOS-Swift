//
//  PaymentCardScannerOverlayView.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUTheme)
import PUTheme
#endif

final class PaymentCardScannerOverlayView: UIView {

  // MARK: - Constants
  private struct Constants {
    static let cornerRadius: CGFloat = 10
    static let cornerOffset: CGFloat = 40
  }

  // MARK: - Private Properties
  private let rect: CGRect

  // MARK: - Initialization
   required init(rect: CGRect) {
    self.rect = rect
    super.init(frame: .zero)
    setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func draw(_ rect: CGRect) {
    makeRoundedBorders(rect: self.rect)
    makeTransparentRect(rect: rect)
    super.draw(rect)
  }

  // MARK: - Private Methods
  private func setupAppearance() {
    backgroundColor = PUTheme.theme.colorTheme.secondaryGray4.withAlphaComponent(0.99999)
    isOpaque = false
  }

  private func makeTransparentRect(rect: CGRect) {
    backgroundColor?.setFill()
    UIRectFill(rect)

    let bezierPath = UIBezierPath(roundedRect: self.rect, cornerRadius: Constants.cornerRadius)
    let rectIntersection = rect.intersection(self.rect)

    UIRectFill(rectIntersection)
    UIColor.clear.setFill()

    let context = UIGraphicsGetCurrentContext()
    context?.setBlendMode(.copy)
    bezierPath.fill()
  }

  private func makeRoundedBorders(rect: CGRect) {
    let bezierPath = UIBezierPath()

    let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
    let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
    let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
    let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)

    let offset = Constants.cornerOffset
    let radius = Constants.cornerRadius

    // top left corner
    bezierPath.move(to: CGPoint(x: topLeftPoint.x, y: topLeftPoint.y + offset))
    bezierPath.addLine(to: CGPoint(x: topLeftPoint.x, y: topLeftPoint.y + radius))
    bezierPath.addArc(withCenter: CGPoint(x: topLeftPoint.x + radius, y: topLeftPoint.y + radius), radius: radius, startAngle: Double.pi, endAngle: 3 * Double.pi / 2, clockwise: true)
    bezierPath.addLine(to: CGPoint(x: topLeftPoint.x + offset, y: topLeftPoint.y))

    // top right corner
    bezierPath.move(to: CGPoint(x: topRightPoint.x - offset, y: topLeftPoint.y))
    bezierPath.addLine(to: CGPoint(x: topRightPoint.x - radius, y: topLeftPoint.y))
    bezierPath.addArc(withCenter: CGPoint(x: topRightPoint.x - radius, y: topRightPoint.y + radius), radius: radius, startAngle: 3 * Double.pi / 2, endAngle: Double.zero, clockwise: true)
    bezierPath.addLine(to: CGPoint(x: topRightPoint.x, y: topRightPoint.y + offset))

    // bottom right corner
    bezierPath.move(to: CGPoint(x: bottomRightPoint.x, y: bottomRightPoint.y - offset))
    bezierPath.addLine(to: CGPoint(x: bottomRightPoint.x, y: bottomRightPoint.y - radius))
    bezierPath.addArc(withCenter: CGPoint(x: bottomRightPoint.x - radius, y: bottomRightPoint.y - radius), radius: radius, startAngle: Double.zero, endAngle: Double.pi / 2, clockwise: true)
    bezierPath.addLine(to: CGPoint(x: bottomRightPoint.x - offset, y: bottomRightPoint.y))

    // bottom left corner
    bezierPath.move(to: CGPoint(x: bottomLeftPoint.x + offset, y: bottomLeftPoint.y))
    bezierPath.addLine(to: CGPoint(x: bottomLeftPoint.x + radius, y: bottomLeftPoint.y))
    bezierPath.addArc(withCenter: CGPoint(x: bottomLeftPoint.x + radius, y: bottomLeftPoint.y - radius), radius: radius, startAngle: Double.pi / 2, endAngle: Double.pi, clockwise: true)
    bezierPath.addLine(to: CGPoint(x: bottomLeftPoint.x, y: bottomRightPoint.y - offset))

    // layer
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = bezierPath.cgPath
    shapeLayer.strokeColor = PUTheme.theme.colorTheme.primary2.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = 5
    shapeLayer.lineCap = .round
    layer.addSublayer(shapeLayer)
  }

}
