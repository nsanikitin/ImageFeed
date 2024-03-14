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
                showAlertError()
                fatalError("Failed to prepare for \(showWebViewViewControllerIdentifier)")
            }
            webViewViewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
    }
    
    func showAlertError() {
        alertPresenter = AlertPresenter(viewController: self)
        
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: {
                return
            }
        )
        
        alertPresenter?.showAlert(alertModel: alertModel)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
