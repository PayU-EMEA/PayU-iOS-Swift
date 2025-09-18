import UIKit

extension UIViewController {
    public func setupNavigationTitleImage(image: UIImageView){
        let imageView = image;
        imageView.contentMode = .scaleAspectFit;
        imageView.addHeightConstraint(with: 50)
        navigationItem.titleView = imageView
    }
}
