import Foundation

final class OAuth2TokenStorage {
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    private let accessToken = ""
    
    var token: String? {
        get {
            userDefaults.string(forKey: accessToken)
        }
        set {
            userDefaults.set(newValue, forKey: accessToken)
        }
    }
}
