
import UIKit

class Trainer_Add_Program: UIViewController, UITextFieldDelegate {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var about_TV: UITextView!
    @IBOutlet weak var training_Level: UITextField!
    @IBOutlet weak var training_Goal: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var dayOfWeek: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var program_Name: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var programNameTV: UITextView!
    var training_category: UIPickerView!
    var male_female: UIPickerView!
    var day: UIPickerView!
    var trainingLevelPickerView: UIPickerView!
    
    var category_options = ["Bodybuilding", "Strongman", "Powerlifting", "Olympic Lifting", "CrossFit", "Pilates","Yoga", "Calisthenics", "Athletics", "WeightLoss", "Rehab & Recovery", "Other"]
    var category_options1 = ["bodybuilding", "strongman", "powerlifting", "olympiclifting", "crossFit", "pilates","yoga", "calisthenics", "athletics", "weightLoss", "rehabandRecovery", "other"]
    
    var gender_options = ["Male", "Female", "Other"]
    
    var trainingLevel = ["Beginner", "Intermediate", "Advanced"]
    
    var days = ["1","2", "3", "4", "5", "6", "7"]
    var trainerID = Int()
    var category1 = ""
    var training = [String]()
    var userRole = ""
    
    var desc:String?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        training_Level.placeholderColor(color: UIColor.white)
        training_Goal.placeholderColor(color: UIColor.white)
        category.placeholderColor(color: UIColor.white)
        gender.placeholderColor(color: UIColor.white)
        dayOfWeek.placeholderColor(color: UIColor.white)
        price.placeholderColor(color: UIColor.white)
        //program_Name.placeholderColor(color: UIColor.white)
        
        about_TV.delegate = self
        about_TV.text = "Write a Program Description"
        about_TV.textColor = UIColor.lightGray
        
        programNameTV.delegate = self
        programNameTV.text = "Ex: Off Season Strength & Conditioning"
        programNameTV.textColor = UIColor.lightGray
        
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        about_TV.addDoneButtonOnKeyboard()
        
         training_Level.delegate = self
         training_Goal.delegate = self
         category.delegate = self
         gender.delegate = self
         dayOfWeek.delegate = self
         price.delegate = self
        // program_Name.delegate = self
       
        training_Level.addDoneButtonOnKeyboard()
        training_Goal.addDoneButtonOnKeyboard()
        category.addDoneButtonOnKeyboard()
        gender.addDoneButtonOnKeyboard()
        dayOfWeek.addDoneButtonOnKeyboard()
        price.addDoneButtonOnKeyboard()
        //program_Name.addDoneButtonOnKeyboard()
        
        training_category = UIPickerView()
        male_female = UIPickerView()
        day = UIPickerView()
        trainingLevelPickerView = UIPickerView()
        
        training_category.dataSource = self
        training_category.delegate = self
        
        male_female.dataSource = self
        male_female.delegate = self
        
        day.dataSource = self
        day.delegate = self
        
        trainingLevelPickerView.dataSource = self
        trainingLevelPickerView.delegate = self
        
        category.inputView = training_category
        gender.inputView = male_female
        dayOfWeek.inputView = day
        training_Level.inputView = trainingLevelPickerView
        
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
      
       price.addTarget(self, action:#selector(TextIsChangingForPriceTf), for: .editingChanged)
        //trainerID = DataSaver.dataSaverManager.fetchData(key: "trainerID") as! Int
        //userRole = DataSaver.dataSaverManager.fetchData(key: "Role") as? String ?? ""
        
        category.text = category_options.first
        gender.text = gender_options.first
        dayOfWeek.text = days.first
        training_Level.text = trainingLevel.first
    }
    

    @objc func TextIsChangingForPriceTf(_ tf : UITextField) {
        if tf.text?.trimmingCharacters(in: .whitespaces) == "" {
            price.text = "$"
        }
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == price {
      if textField.text?.trimmingCharacters(in: .whitespaces) == "" {
        price.text = "$"
        }
    }
    }
    //MARK : IB's Action
    
    @IBAction func next(_ sender: UIButton) {
        
        let programName = programNameTV.text?.trimmed()
        let aboutTV = about_TV.text?.trimmed()
        let trainingGoal = training_Goal.text?.trimmed()
        let programPrice = price.text?.trimmed()
        
        let replaced = price.text?.replacingOccurrences(of: "$", with: "")
        
        if programName == "" || aboutTV == "" || programName == "Ex: Off Season Strength & Conditioning" || aboutTV == "Write a Program Description" || training_Level.text == "" || trainingGoal == "" || programPrice == "" || gender.text == "" || dayOfWeek.text == "" || category.text == "" || replaced == "0"{
            
            if replaced == "0"{
                UniversalMethod.universalManager.alertMessage("Price should be more than 0", self.navigationController)
            }else{
                UniversalMethod.universalManager.alertMessage("All fields are required", self.navigationController)
            }
            
        }else{
            Constants.isEditProgram = "0"
            
            let replaced = price.text?.replacingOccurrences(of: "$", with: "")
            addProgram(parameters:["program_name":programName ?? "","program_description":about_TV.text ?? "","level_of_training":training_Level.text ?? "","goals":training_Goal.text ?? "","price":replaced ?? "","category":category.text ?? "","sex":gender.text ?? "","days_per_week":dayOfWeek.text ?? "",] )
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == program_Name{
            let maxLength = 50
            let currentString: NSString = (program_Name.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
}

extension Trainer_Add_Program: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == about_TV{
            if textView.textColor == UIColor.lightGray{
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }else if textView == programNameTV{
            if textView.textColor == UIColor.lightGray{
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == about_TV{
            if textView.text == ""  {
                textView.text = "Write a Program Description"
                textView.textColor = UIColor.lightGray
            }
        }else if textView == programNameTV{
            if textView.text == ""  {
                textView.text = "Ex: Off Season Strength & Conditioning"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == programNameTV{
            let newText = (programNameTV.text as NSString).replacingCharacters(in: range, with: text)
            return newText.count < 50
        }
        return true
    }
}

extension Trainer_Add_Program: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == training_category {
            return category_options.count
        }else if (pickerView == male_female){
            return gender_options.count
        }else if pickerView == trainingLevelPickerView{
            return trainingLevel.count
        }
        else{
            return days.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == training_category {
            return category_options[row]
        }else if (pickerView == male_female){
            return gender_options[row]
        }else if pickerView == trainingLevelPickerView{
            return trainingLevel[row]
        }else{
            return days[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView == training_category {
            category.text = category_options[row]
            category1 = category_options1[row]
        }else if (pickerView == male_female){
            gender.text = gender_options[row]
        }else if pickerView == trainingLevelPickerView{
            training_Level.text = trainingLevel[row]
        }else{
            dayOfWeek.text = days[row]
        }
    }
}

