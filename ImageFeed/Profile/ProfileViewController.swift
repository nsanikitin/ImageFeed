import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var userAvatarImage: UIImageView = UIImageView()
    private lazy var userNameLabel: UILabel = UILabel()
    private lazy var userLoginLabel: UILabel = UILabel()
    private lazy var userDescriptionLabel: UILabel = UILabel()
    private lazy var logOutButton: UIButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserAvatarImage(avatarImage: UIImage(named: "avatar")!)
        configureUserNameLabel(withText: "Екатерина Новикова")
        configureUserLoginLabel(withText: "@ekaterina_nov")
        configureUserDescriptionLabel(withText: "Hello, world!")
        configureLogOutButton(imageForButton: UIImage(named: "logout_button")!)
    }
    
    // MARK: - Methods
    
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
    
    private func configureUserNameLabel(withText name: String) {
        userNameLabel.text = name
        userNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        userNameLabel.textColor = .ypWhite
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        userNameLabel.topAnchor.constraint(equalTo: userAvatarImage.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImage.leadingAnchor).isActive = true
    }
    
    private func configureUserLoginLabel(withText login: String) {
        userLoginLabel.text = login
        userLoginLabel.font = UIFont.systemFont(ofSize: 13)
        userLoginLabel.textColor = .ypGray
        
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLoginLabel)
        
        userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        userLoginLabel.leadingAnchor.constraint(equalTo: userAvatarImage.leadingAnchor).isActive = true
    }
    
    private func configureUserDescriptionLabel(withText description: String) {
        userDescriptionLabel.text = description
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
    
    @objc 
    private func didTapeLogOutButton() {
        print("Log Out")
    }
}
