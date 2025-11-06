

import UIKit

class Trainer_Add_Supplement: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var about_TV: UITextView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var nextButton_Height: NSLayoutConstraint!
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        about_TV.delegate = self
        about_TV.addDoneButtonOnKeyboard()
        
        about_TV.textColor = UIColor.lightGray
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextButton.setTitle("Submit", for: .normal)
        interface_Title.text = "Supplement"
        if particularPrograms?.suppliment != ""{
            about_TV.text = particularPrograms?.suppliment ?? "Write About Supplement"
        }else{
           about_TV.text = "Write About Supplement"
        }
    }
    
    
    //MARK : IB's Action
    
    @IBAction func next(_ sender: UIButton) {
         if about_TV.text == "" || about_TV.text == "Write About Supplement"{
            UniversalMethod.universalManager.alertMessage("Description about Supplement are required", self.navigationController)
         }else{
             addSuppliment(parameters:["program_id":particularPrograms?.id ?? "0", "suppliment":about_TV.text ?? ""] )
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
}

extension Trainer_Add_Supplement: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            
            if about_TV.text == "" || about_TV.text == "Write About Supplement"{
                textView.text = ""
            }
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write About Supplement"
            textView.textColor = UIColor.lightGray
        }
    }
    
}


