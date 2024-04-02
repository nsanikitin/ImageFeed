import Foundation

enum Constants {
    
    static let accessKey = "ZrBEAUvZl7B3i12F6PkdVi7rtsZvAEW3B6RPRVNuZCs"
    static let secretKey = "wo7Q6hmFXRbJZTmhvv8S0QKD4EBOzUvoSj31tjVC1C0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://unsplash.com")!
    static let defaultApiBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let defaultApiBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 defaultApiBaseURL: Constants.defaultApiBaseURL)
    }
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: URL,
        defaultApiBaseURL: URL
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.defaultApiBaseURL = defaultApiBaseURL
        self.authURLString = authURLString
    }
}
