
import UIKit
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import SDWebImage


class Client_SignUp: UIViewController {
    
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
    @IBOutlet weak var hide_Show_Password: UIButton!
    @IBOutlet weak var hide_Show_ConfirmPassword: UIButton!
    @IBOutlet weak var password_Icon: UIImageView!
    @IBOutlet weak var confirm_Icon: UIImageView!
    @IBOutlet weak var nextButton: GradientButton!
    
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var files = [String]()
    var clientInfo = [String:Any]()
    var goalsArray = [String]()
    var photoURL:URL?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        emailTF.placeholderColor(color: UIColor.white)
        passwordTF.placeholderColor(color: UIColor.white)
        confirmPasswordTF.placeholderColor(color: UIColor.white)
        
        firstNameTF.placeholderColor(color: UIColor.white)
        lastNameTF.placeholderColor(color: UIColor.white)
        locationTF.placeholderColor(color: UIColor.white)
        
        hide_Show_Password.tag = 0
        password_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
        hide_Show_ConfirmPassword.tag = 0
        confirm_Icon.image = #imageLiteral(resourceName: "HidePassIcon")
        upload_View.setViewCircle()
        upload_View.viewUpdatedShadow(red: 45/255, green: 38/255, blue: 63/255, alpha: 1.0)
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        uploaded_Image.setRoundImage()
        uploaded_Image.image = #imageLiteral(resourceName: "emptyUser")
        imagePickers.delegate = self
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        emailTF.text = DataSaver.dataSaverManager.fetchData(key: "email") as? String
        
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
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            super.updateViewConstraints()
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
       // let confirmPasswordString = confirmPasswordTF.text?.trimmed() ?? ""
        let firstNameString = firstNameTF.text?.trimmed() ?? ""
        let lastNameString = lastNameTF.text?.trimmed() ?? ""
        let optionString = "A"
        
        do {
            //let signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: passwordString, confirmPassword: confirmPasswordString)
            
            let signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: passwordString)
            
            if photoURL != nil{
                if let photoURL {
                    csecondSignUp(firstname:signUpData.firstName, lastname:signUpData.lastName, type:Constants.selectedRoleType, location:locationTF.text ?? "", image:photoURL, specialist: "", password: signUpData.password, username: "")
                }

            }else{
                UniversalMethod.universalManager.alertMessage("A picture of the client is required.", self.navigationController)
            }
            
            
        } catch let error as ValidationError {
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
        } catch {
        }
        
        
    }
    
    @IBAction func search_Location(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Search_Locations", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    //MARK: Helper's Method
}

extension Client_SignUp : UITextFieldDelegate{ }

extension Client_SignUp: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        photoURL = Client_SignUp.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)

        //photoURL = Client_SignUp.saveImageInDocumentDirectory(image: image, fileName: "aa.jpg")
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
