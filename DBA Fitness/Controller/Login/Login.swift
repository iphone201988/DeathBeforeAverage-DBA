
import UIKit
import AuthenticationServices
import FacebookLogin
import FBSDKLoginKit

class Login: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgot: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var appleSignIn: UIButton!
    @IBOutlet weak var facebookSignIn: UIButton!
    @IBOutlet weak var hide_Show_Code: UIButton!
    @IBOutlet weak var hide_Show_Icon: UIImageView!
    @IBOutlet weak var appleImage: UIImageView!
    @IBOutlet weak var fbImage: UIImageView!
    
    var apiCallTimer: Timer?
    var verifyParams = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        emailTF.delegate = self
        passwordTF.delegate = self
        emailTF.addDoneButtonOnKeyboard()
        passwordTF.addDoneButtonOnKeyboard()
        
        emailTF.placeholderColor(color: UIColor.white)
        passwordTF.placeholderColor(color: UIColor.white)
        hide_Show_Code.tag = 0
        hide_Show_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
        
        appleImage.imageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0)
        fbImage.imageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0)
        login.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        emailTF.modifyClearButtonWithImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(knowAboutAccountVerifyStatus(_:)), name: NSNotification.Name(rawValue: Constants.loginknowAboutAccountVerifyStatus), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  performExistingAccountSetupFlows()
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func hide_Show(_ sender: UIButton) {
        
        if  hide_Show_Code.tag == 0{
            hide_Show_Code.tag = 1
            hide_Show_Icon.image = #imageLiteral(resourceName: "ShowPassIcon")
            passwordTF.isSecureTextEntry = false
        }else{
            hide_Show_Code.tag = 0
            hide_Show_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
            passwordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func forgotAction(_ sender: UIButton) {
        /*   let storyboard = AppStoryboard.Auth.instance
         let loginScene = storyboard.instantiateViewController(withIdentifier: Auth.Forgot.rawValue)
         self.navigationController?.pushViewController(loginScene, animated: true) */
        
        UniversalMethod.universalManager.pushVC("Forgot", self.navigationController, storyBoard: AppStoryboard.Auth.rawValue)
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let userEmail = emailTF.text?.trimmed() ?? ""
        let userPassword = passwordTF.text?.trimmed() ?? ""
        
        //login(parameters:["email":userEmail, "password":userPassword, "devicetype":"1", "devicetoken":Constant.DeviceTokenId] )
        
        if userEmail == "" {
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message: "Email field must be filled")
        }else{
            
            if userEmail.isEmail{
                login(parameters:["email":userEmail, "password":userPassword, "devicetype":"1", "devicetoken":Constant.DeviceTokenId], isShowLoading: nil, isComingFrom: "LoginVC" )
            }else{
                UniversalMethod.universalManager.custom_ActionSheet(vc: self, message: "Enter valid email")
            }
        }
    }
    
    @IBAction func apple_Login(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
            UniversalMethod.universalManager.alertMessage("For Apple login minimum 13.0 iOS version required", self.navigationController)
        }
    }
    
    @IBAction func facebook_Login(_ sender: UIButton) {
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self, completion: {loginResult in
            switch loginResult {
            case .failed(let error): let _ = error
            case .cancelled: let _ = "User cancelled login."
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }})
    }
    
    @IBAction func normal_SignUp(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Sign_Up", self.navigationController, storyBoard: AppStoryboard.Auth.rawValue)
    }
    
    //MARK: Helper's Method
    
    //function is fetching the user data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender, first_name, last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    /* let info = result as! [String : Any]
                     p_login["grant_type"] = "password"
                     p_login["client_id"] = "default_client_id"
                     p_login["username"] = info["email"] as? String
                     p_login["password"] = "12345678"
                     p_login["client_secret"] = "default_client_secret"
                     self.getToken(parameters:p_login )*/
                    
                    if let userDict = result as? NSDictionary {
                        let name = userDict["name"] as? String
                        let id = userDict["id"] as? String
                        let email = userDict["email"] as? String

                        self.verifyParams = email ?? ""
                        
                        if email == "" || userDict["email"] == nil{
                            Toast.show(message: "Please enable facebook's email", controller: self)
                        }else{
                            self.firstSignUp(parameters:["email" :email ?? "",
                                                         "devicetype":"1",
                                                         "devicetoken":Constant.DeviceTokenId,
                                                         "token":id ?? "",
                                                         "is_apple":"2"],
                                             isShowLoading: nil,
                                             isComingFrom: "LoginVC" )
                        }
                    }
                }
            })
        }
    }
    
    @objc func knowAboutAccountVerifyStatus(_ notify:NSNotification){
        
        let isGetted = notify.object as? Bool
        if isGetted == true{
            apiCallTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callApiRequest), userInfo: nil, repeats: true)
        }else{
            apiCallTimer?.invalidate()
        }
    }
    
    @objc func callApiRequest(){
        let verifyParams = self.verifyParams.trimmed()
        
        
        
        self.knowAboutAccountVerifyStatus(parameters:["email":verifyParams])
    }
}

extension Login : ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        /*  let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)*/
    }
    
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
            KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
            KeychainItem.currentUserEmail = appleIDCredential.email
            

            
            if let identityTokenData = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
            }
            
            //Show Home View Controller
            //  HomeViewController.Push()
            
            
            verifyParams = appleIDCredential.user
            
            self.firstSignUp(parameters:["email" :appleIDCredential.email ?? "", "devicetype":"1", "devicetoken":Constant.DeviceTokenId, "token":appleIDCredential.user,"is_apple":"1" ],isShowLoading: nil, isComingFrom: "LoginVC" )
            
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension Login : ASAuthorizationControllerPresentationContextProviding {

    @available(iOS 13.0, *)
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension Login : UITextFieldDelegate{ }

extension Login{
    func knowAboutAccountVerifyStatus(parameters:[String :Any]){
        if Connectivity.isConnectedToInternet {

            apimethod.commonMethod(url: ApiURLs.get_account_status_by_email, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==400 || result.statusCode==401){
                        UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)

                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)
                        
                        
                        
                        let dataStatus = userInfo?.status
                        
                        if (dataStatus == 200){
                            locallySaveLoggedUserData(userInfo)
                            
                            if let is_connected_stripe = userInfo?.data?.is_connected_stripe {
                                if is_connected_stripe == "1" {
                                    DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: true)
                                } else {
                                    DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: false)
                                }
                            } else {
                                DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: false)
                            }

                            if userInfo?.data?.type == "0"{

                                self.apiCallTimer?.invalidate()

                                UniversalMethod.universalManager.navigateToChooseRole()
                            }else if (userInfo?.data?.type == "1"){
                                UniversalMethod.universalManager.navigateToTrainer()
                            }else if (userInfo?.data?.type == "2"){
                                UniversalMethod.universalManager.navigateToClient()
                            }
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }else if(result.statusCode==404){
                        UniversalMethod.universalManager.alertMessage("This account has no registration.", self.navigationController)
                    }else if(result.statusCode==405){
                        UniversalMethod.universalManager.alertMessage("Please verify your email. Once you verify, you can continue with onboarding section. Note: Please proceed with the SignUp procedure using a validated email if your account has been verified but you haven't finished the second phase.",
                                                                      self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}

/*
 Please check your email for account verification via your cell phone. The onboarding process will open immediately. If verifying from a computer, after verifying open the app, select “sign up”, and re-enter your password to begin account creation.
 */
/*
 Please verify your email. Once you verify, you can continue with onboarding section. Note: Please proceed with the SignUp procedure using a validated email if your account has been verified but you haven't finished the second phase.
 */
