import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var screenLogoImageView = UIImageView()
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        addScreenLogoImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switchToAuthOrImageList()
    }
    
    // MARK: - Methods
    
    private func switchToAuthOrImageList() {
        if let token = storage.token {
            fetchProfile(token)
        } else {
            guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func showAlertError() {
        alertPresenter = AlertPresenter(viewController: self)
        
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: nil
        )
        
        alertPresenter?.showAlert(alertModel: alertModel)
    }
    
    private func addScreenLogoImageView() {
        screenLogoImageView.image = UIImage(named: "splash_screen_logo")
        
        screenLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(screenLogoImageView)
        
        screenLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        screenLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}

// MARK: - Extensions

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            dismiss(animated: true)
            
            switch result {
            case .success(let token):
                self.fetchProfile(token)
            case .failure:
                self.showAlertError()
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let user):
                self.profileImageService.fetchProfileImageURL(username: user.username, token: token) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showAlertError()
                break
            }
        }
    }
}
