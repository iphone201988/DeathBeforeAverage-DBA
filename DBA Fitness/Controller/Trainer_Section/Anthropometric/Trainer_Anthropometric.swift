
import UIKit

class Trainer_Anthropometric: UIViewController {

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

    var age_PickerView: UIPickerView!
    var body_Fat_PickerView: UIPickerView!
    var gender_PickerView: UIPickerView!

    var age_fat_Values = [String]()
    var genders = ["Male", "Female", "Other / Not Listed"]
    var anthropometricData = [String:Any]()
    var anthropometricDict = [String:Any]()
    
    // Date picker instance
     private let datePicker = UIDatePicker()

    //MARK : Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        nextButton.isEnabled = false

        age_fat_Values.removeAll()

        for i in 1..<101{
            age_fat_Values.append("\(i)")
        }

//        age_PickerView = UIPickerView()
//        age_PickerView.dataSource = self
//        age_PickerView.delegate = self
        //age.inputView = age_PickerView
        age.addInputViewDatePicker(self, #selector(selectedDatePicker), Date())

        body_Fat_PickerView = UIPickerView()
        body_Fat_PickerView.dataSource = self
        body_Fat_PickerView.delegate = self
        bodyFat.inputView = body_Fat_PickerView

        gender_PickerView = UIPickerView()
        gender_PickerView.dataSource = self
        gender_PickerView.delegate = self
        gender.inputView = gender_PickerView

        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        //age.text = gradePickerValues[0]

        age.text = age_fat_Values.first
        bodyFat.text = age_fat_Values.first
        gender.text = genders.first
    }
    
    @objc func selectedDatePicker() {
        if let datePicker = age.inputView as? UIDatePicker {
            age.calculateDetailedAge(from: datePicker.date)
            age.resignFirstResponder()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        height.placeholderColor(color: UIColor.white)
        competitive_weight.placeholderColor(color: UIColor.white)
        offSeason_weight.placeholderColor(color: UIColor.white)
        age.placeholderColor(color: UIColor.white)
        gender.placeholderColor(color: UIColor.white)
        neckSize.placeholderColor(color: UIColor.white)
        shoulderSize.placeholderColor(color: UIColor.white)
        bicepSize.placeholderColor(color: UIColor.white)
        chestSize.placeholderColor(color: UIColor.white)
        forearmSize.placeholderColor(color: UIColor.white)
        waistSize.placeholderColor(color: UIColor.white)
        hipsSize.placeholderColor(color: UIColor.white)
        thighSize.placeholderColor(color: UIColor.white)
        calfSize.placeholderColor(color: UIColor.white)

        textField_Validation(text_Field: height)
        textField_Validation(text_Field: competitive_weight)
        textField_Validation(text_Field: offSeason_weight)
        textField_Validation(text_Field: age)
        textField_Validation(text_Field: gender)
        textField_Validation(text_Field: neckSize)
        textField_Validation(text_Field: shoulderSize)
        textField_Validation(text_Field: bicepSize)
        textField_Validation(text_Field: chestSize)
        textField_Validation(text_Field: forearmSize)
        textField_Validation(text_Field: waistSize)
        textField_Validation(text_Field: hipsSize)
        textField_Validation(text_Field: thighSize)
        textField_Validation(text_Field: calfSize)

        height.addDoneButtonOnKeyboard()
        competitive_weight.addDoneButtonOnKeyboard()
        offSeason_weight.addDoneButtonOnKeyboard()
//        age.addDoneButtonOnKeyboard()
        gender.addDoneButtonOnKeyboard()
        neckSize.addDoneButtonOnKeyboard()
        shoulderSize.addDoneButtonOnKeyboard()
        bicepSize.addDoneButtonOnKeyboard()
        chestSize.addDoneButtonOnKeyboard()
        forearmSize.addDoneButtonOnKeyboard()
        waistSize.addDoneButtonOnKeyboard()
        hipsSize.addDoneButtonOnKeyboard()
        thighSize.addDoneButtonOnKeyboard()
        calfSize.addDoneButtonOnKeyboard()

        skipButton.isEnabled = true
        skipButton.alpha = 1.0
    }

    //MARK : IB's Action

    @IBAction func next(_ sender: UIButton) {
        anthropometricDict["calf_size"] = calfSize.text
        anthropometricDict["height"] = height.text
        anthropometricDict["waist_size"] = waistSize.text
        anthropometricDict["competitive"] = competitive_weight.text
        anthropometricDict["forearm_size"] = forearmSize.text
        anthropometricDict["neck_size"] = neckSize.text
        anthropometricDict["bicep_size"] = bicepSize.text
        anthropometricDict["sholuder_size"] = shoulderSize.text
        anthropometricDict["off_season"] = offSeason_weight.text
        anthropometricDict["age"] = age.text
        anthropometricDict["thigh_size"] = thighSize.text
        anthropometricDict["hips_size"] = hipsSize.text
        anthropometricDict["body_fat_percentage"] = bodyFat.text
        anthropometricDict["sex"] = gender.text
        anthropometricDict["chest_size"] = chestSize.text
        Constants.isEditAnthropometric = "0"
        addAnthropometric(parameters:anthropometricDict )
    }

    @IBAction func skip(_ sender: UIButton) {
        let currentRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String
        if currentRole == Role.trainer.rawValue{
            let story = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: Trainer_Tabbar.Trainer_Bar.rawValue) as! MainTabbar_Controller
            vc.selectedIndex = 4
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }else if (currentRole == Role.client.rawValue){
            UniversalMethod.universalManager.pushVC("Client_Goals", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
        }
    }

    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


    //MARK: Helper's Method

    @objc func textIsChanging(_ textField:UITextField){
        if height.text == "" && competitive_weight.text == "" && offSeason_weight.text == "" && age.text == "" && gender.text == "" && neckSize.text == "" && shoulderSize.text == "" && bicepSize.text == "" && chestSize.text == "" && forearmSize.text == "" && waistSize.text == "" && hipsSize.text == "" && thighSize.text == "" && calfSize.text == ""{
            nextButton.isEnabled = false
            //            skipButton.isEnabled = true
            //            skipButton.alpha = 1.0
        }else{
            nextButton.isEnabled = true
            //            skipButton.isEnabled = false
            //            skipButton.alpha = 0.5
        }
    }

    func textField_Validation(text_Field: UITextField){
        text_Field.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
    }
}

extension Trainer_Anthropometric: UIPickerViewDelegate, UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        if pickerView == age_PickerView || pickerView == body_Fat_PickerView{
            return age_fat_Values.count
        }else{
            return genders.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == age_PickerView || pickerView == body_Fat_PickerView{
            return age_fat_Values[row]
        }else{
            return genders[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){

        if pickerView == age_PickerView{
            age.text = age_fat_Values[row]
        }else if pickerView == body_Fat_PickerView{
            bodyFat.text = age_fat_Values[row]
        }else{
            gender.text = genders[row]
        }

        //self.view.endEditing(true)
    }


}




