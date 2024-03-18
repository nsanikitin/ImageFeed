import UIKit

final class AlertPresenter {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
