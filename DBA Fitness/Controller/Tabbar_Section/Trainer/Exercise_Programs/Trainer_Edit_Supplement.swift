
import UIKit

class Trainer_Edit_Supplement: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    @IBOutlet weak var goals_TV: UITextView!
    @IBOutlet weak var supplementName: UITextField!
    
    var programID = Int()
    var name:String?
    var desc:String?
    var p_SupplementArray = [[String:Any]]()
    var selectedIndex:Int?
    var userRole = ""
    var newUrl = ""
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        // Do any additional setup after loading the view.
        goals_TV.delegate = self
        goals_TV.addDoneButtonOnKeyboard()
        goals_TV.text = "Write about Supplement"
        goals_TV.textColor = UIColor.lightGray
        mainView.customView(borderWidth:0.0, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        secondaryView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        supplementName.placeholderColor(color: UIColor.white)
        supplementName.text = name ?? "N/A"
        goals_TV.text = desc ?? "N/A"
        p_SupplementArray.removeAll()
        userRole = DataSaver.dataSaverManager.fetchData(key: "Role") as? String ?? ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeViews(_:)), name: NSNotification.Name(rawValue: Constants.removeView), object: nil)
    }
    
    @objc func removeViews(_ notify:NSNotification){
        let isRemove = notify.object as? Bool
        if isRemove == true{
            self.removeAnimate()
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func cancel(_ sender: UIButton) {
        removeAnimate()
    }
    
    @IBAction func save(_ sender: UIButton) {
       /* p_EditSupplement["day"] = ""
        p_EditSupplement["description"] = goals_TV.text ?? ""
        p_EditSupplement["name"] = supplementName.text ?? ""
        p_SupplementArray.append(p_EditSupplement)
        p_Supplement["supplements"] = p_SupplementArray
        //editSupplements(parameters:p_Supplement)
        
        editSupplements(parameters:p_Supplement, programID:programID, userRole:userRole, selectedRow:"\(selectedIndex ?? 0)")*/
        
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


extension Trainer_Edit_Supplement: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about Supplement"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
