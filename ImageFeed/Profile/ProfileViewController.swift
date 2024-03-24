import Kingfisher
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var logOutButton: UIButton = UIButton()
    lazy var userAvatarImage: UIImageView = UIImageView()
    lazy var userNameLabel: UILabel = UILabel()
    lazy var userLoginLabel: UILabel = UILabel()
    lazy var userDescriptionLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        configureUserAvatarImage(avatarImage: UIImage(named: "avatar")!)
        configureUserNameLabel()
        configureUserLoginLabel()
        configureUserDescriptionLabel()
        configureLogOutButton(imageForButton: UIImage(named: "logout_button")!)
        
        guard let profile = profileService.profile else {
            assertionFailure("Profile Data is invalid")
            return
        }
        
        updateProfileData(profile: profile)
        addObserver()
        updateAvatar()
    }
    
    // MARK: - Methods
    
    private func addObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateProfileData(profile: Profile) {
        self.userNameLabel.text = profile.name
        self.userLoginLabel.text = profile.loginName
        self.userDescriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        
        userAvatarImage.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 70)
        userAvatarImage.kf.setImage(with: url,
                                    placeholder: UIImage(named: "stub_user"),
                                    options: [.processor(processor)]) { result in
            switch result {
            case .success(let value):
                print("Image is loaded: \(value.image)")
            case .failure(let error):
                print("Image is not loaded, error is: \(error)")
            }
        }
    }
    
    private func configureUserAvatarImage(avatarImage: UIImage) {
        userAvatarImage = UIImageView(image: avatarImage)
        userAvatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userAvatarImage)
        
        userAvatarImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userAvatarImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userAvatarImage.layer.cornerRadius = 35
        userAvatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        userAvatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func configureUserNameLabel() {
        userNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        userNameLabel.textColor = .ypWhite
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        userNameLabel.topAnchor.constraint(equalTo: userAvatarImage.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImage.leadingAnchor).isActive = true
    }
    
    private func configureUserLoginLabel() {
        userLoginLabel.font = UIFont.systemFont(ofSize: 13)
        userLoginLabel.textColor = .ypGray
        
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLoginLabel)
        
        userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        userLoginLabel.leadingAnchor.constraint(equalTo: userAvatarImage.leadingAnchor).isActive = true
    }
    
    private func configureUserDescriptionLabel() {
        userDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        userDescriptionLabel.textColor = .ypWhite
        
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDescriptionLabel)
        
        userDescriptionLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8).isActive = true
        userDescriptionLabel.leadingAnchor.constraint(equalTo: userAvatarImage.leadingAnchor).isActive = true
    }
    
    private func configureLogOutButton(imageForButton: UIImage) {
        logOutButton = UIButton.systemButton(
            with: imageForButton,
            target: self,
            action: #selector(didTapeLogOutButton)
        )
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        logOutButton.tintColor = .ypRed
        
        logOutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: userAvatarImage.centerYAnchor).isActive = true
    }
    
    private func logoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Нет", style: .default)
        let action = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            ProfileLogoutService.shared.logout()
            switchToSplashScreen()
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.preferredAction = cancelAction
        present(alert, animated: true)
    }
    
    private func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapeLogOutButton() {
        logoutAlert()
    }
}
