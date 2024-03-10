import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

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
        
        guard let request = profileRequest(token: token)  else {
            assertionFailure("Invalid request")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error  in
            DispatchQueue.main.async {
                let task = self?.object(for: request) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let profileResult):
                        let profile = Profile(result: profileResult)
                        completion(.success(profile))
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
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func profileRequest(token: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )
    }
}
