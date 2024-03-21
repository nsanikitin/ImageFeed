import UIKit
import ProgressHUD
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    private var alertPresenter: AlertPresenter?
    var fullImageURL: URL?
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSingleImage()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func fetchSingleImage() {
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlertError()
            }
        }
    }
    
    private func showAlertError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: "Не надо",
            style: .default
        )
        
        let addAction = UIAlertAction(
            title: "Повторить",
            style: .default
        ) { _ in
            self.fetchSingleImage()
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapeShareButton(_ sender: Any) {
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    @IBAction private func didTapeBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Extensions

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
