import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    // MARK: - Actions
    
    @IBAction func didTapeBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
