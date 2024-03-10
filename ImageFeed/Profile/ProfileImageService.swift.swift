import Foundation

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService {
    
    // MARK: - Properties
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private(set) var profileImage : UserResult?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() { }
    
    // MARK: - Methods
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let request = profileImageRequest(token: token, username: username) else { return }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error  in
            DispatchQueue.main.async {
                let task = self?.object(for: request) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let body):
                        self.avatarURL = body.profileImage?.small
                        completion(.success(self.avatarURL!))
                    case .failure(let error):
                        assertionFailure("Invalid request")
                        completion(.failure(error))
                    }
                }
                
                self?.task = nil
            }
        }
        
        self.task = task
        task.resume()
    }

    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result { try decoder.decode(UserResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func profileImageRequest(token: String, username: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )
    }
}
