import Foundation

final class ImagesListService {
    
    // MARK: - Properties
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private let token = OAuth2TokenStorage().token
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    
    private lazy var iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    // MARK: Photo Methods
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let token = token else {
            assertionFailure("A token is not exist!")
            return
        }
        
        guard let request = photosNextPageRequest(page: nextPage, token: token)  else {
            assertionFailure("Invalid profile request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (response: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                DispatchQueue.main.async {
                    body.forEach { photoResult in
                        self.photos.append(self.convertToPhoto(photoResult: photoResult))
                    }
                    //self.photos += photos
                    NotificationCenter.default
                        .post(name: ImagesListService.didChangeNotification,
                              object: self)
                }
            case .failure(let error):
                print("[ImagesListService]: \(error.localizedDescription) \(request)")
            }
            
            self.task = nil
        }
    }
    
    private func photosNextPageRequest(page: Int, token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )

        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func convertToPhoto(photoResult: PhotoResult) -> Photo {
        let convertedPhotos = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: self.iso8601Formatter.date(from: photoResult.createdAt ?? ""),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.small,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser)
        return convertedPhotos
    }
    
    // MARK: Like Methods
}
