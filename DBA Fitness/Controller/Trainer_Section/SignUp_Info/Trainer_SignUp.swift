
import UIKit
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import SDWebImage
import Lottie

class Trainer_SignUp: UIViewController {
    
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
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameAvailableStatus: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailViewTop: NSLayoutConstraint!
    @IBOutlet weak var emailIconWidth: NSLayoutConstraint!
    @IBOutlet weak var emailTFHeight: NSLayoutConstraint!
    @IBOutlet weak var underlineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var underlineView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordViewTop: NSLayoutConstraint!
    @IBOutlet weak var passwordIconWidth: NSLayoutConstraint!
    @IBOutlet weak var passwordTFHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordEyeIconWidth: NSLayoutConstraint!
    @IBOutlet weak var passwordUnderlineHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordUnderlineView: UIView!
    
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var category_options = ["Bodybuilding", "Strongman", "Powerlifting", "Olympic Lifting", "CrossFit", "Pilates","Yoga", "Calisthenics", "Athletics", "WeightLoss", "Rehab & Recovery", "Other"]
    var category_options1 = ["bodybuilding", "strongman", "powerlifting", "olympicLifting", "crossFit", "pilates", "yoga", "сalisthenics", "athletics", "weightLoss", "rehabandRecovery", "other"]
    
    var photoURL:URL?
    var selectedCategory = [Int:Bool]()
    
    
    var files = [String]()
    var trainerInfo = [String:Any]()
    var specialisationListArray = [String]()
    var specialisationListArray1 = [String]()
    var newArray:[String]?
    
    var signUpData : Trainer_SignUpData?
    
    var signUpType:SignUpType?
    
    var isUsernameAvailable = false
    var searchedString = String()
    
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameTF.delegate = self
        usernameTF.addDoneButtonOnKeyboard()
        usernameTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
        firstNameTF.delegate = self
        firstNameTF.addDoneButtonOnKeyboard()
        lastNameTF.delegate = self
        lastNameTF.addDoneButtonOnKeyboard()
        emailTF.delegate = self
        emailTF.addDoneButtonOnKeyboard()
        passwordTF.delegate = self
        passwordTF.addDoneButtonOnKeyboard()
        confirmPasswordTF.delegate = self
        confirmPasswordTF.addDoneButtonOnKeyboard()
        
        usernameTF.placeholderColor(color: UIColor.white)
        emailTF.placeholderColor(color: UIColor.white)
        passwordTF.placeholderColor(color: UIColor.white)
        confirmPasswordTF.placeholderColor(color: UIColor.white)
        firstNameTF.placeholderColor(color: UIColor.white)
        lastNameTF.placeholderColor(color: UIColor.white)
        locationTF.placeholderColor(color: UIColor.white)
        specialist_Options.placeholderColor(color: UIColor.white)
        
        hide_Show_Password.tag = 0
        password_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
        hide_Show_ConfirmPassword.tag = 0
        confirm_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
        specialist_UpDown.tag = 0
        upDown_Icon.image = #imageLiteral(resourceName: "ArrowUpIcon")
        options_View_Height.constant = 0.0
        upload_View.setViewCircle()
        
        upload_View.viewUpdatedShadow(red: 45/255, green: 38/255, blue: 63/255, alpha: 1.0)
        
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        uploaded_Image.setRoundImage()
        uploaded_Image.image = #imageLiteral(resourceName: "emptyUser")
        
        options_Tableview.delegate = self
        options_Tableview.dataSource = self
        options_Tableview.register(UINib(nibName: "Category_Cell", bundle: nil), forCellReuseIdentifier: "Category_Cell")
        
        imagePickers.delegate = self
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        emailTF.text = DataSaver.dataSaverManager.fetchData(key: "email") as? String
        
        firstNameTF.modifyClearButtonWithImage()
        lastNameTF.modifyClearButtonWithImage()
        usernameTF.modifyClearButtonWithImage()
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
        
        let isAppleLogin = DataSaver.dataSaverManager.fetchData(key: "is_apple") as? String
        
