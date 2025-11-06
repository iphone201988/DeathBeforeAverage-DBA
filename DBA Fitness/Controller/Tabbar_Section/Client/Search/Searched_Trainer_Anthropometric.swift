
import UIKit

class Searched_Trainer_Anthropometric: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var competitive_weight: UITextField!
    @IBOutlet weak var offSeason_weight: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var bodyFat: UITextField!
    @IBOutlet weak var neckSize: UITextField!
    @IBOutlet weak var shoulderSize: UITextField!
    @IBOutlet weak var bicepSize: UITextField!
    @IBOutlet weak var chestSize: UITextField!
    @IBOutlet weak var forearmSize: UITextField!
    @IBOutlet weak var waistSize: UITextField!
    @IBOutlet weak var hipsSize: UITextField!
    @IBOutlet weak var thighSize: UITextField!
    @IBOutlet weak var calfSize: UITextField!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var skipButton: UIButton!
  
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calfSize.text = userInfo?.data?.calfSize
        height.text = userInfo?.data?.height
        waistSize.text = userInfo?.data?.waistSize
        competitive_weight.text = userInfo?.data?.competitive
        forearmSize.text = userInfo?.data?.forearmSize
        neckSize.text = userInfo?.data?.neckSize
        bicepSize.text = userInfo?.data?.bicepSize
        shoulderSize.text = userInfo?.data?.sholuderSize
        offSeason_weight.text = userInfo?.data?.offSeason
        age.text = userInfo?.data?.age
        thighSize.text = userInfo?.data?.thighSize
        hipsSize.text = userInfo?.data?.hipsSize
        bodyFat.text = userInfo?.data?.bodyFatPercentage
        gender.text = userInfo?.data?.sex
        chestSize.text = userInfo?.data?.chestSize
        
        calfSize.isUserInteractionEnabled = false
        height.isUserInteractionEnabled = false
        waistSize.isUserInteractionEnabled = false
        competitive_weight.isUserInteractionEnabled = false
        forearmSize.isUserInteractionEnabled = false
        neckSize.isUserInteractionEnabled = false
        bicepSize.isUserInteractionEnabled = false
        shoulderSize.isUserInteractionEnabled = false
        offSeason_weight.isUserInteractionEnabled = false
        age.isUserInteractionEnabled = false
        thighSize.isUserInteractionEnabled = false
        hipsSize.isUserInteractionEnabled = false
        bodyFat.isUserInteractionEnabled = false
        gender.isUserInteractionEnabled = false
        chestSize.isUserInteractionEnabled = false
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
}

