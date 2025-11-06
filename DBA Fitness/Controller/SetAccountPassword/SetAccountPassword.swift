
import UIKit
import AuthenticationServices
import FacebookLogin
import FBSDKLoginKit

class SetAccountPassword: UIViewController {
    
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
        
        emailTF.text = userEmail
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let emailString = emailTF.text?.trimmed() ?? ""
        let passwordString = passwordTF.text?.trimmed() ?? ""
        /*let confirmPasswordString = confirm_passwordTF.text?.trimmed() ?? "123"
        do {
            let signUpData = try SignUpData(with: emailString, password: passwordString, confirmPassword: confirmPasswordString)
            firstSignUp(parameters:["email" :signUpData.email, "password":signUpData.password, "devicetype":"1", "devicetoken":Constant.DeviceTokenId] )
        } catch let error as ValidationError {
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
        } catch {
        }*/
        
        do {
            let signUpData = try SignUpData(with: emailString, password: passwordString)
            firstSignUp(parameters:["email" :signUpData.email, "password":signUpData.password, "devicetype":"1", "devicetoken":Constant.DeviceTokenId],isShowLoading: nil, isComingFrom: "SetAccountPassword" )
        } catch let error as ValidationError {
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
        } catch {
        }
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        UniversalMethod.universalManager.navigateToAuth()
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
}


extension SetAccountPassword : UITextFieldDelegate{ }

extension SetAccountPassword : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
}



