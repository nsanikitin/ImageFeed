import Foundation

protocol ImageListViewPresenterProtocol: AnyObject {
    
    var view: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    
    func viewDidLoad()
    func loadPhotos()
    func updateTableViewAnimated()
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    
    // MARK: - Properties
    
    var view: ImageListViewControllerProtocol?
    var photos: [Photo] = []
    
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Methods
    
    func viewDidLoad() {
        loadPhotos()
    }
    
    func loadPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.showTableViewAnimate(oldCount: oldCount, newCount: newCount)
        }
    }
}
