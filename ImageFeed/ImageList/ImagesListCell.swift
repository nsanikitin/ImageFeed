import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var gradientViewOfDateLabel: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var cellImage: UIImageView!
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Methods
    
    func configCell(image: UIImage?, date: String, isLiked: Bool) {

        cellImage.image = image
        dateLabel.text = date
        
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    
//    func configureGradientView(with view: UIImageView) {
    
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.ypBlack.withAlphaComponent(0).cgColor,
//                                UIColor.ypBlack.withAlphaComponent(1).cgColor]
//        gradientLayer.locations = [0, 1]
//        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
//        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0))
//        gradientLayer.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
//        gradientLayer.position = view.center
//        view.layer.addSublayer(gradientLayer)
//    }
}
