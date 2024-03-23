import ProgressHUD
import UIKit

final class UIBlockingProgressHUD {
    
    // MARK: - Properties
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    // MARK: - Methods
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
