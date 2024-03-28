import Foundation

final class ProfileLogoutService {
    
    // MARK: - Properties
    
    static let shared = ProfileLogoutService()
    private let storage = OAuth2TokenStorage()
    private let profile = ProfileViewController()
    private let web = WebViewViewController()
    
    // MARK: - Methods
    
    func logout() {
        cleanCookies()
        cleanToken()
        cleanUserData()
    }
    
    private func cleanCookies() {
        web.removeCookies()
    }
    
    private func cleanToken() {
        storage.removeToken()
    }
    
    private func cleanUserData() {
        profile.removeProfileInfo()
    }
}
