import Foundation

public protocol ProfileViewPresenterProtocol: AnyObject {
    
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func getProfileData()
    func getUserAvatar()
    func logoutFromProfile()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Properties
    
    var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    // MARK: Methods
    
    func viewDidLoad() {
        getProfileData()
        getUserAvatar()
    }
    
    func getProfileData() {
        guard let profileData = profileService.profile else {
            assertionFailure("Profile Data is invalid")
            return
        }
        
        view?.updateProfileInfo(name: profileData.name,
                                login: profileData.loginName,
                                description: profileData.bio)
    }
    
    func getUserAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        
        view?.updateUserAvatar(with: url)
    }
    
    func logoutFromProfile() {
        profileLogoutService.logout()
        view?.switchToSplashScreen()
    }
}
