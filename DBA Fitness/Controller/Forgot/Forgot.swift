
import UIKit
import AuthenticationServices
import FacebookLogin
import FBSDKLoginKit

class Forgot: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var sendButton: GradientButton!
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        emailTF.delegate = self
        emailTF.addDoneButtonOnKeyboard()
        emailTF.placeholderColor(color: UIColor.white)
        sendButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        emailTF.modifyClearButtonWithImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    //MARK : IB's Action
    
    @IBAction func sendLink(_ sender: UIButton) {
        
        let emailString = emailTF.text?.trimmed() ?? ""
        
        guard !emailString.isEmpty else {
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message: "Email cannot be empty")
            return
        }
        
        guard emailString.isEmail else {
             UniversalMethod.universalManager.custom_ActionSheet(vc: self, message: "Enter valid email")
            return
        }
        
        forgotPassword(parameters:["email":emailString] )
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
 
}


extension Forgot : UITextFieldDelegate{ }




