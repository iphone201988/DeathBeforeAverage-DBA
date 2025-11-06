
import UIKit
import SDWebImage

class TrainerEditTraining: UIViewController, UITextFieldDelegate {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var thumbnail_Image: UIImageView!
    @IBOutlet weak var thumbnail_View: GradientView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var training_Info_View: UIView!
    @IBOutlet weak var training_Name: UITextField!
    @IBOutlet weak var training_Day: UITextField!
    @IBOutlet weak var about_TV: UITextView!
    @IBOutlet weak var trainingNameTV: UITextView!
    
    @IBOutlet weak var options_dropDown: UIView!
    @IBOutlet weak var options_Tableview: UITableView!
    @IBOutlet weak var options_View_Height: NSLayoutConstraint!
    @IBOutlet weak var workoutDayDropDownButton: UIButton!
    @IBOutlet weak var upDown_Icon: UIImageView!
    @IBOutlet weak var selectedWorkoutDayTV: UITextView!
    
    var selectedDaysArray = [String]()
    var selectedDaysIDArray = [String]()
    var selectedWorkoutDay = [[String:String]]()
    var stringFormatSelectedDaysID = String()
    var daysDict = [["name":"Monday", "id":"1"],
                    ["name":"Tuesday", "id":"2"],
                    ["name":"Wednesday", "id":"3"],
                    ["name":"Thursday", "id":"4"],
                    ["name":"Friday", "id":"5"],
                    ["name":"Saturday", "id":"6"],
                    ["name":"Sunday", "id":"7"]]
    
    //Ex: Arms & Abs
    
    var day: UIPickerView!
    var days = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var programID = Int()
    var trainingArray = [[String:Any]]()
    var trainingDict = [String:Any]()
    var dayID = ""
    var exerciseID = [Int]()
    var videoURL:URL?
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var thumbnil:URL?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //training_Name.placeholderColor(color: UIColor.white)
        //training_Name.delegate = self
        training_Day.placeholderColor(color: UIColor.white)
        
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        training_Info_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        thumbnail_View.layer.cornerRadius = 4.0
        thumbnail_Image.layer.cornerRadius = 4.0
        day = UIPickerView()
        day.dataSource = self
        day.delegate = self
        training_Day.inputView = day
        
        about_TV.delegate = self
        about_TV.text = "Write About Workout"
        about_TV.textColor = UIColor.lightGray
        
        trainingNameTV.delegate = self
        trainingNameTV.text = "Ex: Arms & Abs"
        trainingNameTV.textColor = UIColor.lightGray
        
        imagePickers.delegate = self
        
