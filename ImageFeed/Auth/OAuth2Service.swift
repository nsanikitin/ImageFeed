import Foundation

final class OAuth2Service {
    
    // MARK: - Properties
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    // MARK: - Methods
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(NetworkError.serviceError))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code)  else {
            assertionFailure("Invalid auth request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                print("[OAuth2Service]: \(error.localizedDescription) \(request)")
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastCode = nil
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: Constants.defaultBaseURL
        )
    }
}
