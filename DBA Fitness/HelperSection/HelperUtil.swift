import Foundation
import UIKit

class HelperUtil {

    public static func getCurrentVC(fetch: @escaping(UIViewController) -> Void) {
        DispatchQueue.main.async {
            if #available(iOS 13, *) {
                if let currentVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.topViewController() {
                    fetch(currentVC)
                }
            } else {
                if let currentVC = UIApplication.shared.keyWindow?.topViewController() {
                    fetch(currentVC)
                }
            }
        }
    }

    @objc static func handleBack(_ sender: UIBarButtonItem) {
        HelperUtil.getCurrentVC { res in
            res.navigationController?.popViewController(animated: true)
        }
    }

    public static func fieldsSetUp(_ textFields: [UITextField]? = nil, _ textViews: [UITextView]? = nil) {
        if let textFields = textFields {
            _ = textFields.map({ field in field.addDoneButtonOnKeyboard() })
        }

        if let textViews = textViews {
            _ = textViews.map({ field in field.addDoneButtonOnKeyboard() })
        }
    }

    public static func makeRootVC(_ rootVC: UIViewController) {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
