import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let imagesListViewPresenter = ImageListViewPresenter()
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else { return }
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
