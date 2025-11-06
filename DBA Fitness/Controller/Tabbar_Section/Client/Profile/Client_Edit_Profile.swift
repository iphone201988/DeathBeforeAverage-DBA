
import UIKit
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import SDWebImage

class Client_Edit_Profile: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var upload_View: UIView!
    @IBOutlet weak var uploaded_Image: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var files = [String]()
    var clientInfo = [String:Any]()
    var goalsArray = [String]()
    var photoURL:URL?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showAnimate()
        
        firstNameTF.delegate = self
        firstNameTF.addDoneButtonOnKeyboard()
        
        lastNameTF.delegate = self
        lastNameTF.addDoneButtonOnKeyboard()
        
        emailTF.delegate = self
        emailTF.addDoneButtonOnKeyboard()
        emailTF.placeholderColor(color: UIColor.white)
        firstNameTF.placeholderColor(color: UIColor.white)
        lastNameTF.placeholderColor(color: UIColor.white)
        locationTF.placeholderColor(color: UIColor.white)
        upload_View.setViewCircle()
        upload_View.viewUpdatedShadow(red: 45/255, green: 38/255, blue: 63/255, alpha: 1.0)
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        uploaded_Image.setRoundImage()
        imagePickers.delegate = self
        
        /* self.firstNameTF.text = loginInfo?.firstName
         self.lastNameTF.text = loginInfo?.lastName
         self.emailTF.text = loginInfo?.email
         self.locationTF.text = loginInfo?.place*/
        
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            super.updateViewConstraints()
        }
    }
    
    //MARK : IB's Action
    
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
    
    @IBAction func cancel(_ sender: UIButton) {
        removeAnimate()
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let emailString = emailTF.text?.trimmed() ?? ""
        let passwordString = "12345678"
        //let confirmPasswordString = "12345678"
        let firstNameString = firstNameTF.text?.trimmed() ?? ""
        let lastNameString = lastNameTF.text?.trimmed() ?? ""
        let optionString = "A"
        
        do {
            //let signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: passwordString, confirmPassword: confirmPasswordString)
            
            let signUpData = try Trainer_SignUpData(with: firstNameString, lastName: lastNameString, email: emailString, options: optionString, password: passwordString)
            
            /*  clientInfo["goals"] = goalsArray
             p_ClientSignUp["lastName"] = signUpData.lastName
             p_ClientSignUp["firstName"] = signUpData.firstName
             p_ClientSignUp["files"] = files
             p_ClientSignUp["clientInfo"] = clientInfo
             
             let photoDetails = uploadedInfo?.uploaded?.first
             if let photoID = photoDetails?.id{
             if photoID > 0{
             p_ClientSignUp["photo"] = photoID
             }
             }
             clientSignUp(parameters:p_ClientSignUp)*/
            
        } catch let error as ValidationError {
            UniversalMethod.universalManager.custom_ActionSheet(vc: self, message:error.message)
        } catch {
        }
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

extension Client_Edit_Profile : UITextFieldDelegate{ }



extension Client_Edit_Profile: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        photoURL = Client_Edit_Profile.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
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
