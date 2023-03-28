//
//  PortraitNavigationController.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import UIKit

public final class PortraitNavigationController: UINavigationController {

  // MARK: - Overrides
  public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .portrait }
  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
  public override var shouldAutorotate: Bool { false }

  // MARK: - Initialization
  public override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    modalPresentationStyle = .fullScreen
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
