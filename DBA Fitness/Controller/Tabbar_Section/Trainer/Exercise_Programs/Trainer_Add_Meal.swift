

import UIKit

class Trainer_Add_Meal: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var meal_Day: UITextField!
    @IBOutlet weak var meal_Name: UITextField!
    @IBOutlet weak var meal_Configuration: UITextView!
    @IBOutlet weak var interfaceTitle: UILabel!
    
    @IBOutlet weak var addMealTitle: UILabel!
    
    var programIDs = Int()
    var userRole = ""
    var newUrl = ""
    var mealDict = [String:Any]()
    var mealArray = [[String:Any]]()
    var selectedDay = Int()
    var contentType = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meal_Day.placeholderColor(color: UIColor.white)
        meal_Name.placeholderColor(color: UIColor.white)
        
        if Constants.selectedMealDay == "1"{
            meal_Day.text = "Monday"
        }else if (Constants.selectedMealDay == "2"){
            meal_Day.text = "Tuesday"
        }else if (Constants.selectedMealDay == "3"){
            meal_Day.text = "Wednesday"
        }else if (Constants.selectedMealDay == "4"){
            meal_Day.text = "Thursday"
        }else if (Constants.selectedMealDay == "5"){
            meal_Day.text = "Friday"
        }else if (Constants.selectedMealDay == "6"){
            meal_Day.text = "Saturday"
        }else if (Constants.selectedMealDay == "7"){
            meal_Day.text = "Sunday"
        }
        meal_Day.isUserInteractionEnabled = false
        
        meal_Configuration.delegate = self
       
        meal_Configuration.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if contentType == "1"{
            interfaceTitle.text = "Add Meal"
            meal_Configuration.text = "Write About Meal"
            addMealTitle.text = "Meal:"
            meal_Name.placeholder = "Ex: Chocolate Shake, Pancake etc."
            
            
        }else{
            interfaceTitle.text = "Add Supplement"
            meal_Configuration.text = "Write About Supplement"
            addMealTitle.text = "Supplement:"
            meal_Name.placeholder = "Ex: Creatine"
            
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func save(_ sender: UIButton) {
         Constants.isAddMeal = "1"
        
        if meal_Configuration.text != "" && meal_Name.text != "" && meal_Configuration.text != "Write About Meal" && meal_Configuration.text != "Write About Supplement" {
            programMeal(parameters:["day_id":Constants.selectedMealDay, "program_id":particularPrograms?.id ?? "0", "meal_day":meal_Day.text ?? "", "meal_title":meal_Name.text ?? "", "meal_description":meal_Configuration.text ?? "", "type":contentType] )
        }else{
            UniversalMethod.universalManager.alertMessage("Meal's name and description cannot be empty", self.navigationController)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
}

extension Trainer_Add_Meal: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            
            if contentType == "1"{
                textView.text = "Write About Meal"
            }else{
                textView.text = "Write About Supplement"
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
}
