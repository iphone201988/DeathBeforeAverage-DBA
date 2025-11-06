
import UIKit

class Trainer_Meal_Details: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var interfaceTitle: UILabel!
    @IBOutlet weak var mealNumber: UILabel!
    @IBOutlet weak var mealTitle: UILabel!
    @IBOutlet weak var mealDesc: UITextView!
    @IBOutlet weak var mealName: UITextField!
    
    var selectedRow = Int()
    //var mealDict:M_CPEINutrition?
    var programIDs = Int()
    var userRole = ""
    var newUrl = ""
    var mealDicts = [String:Any]()
    var mealArray = [[String:Any]]()
    var selectedDay = Int()
    var contentType = String()
    var isNavigateViaSentProgramDetails = false
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        // particularProgramMeal
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                editLabel.isHidden = false
                editButton.isUserInteractionEnabled = true
                mealName.isUserInteractionEnabled = true
                mealDesc.isUserInteractionEnabled = true
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                editLabel.isHidden = true
                editButton.isUserInteractionEnabled = false
                mealName.isUserInteractionEnabled = false
                mealDesc.isUserInteractionEnabled = false
            }
        }
        
        if contentType == "1"{
            interfaceTitle.text = "Meal \(selectedRow + 1)"
        }else{
            interfaceTitle.text = "Supplement \(selectedRow + 1)"
        }
        
        mealNumber.text = particularProgramMeal?.mealDay
        mealName.text = particularProgramMeal?.mealTitle
        mealDesc.text = particularProgramMeal?.mealDescription
        mealName.placeholderColor(color: UIColor.white)
        
        if isNavigateViaSentProgramDetails {
            editLabel.isHidden = true
            editButton.isUserInteractionEnabled = false
            mealName.isUserInteractionEnabled = false
            mealDesc.isUserInteractionEnabled = false
        }
    }

    
    //MARK : IB's Action
    
    @IBAction func edit(_ sender: UIButton) {
         Constants.isAddMeal = "2"
        
        if mealDesc.text != "" && mealName.text != ""{
            programMeal(parameters:["day_id":Constants.selectedMealDay, "program_id":particularPrograms?.id ?? "0", "meal_day":mealNumber.text ?? "", "meal_title":mealName.text ?? "", "meal_description":mealDesc.text ?? "", "meal_id":particularProgramMeal?.id ?? "0", "type":contentType] )
        }else{
            UniversalMethod.universalManager.alertMessage("Meal's name and description cannot be empty", self.navigationController)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
}


