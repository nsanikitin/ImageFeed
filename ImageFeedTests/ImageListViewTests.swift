@testable
import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadPhotos() {
        // Given
        let viewController = ImageListViewControllerSpy()
        let presenter = ImageListViewPresenter()
        
        // When
        presenter.updateTableViewAnimated()
        
        // Then
        XCTAssertFalse(viewController.showTableViewAnimateCalled)
    }
}
