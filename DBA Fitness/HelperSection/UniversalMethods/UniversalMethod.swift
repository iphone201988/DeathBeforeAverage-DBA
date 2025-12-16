
import UIKit
import AVFoundation

class UniversalMethod: NSObject {
    
    static let universalManager = UniversalMethod()
    
    func setUpView(view:UIView, borderWidth:CGFloat, cornerRadius: CGFloat, borderColor: UIColor){
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor.cgColor
    }
    
    // MARK: Common Method for pushing the View Controller
    func pushMethod(_ id : String, _ navC : UINavigationController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: id) as? UIViewController {
            navC.pushViewController(vc, animated: false)
        }
    }
    
    // MARK: Common Method for Sharing
    func sharingSelector(_ view:UIView, _ controller: UIViewController){
        let text = "This is the text...."
        let shareAll = [text] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        controller.present(activityViewController, animated: true, completion: nil)
    }
    
    func copyLinkButton(_ view:UIView, _ controller: UIViewController){
        UIPasteboard.general.string = "https://com.com/users/6/mr-j-multani?tab=profile"
        if let myString = UIPasteboard.general.string {
            let alert = UIAlertController(title: "Copied", message: "Link: \(myString)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func alertMessage(_ message:String, _ controller: UIViewController?){
        if let controller {
            let alert = UIAlertController(title: "DBA Fitness", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func alertWithoutController(_ message:String){
        let alert = UIAlertController(title: "DBA Fitness", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Common Method for pushing the View Controller
    func pushVC(_ id : String, _ navC : UINavigationController?, storyBoard:String){
        let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
        if
            let navC,
            let vc = storyboard.instantiateViewController(withIdentifier: id) as? UIViewController {
            vc.hidesBottomBarWhenPushed = true
            navC.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: Email's Regex
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if valid {
            valid = !email.contains("..")
        }
        return valid
    }
    
    //MARK: Password's Regex
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\A)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,12}$"
        let valid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        return valid
    }
    
    //MARK: Phone Number's Regex
    func isValidPhoneNumber(contact: String) -> Bool {
        let PHONE_REGEX = "^[1-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: contact)
        return result
    }
    
    //MARK: Username's Regex
    func isValidUsername(username: String) -> Bool {
        let RegEx = "^\\w{7,18}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: username)
    }
    
    func custom_ActionSheet(vc: UIViewController, message:String){
        actionSheetController = UIAlertController (title: "DBA Fitness", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        actionSheetController?.addAction(UIAlertAction(title: message, style: UIAlertAction.Style.cancel, handler: nil))
        if let actionSheetController {
            vc.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    func navigateToAuth() {
        guard let rootVC = UIStoryboard.init(name: AppStoryboard.Auth.rawValue, bundle: nil).instantiateViewController(withIdentifier: Auth.Login.rawValue) as? Login else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func navigateToClient() {
        guard let rootVC = UIStoryboard.init(name: AppStoryboard.Client_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: Client_Tabbar.Client_Bar.rawValue) as? MainTabbar_Controller else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func navigateToTrainer() {
        guard let rootVC = UIStoryboard.init(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: Trainer_Tabbar.Trainer_Bar.rawValue) as? MainTabbar_Controller else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func navigateToChooseRole() {
        guard let rootVC = UIStoryboard.init(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Choose_Role.rawValue) as? Choose_Role else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func navigateToTrainerSignUp() {
        guard let rootVC = UIStoryboard.init(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Trainer_SignUp.rawValue) as? Trainer_SignUp else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func navigateToClientSignUp() {
        guard let rootVC = UIStoryboard.init(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Client_SignUp.rawValue) as? Client_SignUp else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

public func generateThumbnail(url: URL) -> UIImage? {
    do {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                     actualTime: nil)
        return UIImage(cgImage: cgImage)
    } catch {
        return nil
    }
}

public func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL?{
    guard
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    if let imageData = image.pngData(){
        try? imageData.write(to: fileURL, options: .atomic)
        return fileURL
    }
    return nil
}

public func debugLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    if isLogEnable {
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):\(line)] \(function) - \(message)")
    }
#endif
}
