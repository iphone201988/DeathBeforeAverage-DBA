
import UIKit
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import SDWebImage


class Edit_Trainer_Profile: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var upload_View: UIView!
    @IBOutlet weak var uploaded_Image: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var specialist_UpDown: UIButton!
    @IBOutlet weak var upDown_Icon: UIImageView!
    @IBOutlet weak var hide_Show_Password: UIButton!
    @IBOutlet weak var hide_Show_ConfirmPassword: UIButton!
    @IBOutlet weak var password_Icon: UIImageView!
    @IBOutlet weak var confirm_Icon: UIImageView!
    @IBOutlet weak var options_dropDown: UIView!
    @IBOutlet weak var options_Tableview: UITableView!
    @IBOutlet weak var options_View_Height: NSLayoutConstraint!
    @IBOutlet weak var specialist_Options: UITextField!
    @IBOutlet weak var specialist_View_Height: NSLayoutConstraint!
    @IBOutlet weak var choicedOptions: UILabel!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameAvailableStatus: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailViewTop: NSLayoutConstraint!
    @IBOutlet weak var emailIconWidth: NSLayoutConstraint!
    @IBOutlet weak var emailTFHeight: NSLayoutConstraint!
    @IBOutlet weak var underlineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var underlineView: UIView!
    
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var category_options = ["Bodybuilding", "Strongman", "Powerlifting", "Olympic Lifting", "CrossFit", "Pilates","Yoga", "Calisthenics", "Athletics", "WeightLoss", "Rehab & Recovery", "Other"]
    var category_options1 = ["bodybuilding", "strongman", "powerlifting", "olympicLifting", "crossFit", "pilates", "yoga", "сalisthenics", "athletics", "weightLoss", "rehabandRecovery", "other"]
    
    var selectedCategory = [Int:Bool]()
    var photoURL:URL?
    var files = [String]()
    var trainerInfo = [String:Any]()
    var specialisationListArray = [String]()
    var specialisationListArray1 = [String]()
    var newArray:[String]?
    var specialistChoice = String()
    var isUsernameAvailable = false
    var searchedString = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showAnimate()
        
        usernameTF.delegate = self
        usernameTF.addDoneButtonOnKeyboard()
        usernameTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
        firstNameTF.delegate = self
        firstNameTF.addDoneButtonOnKeyboard()
        
        lastNameTF.delegate = self
        lastNameTF.addDoneButtonOnKeyboard()
        
        emailTF.delegate = self
        emailTF.addDoneButtonOnKeyboard()
        emailTF.placeholderColor(color: UIColor.white)
        usernameTF.placeholderColor(color: UIColor.white)
        firstNameTF.placeholderColor(color: UIColor.white)
        lastNameTF.placeholderColor(color: UIColor.white)
        locationTF.placeholderColor(color: UIColor.white)
        specialist_Options.placeholderColor(color: UIColor.white)
        
        specialist_UpDown.tag = 0
        upDown_Icon.image = #imageLiteral(resourceName: "ArrowUpIcon")
        options_View_Height.constant = 0.0
        upload_View.setViewCircle()
        upload_View.viewUpdatedShadow(red: 45/255, green: 38/255, blue: 63/255, alpha: 1.0)
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        uploaded_Image.setRoundImage()
        
        imagePickers.delegate = self
        
        options_Tableview.delegate = self
        options_Tableview.dataSource = self
        options_Tableview.register(UINib(nibName: "Category_Cell", bundle: nil), forCellReuseIdentifier: "Category_Cell")
        
        emailTF.isUserInteractionEnabled = false
        locationTF.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatedProfile(_:)), name: NSNotification.Name(rawValue: Constants.isUpdatedProfile), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyBackground(_:)), name: NSNotification.Name(rawValue: Constants.isBackground), object: nil)
        
        firstNameTF.modifyClearButtonWithImage()
        lastNameTF.modifyClearButtonWithImage()
        usernameTF.modifyClearButtonWithImage()
        
        self.usernameTF.text = userInfo?.data?.username
        
        if userInfo?.data?.username != ""{
            isUsernameAvailable = true
        }else{
            isUsernameAvailable = false
        }
        
        self.firstNameTF.text = userInfo?.data?.firstname
        self.lastNameTF.text = userInfo?.data?.lastname
        self.emailTF.text = userInfo?.data?.email
        //self.locationTF.text = userInfo?.data?.location
        //self.specialist_Options.text = userInfo?.data?.specialist
        self.choicedOptions.text = userInfo?.data?.specialist
        
        if choicedOptions.text == ""{
            self.specialist_Options.isHidden = false
        }else{
            self.specialist_Options.isHidden = true
        }
        
        if let photo = userInfo?.data?.image{
            if photo != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                
                uploaded_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                uploaded_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            }else{
                uploaded_Image.image = #imageLiteral(resourceName: "user")
            }
        }
        
        // Make specialist array for checkmark
        
        specialistChoice = userInfo?.data?.specialist ?? ""
        let array = specialistChoice.components(separatedBy: ",")
        
        for option in array{
            
            let option = option.trimmed()
            
            if category_options.contains(option){
                if let indexVal = category_options.firstIndex(of: option) {
                    selectedCategory[indexVal] = true
                    specialisationListArray.append(category_options[indexVal])
                }

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedLoc = DataSaver.dataSaverManager.fetchData(key: "selectedLoc") as? String{
            if selectedLoc == ""{
                locationTF.text = ""
            }else{
                locationTF.text = selectedLoc
            }
        }else{
            locationTF.text = ""
        }
        
        if let isAppleLogin = DataSaver.dataSaverManager.fetchData(key: "is_apple") as? String{
            if isAppleLogin == "1"{
                emailView.isHidden = true
                emailViewTop.constant = 0.0
                emailIconWidth.constant = 0.0
                emailTFHeight.constant = 0.0
                underlineViewHeight.constant = 0.0
                underlineView.isHidden = true
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            super.updateViewConstraints()
            if self.usernameTF.text == ""{
                self.isUsernameAvailable =  false
                self.usernameAvailableStatus.text = ""
            }
        }
    }
    
    
    @objc func updatedProfile(_ notify:NSNotification){
        let isUpdated = notify.object as? Bool
        if isUpdated == true{
            self.removeAnimate()
        }
    }
    
    @objc func notifyBackground(_ notify:NSNotification){
        let isUpdated = notify.object as? Bool
        if isUpdated == true{
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func camera(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
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
    
    @IBAction func specialist_dropDown(_ sender: UIButton) {
        if  specialist_UpDown.tag == 0{
            specialist_UpDown.tag = 1
            upDown_Icon.image = #imageLiteral(resourceName: "ArrowDownIcon")
            self.options_Tableview.layoutIfNeeded()
            options_View_Height.constant = options_Tableview.contentSize.height
        }else{
            specialist_UpDown.tag = 0
            upDown_Icon.image = #imageLiteral(resourceName: "ArrowUpIcon")
            options_View_Height.constant = 0.0
        }
    }
    
    @IBAction func hide_Show_Password(_ sender: UIButton) {
        
        if  hide_Show_Password.tag == 0{
            hide_Show_Password.tag = 1
            password_Icon.image = #imageLiteral(resourceName: "ShowPassIcon")
            passwordTF.isSecureTextEntry = false
        }else{
            hide_Show_Password.tag = 0
            password_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
            passwordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func hide_Show_ConfirmPassword(_ sender: UIButton) {
        
        if  hide_Show_ConfirmPassword.tag == 0{
            hide_Show_ConfirmPassword.tag = 1
            confirm_Icon.image = #imageLiteral(resourceName: "ShowPassIcon")
            confirmPasswordTF.isSecureTextEntry = false
        }else{
            hide_Show_ConfirmPassword.tag = 0
            confirm_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
            confirmPasswordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        DataSaver.dataSaverManager.deleteData(key: "selectedLoc")
        DataSaver.dataSaverManager.saveData(key: "selectedLoc", data: userInfo?.data?.location ?? "")
        NotificationCenter.default.post(name:NSNotification.Name(Constants.populateProfileDataForEdit), object:true)
        removeAnimate()
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let emailString = emailTF.text?.trimmed() ?? ""
        let firstNameString = firstNameTF.text?.trimmed() ?? ""
        let lastNameString = lastNameTF.text?.trimmed() ?? ""
        //let optionString = specialist_Options.text?.trimmed() ?? ""
        let optionString = choicedOptions.text?.trimmed() ?? ""
        
        if isUsernameAvailable == true{
            do {
                //let signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: "12345678", confirmPassword: "12345678")
                
                let signUpData: Trainer_SignUpData
                
                if emailString.isEmpty{
                    signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, options: optionString, password: "12345678")
                }else{
                    signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: "12345678")
                }
                
                let refreshAlert = UIAlertController(title: "DBA Fitness", message: "Please do not close or minimize your app until the upload is complete", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                    self.updateProfile(firstname:signUpData.firstName, lastname:signUpData.lastName, type:Constants.selectedRoleType, location:self.locationTF.text ?? "", image:self.photoURL, specialist:self.choicedOptions.text ?? "",email:emailString, username:self.usernameTF.text ?? "")
                    // self.specialist_Options.text
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
                
                
                //updateProfile(firstname:signUpData.firstName, lastname:signUpData.lastName, type:Constants.selectedRoleType, location:locationTF.text ?? "", image:photoURL, specialist:specialist_Options.text ?? "",email:emailString)
            } catch let error as ValidationError {
                UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
            } catch {
            }
        }else{
            UniversalMethod.universalManager.alertMessage("The user name cannot be blank and should be unique.", self.navigationController)
        }
    }
    
    @IBAction func search_Location(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Search_Locations", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
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

extension Edit_Trainer_Profile: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category_options.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Category_Cell", for: indexPath) as? Category_Cell {
            cell.category_Name.text = category_options[indexPath.row]

            if selectedCategory[indexPath.row] == true{
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
        
        if selectedCategory.count == 0{
            selectedCategory[indexPath.row] = true
            //specialisationListArray1.append(category_options1[indexPath.row])
            specialisationListArray.append(category_options[indexPath.row])
        }else{
            if selectedCategory.keys.contains(indexPath.row){
                let val = selectedCategory[indexPath.row]
                
                if val == true{
                    selectedCategory.updateValue(false, forKey: indexPath.row)
                    
                    if let valueIndex = specialisationListArray.firstIndex(of: category_options[indexPath.row]) {
                        specialisationListArray.remove(at: valueIndex)
                    }
                }else{
//                    if specialisationListArray.count > 3{
//                        UniversalMethod.universalManager.alertWithoutController("You can choose maximum 4 interests")
//                    }else{
                        selectedCategory.updateValue(true, forKey: indexPath.row)
                        //specialisationListArray1.append(category_options1[indexPath.row])
                        specialisationListArray.append(category_options[indexPath.row])
                   // }
                }
            }else{
//                if specialisationListArray.count > 3{
//                    UniversalMethod.universalManager.alertWithoutController("You can choose maximum 4 interests")
//                }else{
                    selectedCategory[indexPath.row] = true
                    //specialisationListArray1.append(category_options1[indexPath.row])
                    specialisationListArray.append(category_options[indexPath.row])
                //}
            }
        }
        
        let stringRepresentation = specialisationListArray.joined(separator: ", ")
        //specialist_Options.text = stringRepresentation
        //newArray = specialisationListArray1
        self.choicedOptions.text = stringRepresentation
        
        if choicedOptions.text == ""{
            self.specialist_Options.isHidden = false
        }else{
            self.specialist_Options.isHidden = true
        }
        
        

        
        
        options_Tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
}

extension Edit_Trainer_Profile: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark: Helper/Calling Function
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            imagePickers.mediaTypes = ["public.image"]
            imagePickers.allowsEditing = false
            self.present(imagePickers, animated: true, completion: nil)
        }else    {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePickers.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickers.mediaTypes = ["public.image"]
        imagePickers.allowsEditing = false
        self.present(imagePickers, animated: true, completion: nil)
    }
    
    //MARK: - CameraPicker delegate
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"

        var mediaContentImage: UIImage?

        if let imageEdited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            mediaContentImage = imageEdited
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mediaContentImage = image
        }else{
            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
        }

        guard let image = mediaContentImage else { return }

        //data = image.pngData()
        uploaded_Image.image = image
        uploaded_Image.setRoundImage()
        reducedUploadingImage = image.compressedImages()
        photoURL = Edit_Trainer_Profile.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
        self.dismiss(animated: true, completion: nil);
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

extension Edit_Trainer_Profile: UITextFieldDelegate{
    @objc func textIsChanging(_ textField:UITextField){
        DispatchQueue.main.async {
            self.searchedString = textField.text ?? ""
            if self.searchedString != ""{
                self.verifyIsUsernameAvailableOrNot(parameters:["username" :self.searchedString])
            }else{
                self.isUsernameAvailable = false
                self.usernameAvailableStatus.text = ""
                self.usernameAvailableStatus.textColor = .clear
            }
        }
    }
}


extension Edit_Trainer_Profile{
    func verifyIsUsernameAvailableOrNot(parameters:[String :Any]){
        if Connectivity.isConnectedToInternet {
            apimethod.commonMethod(url: ApiURLs.check_username, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                DispatchQueue.main.async {
                    if success, let result = response as? HTTPURLResponse{
                        let resp = try? JSONDecoder().decode(CheckUsernameResponse.self, from: responseData)
                        
                        if(result.statusCode==404||result.statusCode==400||result.statusCode == 401){
                            if result.statusCode == 401{
                                logoutFromAPP()
                            }else{
                                self.usernameAvailableStatus.text = resp?.message
                                self.usernameAvailableStatus.textColor = UIColor(named: "Training_Type")
                                self.isUsernameAvailable = false
                            }
                        }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                            self.usernameAvailableStatus.text = "Username available"
                            self.usernameAvailableStatus.textColor = UIColor(named: "yellowColor")
                            self.isUsernameAvailable = true
                        }else if(result.statusCode==500){
                            UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                        }
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}
