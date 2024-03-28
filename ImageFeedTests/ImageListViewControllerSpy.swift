@testable
import ImageFeed
import Foundation

final class ImageListViewControllerSpy: ImageListViewControllerProtocol {
    
    var presenter: ImageFeed.ImageListViewPresenterProtocol?
    var showTableViewAnimateCalled: Bool = false
    
    func showTableViewAnimate(oldCount: Int, newCount: Int) {
        showTableViewAnimateCalled = true
    }
}
