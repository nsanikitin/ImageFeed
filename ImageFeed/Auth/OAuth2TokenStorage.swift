import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    // MARK: - Properties

    private let keychainWrapper = KeychainWrapper.standard
    private let accessToken = ""
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: accessToken)
        }
        set {
            guard let newValue = newValue else {
                assertionFailure("A token new value is invalid")
                return
            }
            
            let isSuccess = keychainWrapper.set(newValue, forKey: accessToken)
            guard isSuccess else {
                assertionFailure("A token is not saved!")
                return
            }
        }
    }
    
    // MARK: - Methods
    
    func removeToken() {
        keychainWrapper.removeObject(forKey: accessToken)
    }
}
