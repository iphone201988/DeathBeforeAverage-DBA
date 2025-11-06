
import UIKit
import SafariServices

class Trainer_About: UIViewController {
    
    //MARK : Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var about_TV: UITextView!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var skipButton: UIButton!
    
    //MARK : Variables
    var userRole = ""
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //handleSetUserSession()
        
        about_TV.delegate = self
        about_TV.addDoneButtonOnKeyboard()
        about_TV.text = "Write about yourself"
        about_TV.textColor = UIColor.lightGray
        
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        nextButton.isEnabled = false
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        if userRole != ""{
            if userRole == Role.trainer.rawValue{
//                if let url = URL(string: Constants.stripeAccountRedirectURL){
//                    let vc = SFSafariViewController(url: url)
//                    present(vc, animated: true, completion: nil)
//                }
            }
        }
    }
    
    //MARK : IB's Action
    @IBAction func next(_ sender: UIButton) {
        
        if about_TV.text == "" || about_TV.text == "Write about yourself"{
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message: "Bio cannot be empty")
        }else{
            Constants.isEditAbout = "0"
            addAbout(parameters:["about":about_TV.text ?? ""] )
        }
    }
    
    @IBAction func skip(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Trainer_Anthropometric", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
}

extension Trainer_About: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.white
        }
        
        if textView.text == "" || textView.text == "Write about yourself"{
            nextButton.isEnabled = false
            skipButton.isEnabled = true
            skipButton.alpha = 1.0
        }else{
            nextButton.isEnabled = true
            skipButton.isEnabled = false
            skipButton.alpha = 0.5
        }
        
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about yourself"
            textView.textColor = UIColor.lightGray
        }
        
        if textView.text == "" || textView.text == "Write about yourself"{
            nextButton.isEnabled = false
            skipButton.isEnabled = true
            skipButton.alpha = 1.0
        }else{
            nextButton.isEnabled = true
            skipButton.isEnabled = false
            skipButton.alpha = 0.5
        }
        
    }
    
}

