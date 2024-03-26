import UIKit
import WebKit

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    
    // MARK: - Properties
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var webView: WKWebView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        //        webViewLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        //        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    // MARK: - Methods
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    //    private func updateProgress() {
    //        progressView.progress = Float(webView.estimatedProgress)
    //        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    //    }
    
    //    private func webViewLoading() {
    //        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
    //            assertionFailure("Authorize URL is not exist")
    //            return
    //        }
    //
    //        urlComponents.queryItems = [
    //            URLQueryItem(name: "client_id", value: Constants.accessKey),
    //            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
    //            URLQueryItem(name: "response_type", value: "code"),
    //            URLQueryItem(name: "scope", value: Constants.accessScope)
    //        ]
    //        let url = urlComponents.url!
    //
    //        let request = URLRequest(url: url)
    //        webView.load(request)
    //    }
    
    // MARK: - Actions
    
    @IBAction private func didTapeBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