        if let photo = particularProgramTraining?.training_thumbnil{
            if photo != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                thumbnail_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                thumbnail_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)
            }else{
                thumbnail_Image.image = #imageLiteral(resourceName: "workoutSampleImage")
            }
        }
        
        workoutDayDropDownButton.tag = 0
        upDown_Icon.image = #imageLiteral(resourceName: "ArrowUpIcon")
        options_View_Height.constant = 0.0
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK : IB's Action
    @IBAction func workoutDay_dropDown(_ sender: UIButton) {
        if  workoutDayDropDownButton.tag == 0{
            workoutDayDropDownButton.tag = 1
            upDown_Icon.image = #imageLiteral(resourceName: "ArrowDownIcon")
            self.options_Tableview.layoutIfNeeded()
            options_View_Height.constant = options_Tableview.contentSize.height
        }else{
            workoutDayDropDownButton.tag = 0
            upDown_Icon.image = #imageLiteral(resourceName: "ArrowUpIcon")
            options_View_Height.constant = 0.0
        }
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        if about_TV.text == "" || about_TV.text == "Write About Workout" || trainingNameTV.text == "" || trainingNameTV.text == "Ex: Arms & Abs" || stringFormatSelectedDaysID == ""{
            
            if (trainingNameTV.text == "" || trainingNameTV.text == "Ex: Arms & Abs"){
                UniversalMethod.universalManager.alertMessage("Training name cannot be empty", self.navigationController)
            }else if (about_TV.text == "" || about_TV.text == "Write About Workout"){
                UniversalMethod.universalManager.alertMessage("Training description cannot be empty", self.navigationController)
            }else if(stringFormatSelectedDaysID == ""){
                UniversalMethod.universalManager.alertMessage("Please select a training day", self.navigationController)
            }
            
            //UniversalMethod.universalManager.alertMessage("Exercise Name and Description are Required", self.navigationController)
        }else{
            addProgramTraining(program_id:"",
                               training_name:trainingNameTV.text ?? "",
                               training_description:about_TV.text,
                               training_video:videoURL,
                               training_day:stringFormatSelectedDaysID,
                               apiUrl:ApiURLs.update_training,
                               training_id:particularProgramTraining?.id ?? "0",
                               thumbnil: thumbnil)
        }
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openVideoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePickers.sourceType = .photoLibrary
            self.imagePickers.mediaTypes = ["public.movie"]
            self.imagePickers.allowsEditing = false
            self.present(self.imagePickers, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func exercise1(_ sender: UIButton) {
        
    }
    
    @IBAction func exercise2(_ sender: UIButton) {
        
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        
    }
    
    //MARK: Helper's Method
    func populateData() {
        //training_Name.text = particularProgramTraining?.trainingName
        trainingNameTV.text = particularProgramTraining?.trainingName
        about_TV.text = particularProgramTraining?.trainingDescription
        
        /*
         if particularProgramTraining?.trainingDay == "1"{
         training_Day.text = "Monday"
         dayID = "1"
         }else if (particularProgramTraining?.trainingDay == "2"){
         training_Day.text = "Tuesday"
         dayID = "2"
         }else if (particularProgramTraining?.trainingDay == "3"){
         training_Day.text = "Wednesday"
         dayID = "3"
         }else if (particularProgramTraining?.trainingDay == "4"){
         training_Day.text = "Thursday"
         dayID = "4"
         }else if (particularProgramTraining?.trainingDay == "5"){
         training_Day.text = "Friday"
         dayID = "5"
         }else if (particularProgramTraining?.trainingDay == "6"){
         training_Day.text = "Saturday"
         dayID = "6"
         }else if (particularProgramTraining?.trainingDay == "7"){
         training_Day.text = "Sunday"
         dayID = "7"
         }
         */
        
        let selectedDayArray = particularProgramTraining?.trainingDay?.components(separatedBy: ",")
        
        _ = selectedDayArray?.map({ id in
            if let dayID = Int(id){
                let indexVal = dayID - 1
                if indexVal >= 0{
                    selectedWorkoutDay.append(daysDict[indexVal])
                }
            }
        })

        selectedDaysArray.removeAll()
        selectedDaysIDArray.removeAll()
        
        _ = selectedWorkoutDay.map({ dict in
            selectedDaysArray.append(dict["name"] ?? "")
            selectedDaysIDArray.append(dict["id"] ?? "")
        })
        
        selectedWorkoutDayTV.text = selectedDaysArray.joined(separator: ", ")
        stringFormatSelectedDaysID = selectedDaysIDArray.joined(separator: ",")
        
        if selectedWorkoutDayTV.text == ""{
            selectedWorkoutDayTV.text = "Choose workout days"
            selectedWorkoutDayTV.textColor = UIColor.lightGray
        }else{
            selectedWorkoutDayTV.textColor = .white
        }
        
        options_Tableview.delegate = self
        options_Tableview.dataSource = self
        options_Tableview.register(UINib(nibName: "Category_Cell", bundle: nil), forCellReuseIdentifier: "Category_Cell")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == training_Name{
            let maxLength = 50
            let currentString: NSString = (training_Name.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }

}

extension TrainerEditTraining: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        training_Day.text = days[row]
        dayID = "\(row + 1)"
        self.view.endEditing(true)
    }
}

extension TrainerEditTraining: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == about_TV{
            if textView.textColor == UIColor.lightGray{
                if about_TV.text == "" || about_TV.text == "Write About Workout"{
                    textView.text = ""
                }
                textView.textColor = UIColor.white
            }
        }else if textView == trainingNameTV{
            if textView.textColor == UIColor.lightGray{
                if trainingNameTV.text == "" || trainingNameTV.text == "Ex: Arms & Abs"{
                    textView.text = ""
                }
                textView.textColor = UIColor.white
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == about_TV{
            if textView.text == ""  {
                textView.text = "Write About Workout"
                textView.textColor = UIColor.lightGray
            }
        }else if textView == trainingNameTV{
            if textView.text == ""  {
                textView.text = "Ex: Arms & Abs"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == trainingNameTV{
            let newText = (trainingNameTV.text as NSString).replacingCharacters(in: range, with: text)
            return newText.count < 50
        }
        return true
    }
}

extension TrainerEditTraining: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark: Helper/Calling Function
    func openVideoCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            imagePickers.allowsEditing = false
            self.imagePickers.mediaTypes = ["public.movie"]
            self.present(imagePickers, animated: true, completion: nil)
        }else    {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - CameraPicker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
            let filename = "\(currentTimeStamp)_img.jpg"
            
            if mediaType == "public.movie" {
                videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                guard let videoURL = videoURL else{
                    return
                }
                
                thumbnail_Image.image = generateThumbnail(url: videoURL)
                reducedUploadingImage = thumbnail_Image.image?.compressedImages()
                thumbnil = Trainer_Add_Training.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName:filename)
                self.dismiss(animated: true, completion: nil);
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
        }
    }
    public static func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL?{
        guard
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData(){
            try? imageData.write(to: fileURL, options: .atomic)
            return fileURL
        }
        return nil
    }
}

