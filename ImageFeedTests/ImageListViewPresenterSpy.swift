@testable
import ImageFeed
import Foundation

final class ImageListViewPresenterSpy: ImageListViewPresenterProtocol {
    
    var view: ImageFeed.ImageListViewControllerProtocol?
    var photos: [ImageFeed.Photo] = []
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func loadPhotos() {
        
    }
    
    func updateTableViewAnimated() {
        
    }
}
