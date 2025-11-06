
import UIKit
import WebKit

class StripeAccountIntegration: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var doneView: UIView!
    
    var isSignUp = false
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NVActivityIndicator.managerHandler.showIndicator()
        handleSetUserSession()
        
        if isSignUp {
            doneView.isHidden = false
        } else {
            doneView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NVActivityIndicator.managerHandler.showIndicator()
        handleStripeIntegration()
    }
    
    //MARK : IB's Action
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        let storyBoard = AppStoryboard.Trainer_Setting.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Upgrade_Subscription") as! Upgrade_Subscription
        vc.entryPoint = .Onboarding
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //UniversalMethod.universalManager.pushVC("Trainer_About", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    //MARK: Helper's Method
}

extension StripeAccountIntegration: WKNavigationDelegate {
    
    func handleStripeIntegration(){
        let webView = WKWebView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.mainView.frame.size.width,
                                              height: self.mainView.frame.size.height))
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        self.mainView.addSubview(webView)
        if let loggedUserEmail = DataSaver.dataSaverManager.fetchData(key: "email") as? String{
            let strCompleteURL = "\(Constants.stripeAccountRedirectURL)\(loggedUserEmail)"
            if let url = URL(string: strCompleteURL){
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        /*
         success: http://18.116.178.160/dba/home/success
         failure:http://18.116.178.160/dba/home/failure
         */
        if let url = webView.url?.absoluteString {
            if url.contains("https://connect.stripe.com/oauth/v2/authorize?") {
                NVActivityIndicator.managerHandler.stopIndicator()
            } else if url.contains("success") {
                let alert = UIAlertController(title: "Stripe Connect",
                                              message: "Your account has been linked successfully with Stripe",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { action in
                    DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: true)
                    if self.isSignUp {
                        let storyBoard = AppStoryboard.Trainer_Setting.instance
                        let vc = storyBoard.instantiateViewController(withIdentifier: "Upgrade_Subscription") as! Upgrade_Subscription
                        vc.entryPoint = .Onboarding
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }  else if url.contains("failure") {
                DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: false)
                Toast.show(message: "Stripe connect failed. Please try again.", controller: self)
            } else {

            }
        }
    }
}

extension UIViewController{
    
    func handleSetUserSession(){
        if let userID = DataSaver.dataSaverManager.fetchData(key: "userid") as? String{
            if userID.isEmpty{
                Toast.show(message: "Trainer ID not found", controller: self)
            }else{
                self.setSession(parameters: [:], userID)
            }
        }
    }
    
    func setSession(parameters:[String :Any], _ userID:String){
        if Connectivity.isConnectedToInternet {
            
            let remoteURL = ApiURLs.set_session + "user_id=\(userID)"
            
            apimethod.commonMethod(url: remoteURL, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                // NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}