        if isAppleLogin != "" || isAppleLogin != "0"{
            
            if isAppleLogin == "1"{
                emailView.isHidden = true
                emailViewTop.constant = 0.0
                emailIconWidth.constant = 0.0
                emailTFHeight.constant = 0.0
                underlineViewHeight.constant = 0.0
                underlineView.isHidden = true
                
                passwordView.isHidden = true
                passwordViewTop.constant = 0.0
                passwordIconWidth.constant = 0.0
                passwordTFHeight.constant = 0.0
                passwordEyeIconWidth.constant = 0.0
                passwordUnderlineHeight.constant = 0.0
                passwordUnderlineView.isHidden = true
                
                signUpType = .appleSignUp
                
            }else if isAppleLogin == "2"{
                
                passwordView.isHidden = true
                passwordViewTop.constant = 0.0
                passwordIconWidth.constant = 0.0
                passwordTFHeight.constant = 0.0
                passwordEyeIconWidth.constant = 0.0
                passwordUnderlineHeight.constant = 0.0
                passwordUnderlineView.isHidden = true
                
                signUpType = .facebookSignUp
            }
            
        }else{
            signUpType = .normalSignUp
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
    
    @IBAction func next(_ sender: UIButton) {
        
        let emailString = emailTF.text?.trimmed() ?? ""
        let passwordString = passwordTF.text?.trimmed() ?? ""
        //let confirmPasswordString = confirmPasswordTF.text?.trimmed() ?? ""
        let firstNameString = firstNameTF.text?.trimmed() ?? ""
        let lastNameString = lastNameTF.text?.trimmed() ?? ""
        let optionString = specialist_Options.text?.trimmed() ?? ""
        
        if isUsernameAvailable == true{
            do {
                /* let signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: passwordString, confirmPassword: confirmPasswordString)*/
                
                if signUpType == .appleSignUp{
                    signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, options: optionString)
                    callSecondSignUpAPI(signUpData)
                }else if signUpType == .facebookSignUp{
                    signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString)
                    callSecondSignUpAPI(signUpData)
                }else{
                    signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: passwordString)
                    callSecondSignUpAPI(signUpData)
                }
                
                //let signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: passwordString)
                
            } catch let error as ValidationError {
                UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
            } catch {
            }
        }else{
            UniversalMethod.universalManager.alertMessage("The user name cannot be blank and should be unique.", self.navigationController)
        }
    }
    
    func callSecondSignUpAPI(_ signUpData:Trainer_SignUpData? = nil){
        if photoURL != nil {
            guard let photoURL else { return }
            csecondSignUp(firstname:signUpData?.firstName ?? "",
                          lastname:signUpData?.lastName ?? "",
                          type:Constants.selectedRoleType,
                          location:locationTF.text ?? "",
                          image:photoURL,
                          specialist:specialist_Options.text ?? "",
                          password:signUpData?.password ?? "",
                          username: usernameTF.text ?? "")
        }else{
            if Constants.selectedRoleType == "1"{
                UniversalMethod.universalManager.alertMessage("A picture of the trainer is required.", self.navigationController)
            }else{
                UniversalMethod.universalManager.alertMessage("A picture of the client is required.", self.navigationController)
            }
        }
    }
    
    @IBAction func search_Location(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Search_Locations", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    
    //MARK: Helper's Method
}

extension Trainer_SignUp: UITableViewDelegate, UITableViewDataSource{
    
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
            specialisationListArray1.append(category_options1[indexPath.row])
            specialisationListArray.append(category_options[indexPath.row])
        }else{
            
            if selectedCategory.keys.contains(indexPath.row){
                let val = selectedCategory[indexPath.row]
                if val == true{
                    selectedCategory.updateValue(false, forKey: indexPath.row)
                    
                    if let valueIndex = specialisationListArray.firstIndex(of: category_options[indexPath.row]) {
                        specialisationListArray.remove(at: valueIndex)
                    }
                    
                    
                    if let valueIndex1 = specialisationListArray1.firstIndex(of: category_options1[indexPath.row]) {
                        specialisationListArray1.remove(at: valueIndex1)
                    }
                    
                    
                }else{
//                    if specialisationListArray.count > 3{
//                        UniversalMethod.universalManager.alertWithoutController("You can choose maximum 4 interests")
//                    }else{
                        selectedCategory.updateValue(true, forKey: indexPath.row)
                        specialisationListArray1.append(category_options1[indexPath.row])
                        specialisationListArray.append(category_options[indexPath.row])
                    //}
                }
            }else{
//                if specialisationListArray.count > 3{
//                    UniversalMethod.universalManager.alertWithoutController("You can choose maximum 4 interests")
//                }else{
                    selectedCategory[indexPath.row] = true
                    specialisationListArray1.append(category_options1[indexPath.row])
                    specialisationListArray.append(category_options[indexPath.row])
              //  }
            }
        }
        
        let stringRepresentation = specialisationListArray.joined(separator: ", ")
        specialist_Options.text = stringRepresentation
        newArray = specialisationListArray1
        options_Tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
}

extension Trainer_SignUp: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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

        data = image.pngData()
        uploaded_Image.image = image
        uploaded_Image.setRoundImage()
        reducedUploadingImage = image.compressedImages()
        photoURL = Trainer_SignUp.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
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

extension Trainer_SignUp: UITextFieldDelegate{
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

extension Trainer_SignUp{
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
