import UIKit

final class AlertPresenter {
    weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController?) {
        self.viewController = viewController
    }

    func showAlert() {
        
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            completion()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
}
