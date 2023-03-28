//
//  UIView+Constraints.swift
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

public enum Edge {
  case top
  case left
  case bottom
  case right

  var layoutAttribute: NSLayoutConstraint.Attribute {
    switch self {
    case .top:
      return .top
    case .bottom:
      return .bottom
    case .left:
      return .left
    case .right:
      return .right
    }
  }
}

extension UIView {
  public func pinToSuperview(edges: [Edge], constant: CGFloat = 0, priority: UILayoutPriority = .required) {
    for edge in edges {
      switch edge {
      case .top: pinToSuperviewTop(withConstant: constant, priority: priority)
      case .left: pinToSuperviewLeft(withConstant: constant, priority: priority)
      case .bottom: pinToSuperviewBottom(withConstant: constant, priority: priority)
      case .right: pinToSuperviewRight(withConstant: constant, priority: priority)
      }
    }
  }

  @discardableResult
  public func pinToSuperviewTop(
    withConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      return pinTop(to: superview, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinToSuperviewLeft(
    withConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      return pinLeft(to: superview, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinToSuperviewRight(
    withConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      return pinRight(to: superview, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinToSuperviewBottom(
    withConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      return pinBottom(to: superview, constant: -constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func limitFromSuperviewBottom(
    withMinimumConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      let constraint = superview.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: constant)
      constraint.priority = priority
      constraint.isActive = true

      return constraint
    }

  @discardableResult
  public func limitFromSuperviewRight(
    withMinimumConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      let constraint = superview.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: constant)
      constraint.priority = priority
      constraint.isActive = true

      return constraint
    }

  public func pinToSuperviewEdges(withConstant constant: CGFloat = 0) {
    guard let superview = self.superview else {
      preconditionFailure("view has no superview")
    }

    pinTop(to: superview, constant: constant)
    pinBottom(to: superview, constant: constant)
    pinLeft(to: superview, constant: constant)
    pinRight(to: superview, constant: constant)
  }
}

// MARK: Pin sibling views
extension UIView {
  @discardableResult
  public func pinTop(
    to view: UIView,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .top, to:.top, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinTop(
    to view: UIView,
    anchor: Edge,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .top, to: anchor, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinBottom(
    to view: UIView,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .bottom, to:.bottom, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinBottom(
    to view: UIView,
    anchor: Edge,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .bottom, to: anchor, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinLeft(
    to view: UIView,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .left, to:.left, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinLeft(
    to view: UIView,
    anchor: Edge,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .left, to: anchor, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinRight(
    to view: UIView,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .right, to:.right, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  @discardableResult
  public func pinRight(
    to view: UIView,
    anchor: Edge,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      return pin(edge: .right, to: anchor, of: view, constant: constant, priority: priority, relatedBy: relation)
    }

  public func pinEdges(to view: UIView) {
    pin(edge: .left, to: .left, of: view)
    pin(edge: .right, to: .right, of: view)
    pin(edge: .top, to: .top, of: view)
    pin(edge: .bottom, to: .bottom, of: view)
  }

  @discardableResult
  public func pin(
    edge: Edge,
    to otherEdge: Edge,
    of view: UIView,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      translatesAutoresizingMaskIntoConstraints = false
      if view !== superview {
        view.translatesAutoresizingMaskIntoConstraints = false
      }

      let constraint = NSLayoutConstraint(item: self,
                                          attribute: edge.layoutAttribute,
                                          relatedBy: relation,
                                          toItem: view,
                                          attribute: otherEdge.layoutAttribute,
                                          multiplier: 1,
                                          constant: constant)
      constraint.priority = priority
      superview.addConstraint(constraint)
      return constraint
    }

}

// MARK: - Size Constraint
extension UIView {

  @discardableResult
  public func addMaxWidthConstraint(
    with constant: CGFloat,
    priority: UILayoutPriority = .required) -> NSLayoutConstraint {
      return addWidthConstraint(with: constant, priority: priority, relatedBy: .lessThanOrEqual)
    }

  @discardableResult
  public func addMinWidthConstraint(
    with constant: CGFloat,
    priority: UILayoutPriority = .required) -> NSLayoutConstraint {
      return addWidthConstraint(with: constant, priority: priority, relatedBy: .greaterThanOrEqual)
    }

  @discardableResult
  public func addWidthConstraint(
    with constant: CGFloat,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      translatesAutoresizingMaskIntoConstraints = false
      let constraint = NSLayoutConstraint(
        item: self,
        attribute: .width,
        relatedBy: relation,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1,
        constant: constant)
      constraint.priority = priority
      addConstraint(constraint)
      return constraint

    }

  @discardableResult
  public func addHeightConstraint(
    with constant: CGFloat,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      translatesAutoresizingMaskIntoConstraints = false
      let constraint = NSLayoutConstraint(
        item: self,
        attribute: .height,
        relatedBy: relation,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1,
        constant: constant)
      constraint.priority = priority
      addConstraint(constraint)
      return constraint

    }

}

// MARK: Center superview
extension UIView {

  @discardableResult
  public func centerYToSuperview(
    withConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      translatesAutoresizingMaskIntoConstraints = false
      let constraint = NSLayoutConstraint(
        item: self,
        attribute: .centerY,
        relatedBy: relation,
        toItem: superview,
        attribute: .centerY,
        multiplier: 1,
        constant: constant)
      constraint.priority = priority
      superview.addConstraint(constraint)
      return constraint
    }

  @discardableResult
  public func centerXToSuperview(
    withConstant constant: CGFloat = 0,
    priority: UILayoutPriority = .required,
    relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
      guard let superview = self.superview else {
        preconditionFailure("view has no superview")
      }

      translatesAutoresizingMaskIntoConstraints = false
      let constraint = NSLayoutConstraint(
        item: self,
        attribute: .centerX,
        relatedBy: relation,
        toItem: superview,
        attribute: .centerX,
        multiplier: 1,
        constant: constant)
      constraint.priority = priority
      superview.addConstraint(constraint)
      return constraint
    }
}

