import Foundation

final class ProfileService {
    
    // MARK: - Properties
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile : Profile?
    
    // MARK: - Methods
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let request = profileRequest(token: token)  else {
            assertionFailure("Invalid profile request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                let profile = Profile(username: body.username,
                                      name: "\(body.firstName) " + "\(body.lastName ?? "")",
                                      loginName: "@\(body.username)",
                                      bio: body.bio ?? ""
                )
                self.profile = profile
                completion(.success((profile)))
            case .failure(let error):
                print("[ProfileService]: \(error.localizedDescription) \(request)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
    }
    
    private func profileRequest(token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
