
import UIKit

class Edit_Trainer_About: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    @IBOutlet weak var goals_TV: UITextView!
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        // Do any additional setup after loading the view.
        goals_TV.delegate = self
        goals_TV.addDoneButtonOnKeyboard()
        let aboutBio = userInfo?.data?.about ?? ""
        if aboutBio.isEmpty {
            goals_TV.text = "Write about yourself"
            goals_TV.textColor = UIColor.lightGray
        } else {
            goals_TV.text = aboutBio
            goals_TV.textColor = UIColor.white
        }
        
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        secondaryView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        NotificationCenter.default.addObserver(self, selector: #selector(updatedProfile(_:)), name: NSNotification.Name(rawValue: Constants.isUpdatedProfile), object: nil)
    }
    
    @objc func updatedProfile(_ notify:NSNotification){
        let isUpdated = notify.object as? Bool
        if isUpdated == true{
            self.removeAnimate()
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func cancel(_ sender: UIButton) {
        NotificationCenter.default.post(name:NSNotification.Name(Constants.populateProfileDataForEdit), object:true)
        removeAnimate()
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        if goals_TV.text == "" || goals_TV.text == "Write about yourself"{
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message: "Bio cannot be empty")
        }else{
            Constants.isEditAbout = "1"
            addAbout(parameters:["about":goals_TV.text ?? ""] )
        }
    }
    
    //MARK: Helper's Method
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}

extension Edit_Trainer_About: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            if goals_TV.text == "" || goals_TV.text == "Write about yourself"{
                textView.text = ""
            }
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about yourself"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
