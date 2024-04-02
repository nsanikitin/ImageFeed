import UIKit

protocol ImageListViewControllerProtocol: AnyObject {
    
    var presenter: ImageListViewPresenterProtocol? { get set }
    func showTableViewAnimate(oldCount: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController, ImageListViewControllerProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    var presenter: ImageListViewPresenterProtocol?
    var photos: [Photo] = []
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{ "\($0)"}
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        presenter?.viewDidLoad()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            let indexPath = sender as? IndexPath
            
            guard let viewController, let indexPath else {
                return
            }
            
            guard let imageUrl = URL(string: imagesListService.photos[indexPath.row].largeImageURL) else { return }
            viewController.fullImageURL = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func addObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let self = self else { return }
                self.presenter?.updateTableViewAnimated()
            }
    }
    
    private func configureTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func showTableViewAnimate(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    // MARK: - Alert View
    
    private func showAlertError() {
        alertPresenter = AlertPresenter(viewController: self)
        
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            buttonText: "Ок",
            completion: nil
        )
        
        alertPresenter?.showAlert(alertModel: alertModel)
    }
}

// MARK: - Extensions

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        imageListCell.setImage(url: imagesListService.photos[indexPath.row].thumbImageURL)
        
        let date = dateFormatter.string(from: imagesListService.photos[indexPath.row].createdAt ?? Date())
        imageListCell.configCell(date: date)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count &&
            !ProcessInfo.processInfo.arguments.contains("testMode") {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let image = imagesListService.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
                let photo = presenter?.photos[indexPath.row] else { return }
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let body):
                presenter?.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: !photo.isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self.showAlertError()
            }
        }
    }
}
