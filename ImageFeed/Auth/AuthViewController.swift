import UIKit

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    // MARK: - Properties
    
    private let showWebViewViewControllerIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewViewControllerIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewViewControllerIdentifier)")
                return
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
}
