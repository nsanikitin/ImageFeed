import Foundation
import WebKit

final class ProfileLogoutService {
    
    // MARK: - Properties
    
    static let shared = ProfileLogoutService()
    private let storage = OAuth2TokenStorage()
    private let profile = ProfileViewController()
    
    private init() { }
    
    // MARK: - Methods
    
    func logout() {
        cleanCookies()
        cleanToken()
        cleanUserData()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: { })
            }
        }
    }
    
    private func cleanToken() {
        storage.removeToken()
    }
    
    private func cleanUserData() {
        profile.userNameLabel.text = ""
        profile.userLoginLabel.text = ""
        profile.userDescriptionLabel.text = ""
        profile.userAvatarImage.image = UIImage(named: "stub_user")
    }
}
