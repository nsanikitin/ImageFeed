import Kingfisher
import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func updateProfileInfo(name: String, login: String, description: String)
    func updateUserAvatar(with url: URL)
    func switchToSplashScreen()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Properties
    
    var presenter: ProfileViewPresenterProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var logOutButton: UIButton = UIButton()
    private lazy var userAvatarImage: UIImageView = UIImageView()
    private lazy var userNameLabel: UILabel = UILabel()
    private lazy var userLoginLabel: UILabel = UILabel()
    private lazy var userDescriptionLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        configureUserAvatarImage()
        configureUserNameLabel()
        configureUserLoginLabel()
        configureUserDescriptionLabel()
        configureLogOutButton()
        
        presenter?.viewDidLoad()
        addObserver()
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
                self.presenter?.getUserAvatar()
            }
    }
    
    func updateProfileInfo(name: String, login: String, description: String) {
        self.userNameLabel.text = name
        self.userLoginLabel.text = login
        self.userDescriptionLabel.text = description
    }
    
    func removeProfileInfo() {
        self.userNameLabel.text = ""
        self.userLoginLabel.text = ""
        self.userDescriptionLabel.text = ""
        self.userAvatarImage.image = UIImage(named: "stub_user")
    }
    
    func updateUserAvatar(with url: URL) {
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
    
    func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
    
    // MARK: - View Configuration
    
    private func configureUserAvatarImage() {
        userAvatarImage = UIImageView(image: UIImage(named: "stub_user")!)
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
    
    private func configureLogOutButton() {
        logOutButton = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: self,
            action: #selector(didTapeLogOutButton)
        )
        logOutButton.accessibilityIdentifier = "logout_button"
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        logOutButton.tintColor = .ypRed
        
        logOutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: userAvatarImage.centerYAnchor).isActive = true
    }
    
    // MARK: - Alert View
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Нет", style: .default)
        let action = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.logoutFromProfile()
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.preferredAction = cancelAction
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapeLogOutButton() {
        showLogoutAlert()
    }
}
