import Foundation

final class ProfileImageService {
    
    // MARK: - Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    // MARK: - Methods
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        _ completion: @escaping (Result<String?, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let request = profileImageRequest(token: token, username: username) else {
            assertionFailure("Invalid profile image request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (response: Result<UserResult, Error>)  in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                self.avatarURL = body.profileImage?.large
                completion(.success(self.avatarURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL as Any])
            case .failure(let error):
                assertionFailure("[ProfileImageService]: \(error.localizedDescription) \(request)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
    }
    
    private func profileImageRequest(token: String, username: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
