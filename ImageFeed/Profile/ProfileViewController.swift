import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var userDescriptionLabel: UILabel!
    @IBOutlet private weak var userLoginLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAvatarImage: UIImageView!

    // MARK: - Actions
    
    @IBOutlet weak var logOutButtonDidTape: UIButton!
}
