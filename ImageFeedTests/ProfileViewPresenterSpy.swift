@testable
import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getProfileData() {
        
    }
    
    func getUserAvatar() {
        
    }
    
    func logoutFromProfile() {
        
    }
}
