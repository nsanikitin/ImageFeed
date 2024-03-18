import Foundation

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL?
    ) -> URLRequest? {
        guard let requestURL = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("URL is not exist")
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod
        
        return request
    }
}
