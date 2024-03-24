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
    
    // MARK: - Photo Methods
    
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
                    NotificationCenter.default
                        .post(name: ImagesListService.didChangeNotification,
                              object: self)
                }
            case .failure(let error):
                print("[ImagesListService]: \(error.localizedDescription) \(request)")
            }
            
            self.task = nil
            self.lastLoadedPage = nextPage
        }
    }
    
    private func photosNextPageRequest(page: Int, token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)",
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
    
    // MARK: - Like Methods
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<LikeResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let token = token else {
            assertionFailure("A token is not exist!")
            return
        }
        
        guard let request = changeLikeRequest(id: photoId, isLiked: isLike, token: token)  else {
            assertionFailure("Invalid profile request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (response: Result<LikeResult, Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                    }
                }
                completion(.success(body))
            case .failure(let error):
                print("[ImagesListService]: \(error.localizedDescription) \(request)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
    }
    
    private func changeLikeRequest(id: String, isLiked: Bool, token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: isLiked ? "POST" : "DELETE",
            baseURL: Constants.defaultApiBaseURL
        )
        
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
