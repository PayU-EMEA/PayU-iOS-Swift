import UIKit

class SecureField: UITextField {

  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.isSecureTextEntry = true
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Properties
  weak var secureContainer: UIView? {
    let secureView = self.subviews.filter({ subview in
      type(of: subview).description().contains("CanvasView")
    }).first
    secureView?.translatesAutoresizingMaskIntoConstraints = false
    secureView?.isUserInteractionEnabled = true

    return secureView
  }

  // MARK: - Overrides
  override var canBecomeFirstResponder: Bool {false}
  override func becomeFirstResponder() -> Bool {false}
}