extension TrainerEditTraining: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysDict.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Category_Cell", for: indexPath) as? Category_Cell {
            let dayDict = daysDict[indexPath.row]
            cell.category_Name.text = dayDict["name"]
            if selectedWorkoutDay.contains(dayDict){
                cell.isSelect_Category.image = #imageLiteral(resourceName: "checkBoxIcon")
            }else{
                cell.isSelect_Category.image = #imageLiteral(resourceName: "uncheckBoxIcon")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dayDict = daysDict[indexPath.row]
        if selectedWorkoutDay.count > 0{
            if selectedWorkoutDay.contains(dayDict){
                let indexVal = selectedWorkoutDay.firstIndex(of: dayDict)
                if let index = indexVal{
                    selectedWorkoutDay.remove(at: index)
                }
            }else{
                selectedWorkoutDay.append(dayDict)
            }
        }else{
            selectedWorkoutDay.append(dayDict)
        }

        let sortedWorkoutDays = selectedWorkoutDay.sorted( by: { $0["id"]! < $1["id"]! })
        selectedWorkoutDay = sortedWorkoutDays
        
        selectedDaysArray.removeAll()
        selectedDaysIDArray.removeAll()
        
        _ = selectedWorkoutDay.map({ dict in
            selectedDaysArray.append(dict["name"] ?? "")
            selectedDaysIDArray.append(dict["id"] ?? "")
        })
        
        selectedWorkoutDayTV.text = selectedDaysArray.joined(separator: ", ")
        stringFormatSelectedDaysID = selectedDaysIDArray.joined(separator: ",")
        
        if selectedWorkoutDayTV.text == ""{
            selectedWorkoutDayTV.text = "Choose workout days"
            selectedWorkoutDayTV.textColor = UIColor.lightGray
        }else{
            selectedWorkoutDayTV.textColor = .white
        }
        
        
        
        options_Tableview.reloadData()
    }
}
