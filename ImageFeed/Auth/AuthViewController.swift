import UIKit

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    // MARK: - Properties
    
    private let showWebViewViewControllerIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    var alertPresenter: AlertPresenter?
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewViewControllerIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(showWebViewViewControllerIdentifier)")
                
                // TODO: Show Alert
            }
            webViewViewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func showAlertError() {
        alertPresenter = AlertPresenter(viewController: self)
        
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        )
        
        alertPresenter?.showAlert(alertModel: alertModel)
    }
}
