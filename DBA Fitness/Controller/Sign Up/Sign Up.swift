

import UIKit
import AuthenticationServices
import FacebookLogin
import FBSDKLoginKit

class Sign_Up: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirm_passwordTF: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var agreementTV: UITextView!
    @IBOutlet weak var hide_Show_Password: UIButton!
    @IBOutlet weak var hide_Show_ConfirmPassword: UIButton!
    @IBOutlet weak var password_Icon: UIImageView!
    @IBOutlet weak var confirm_Icon: UIImageView!
    
    var apiCallTimer: Timer?
    var userEmail = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        emailTF.delegate = self
        emailTF.addDoneButtonOnKeyboard()
        passwordTF.delegate = self
        passwordTF.addDoneButtonOnKeyboard()
        confirm_passwordTF.delegate = self
        confirm_passwordTF.addDoneButtonOnKeyboard()
        emailTF.placeholderColor(color: UIColor.white)
        passwordTF.placeholderColor(color: UIColor.white)
        confirm_passwordTF.placeholderColor(color: UIColor.white)
        hide_Show_Password.tag = 0
        password_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
        hide_Show_ConfirmPassword.tag = 0
        confirm_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
        setAgreementsLabelText()
        signUp.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(knowAboutAccountVerifyStatus(_:)), name: NSNotification.Name(rawValue: Constants.signUpknowAboutAccountVerifyStatus), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        apiCallTimer?.invalidate()
    }
    
    //MARK : IB's Action
    
    @IBAction func hide_Show_Password(_ sender: UIButton) {
        
        if  hide_Show_Password.tag == 0{
            hide_Show_Password.tag = 1
            password_Icon.image = #imageLiteral(resourceName: "ShowPassIcon")
            passwordTF.isSecureTextEntry = false
        }else{
            hide_Show_Password.tag = 0
            password_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
            passwordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func hide_Show_ConfirmPassword(_ sender: UIButton) {

        if  hide_Show_ConfirmPassword.tag == 0{
            hide_Show_ConfirmPassword.tag = 1
            confirm_Icon.image = #imageLiteral(resourceName: "ShowPassIcon")
            confirm_passwordTF.isSecureTextEntry = false
        }else{
            hide_Show_ConfirmPassword.tag = 0
            confirm_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
            confirm_passwordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {

        /* let emailString = emailTF.text?.trimmed() ?? ""
         let passwordString = passwordTF.text?.trimmed() ?? ""
         let confirmPasswordString = confirm_passwordTF.text?.trimmed() ?? ""
         do {
         let signUpData = try SignUpData(with: emailString, password: passwordString, confirmPassword: confirmPasswordString)
         firstSignUp(parameters:["email" :signUpData.email, "password":signUpData.password, "devicetype":"1", "devicetoken":Constant.DeviceTokenId] )
         } catch let error as ValidationError {
         UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
         } catch {
         }*/
        
        
        let emailString = emailTF.text?.trimmed() ?? ""
        do {
            let signUpData = try SignUpData(with: emailString)
            
            firstSignUp(parameters:["email" :signUpData.email, "devicetype":"1", "devicetoken":Constant.DeviceTokenId], isShowLoading: nil, isComingFrom: "SignUpVC" )
            userEmail = signUpData.email
            
            /*let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "SetAccountPassword") as! SetAccountPassword
             vc.userEmail = signUpData.email
             self.navigationController?.pushViewController(vc, animated: true)*/
        } catch let error as ValidationError {
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
        } catch {}
        //UniversalMethod.universalManager.pushVC("SetAccountPassword", self.navigationController, storyBoard: AppStoryboard.Auth.rawValue)
        
        //UniversalMethod.universalManager.pushVC("Client_Goals", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func login(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
    
    fileprivate func setAgreementsLabelText() {
        
        agreementTV.delegate = self
        agreementTV.isUserInteractionEnabled = true
        agreementTV.isEditable = false
        
        // Mark:- Setting for Terms and Policy link
        let str  = "By signing up you agree to our Privacy Policy and Terms and Conditions" as NSString
        let attributedString = NSMutableAttributedString(string: str as String)
        attributedString.addAttribute(.link, value: Constants.termsURLPath, range:str.range(of:"Terms and Conditions")
        )
        attributedString.addAttribute(.link, value: Constants.privacyURLPath, range: str.range(of: "Privacy Policy"))
        
        let blueColor = UIColor(red: 0/255, green: 117/255, blue: 187/255, alpha: 1)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: blueColor, range: NSRange.init(location:0, length: str.length))
        
        agreementTV.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: blueColor,
            NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
        ]
        agreementTV.attributedText = attributedString
        agreementTV.textAlignment = .center
        agreementTV.linkTextAttributes = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        agreementTV.textColor = #colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 1, alpha: 1)
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
        self.knowAboutAccountVerifyStatus(parameters:["email":userEmail])
    }
}


extension Sign_Up : UITextFieldDelegate{ }

extension Sign_Up : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
}

extension Sign_Up{
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
                        UniversalMethod.universalManager.alertMessage(" Please verify your email. Once you verify, you can continue with onboarding section. Note: Please proceed with the SignUp procedure using a validated email if your account has been verified but you haven't finished the second phase.", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}



