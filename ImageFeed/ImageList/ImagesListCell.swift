import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var gradientViewOfDateLabel: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var cellImage: UIImageView!
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func setImage(url: String) {
        guard let url = URL(string: url) else {
            assertionFailure("Image URL is not exist")
            return
        }
        
        cellImage.kf.indicatorType = .activity
        self.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "stub_image"))
    }
    
    func configCell(date: String, isLiked: Bool) {
        dateLabel.text = date
        
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
        
        configureDateLabelGradient(with: gradientViewOfDateLabel)
    }
    
    private func configureDateLabelGradient(with view: UIImageView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.ypBlack.withAlphaComponent(0).cgColor,
                                UIColor.ypBlack.withAlphaComponent(1).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
    }
}
