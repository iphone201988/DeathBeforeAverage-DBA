
import UIKit
import SDWebImage

class Trainer_Add_Achievement: UIViewController, UITextFieldDelegate {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var achievements_View: UIView!
    @IBOutlet weak var trophy_View: UIView!
    @IBOutlet weak var numberOf_Certificate: UILabel!
    @IBOutlet weak var achievement_Year: UITextField!
    @IBOutlet weak var competition_Name: UITextField!
    @IBOutlet weak var juniors_Position: UITextField!
    @IBOutlet weak var weight_Position: UITextField!
    @IBOutlet weak var trophyIcon: UIImageView!
    @IBOutlet weak var certificate_Collectionview: UICollectionView!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var skipButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutAchievement: UITextView!
    
    var photosArray = [URL]()
    var photoURL:URL?
    var imagePickers:UIImagePickerController = UIImagePickerController()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        achievement_Year.placeholderColor(color: UIColor.white)
        competition_Name.placeholderColor(color: UIColor.white)
        //juniors_Position.placeholderColor(color: UIColor.white)
        //weight_Position.placeholderColor(color: UIColor.white)
        
        certificate_Collectionview.delegate = self
        certificate_Collectionview.dataSource = self
        certificate_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        
        achievements_View.layer.cornerRadius = 7.0
        trophy_View.layer.cornerRadius = 4.0
        trophy_View.layer.borderWidth = 1.0
        trophy_View.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        //self.tabBarController?.tabBar.isHidden = true
        
        trophy_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        trophyIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.3, radius: 5.5)
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        imagePickers.delegate = self
        photosArray.removeAll()
        numberOf_Certificate.text = "0 certificate"
        
        achievement_Year.delegate = self
        achievement_Year.addDoneButtonOnKeyboard()
        competition_Name.delegate = self
        competition_Name.addDoneButtonOnKeyboard()
        juniors_Position.delegate = self
        juniors_Position.addDoneButtonOnKeyboard()
        weight_Position.delegate = self
        weight_Position.addDoneButtonOnKeyboard()
        
        aboutAchievement.delegate = self
        aboutAchievement.addDoneButtonOnKeyboard()
        aboutAchievement.text = "Write about achievement"
        aboutAchievement.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        skipButton.isUserInteractionEnabled = false
        skipButton.isHidden = true
        skipButtonHeight.constant = 0.0
        nextButton.setTitle("Submit", for: .normal)
    }
    
    //MARK : IB's Action
    
    @IBAction func next(_ sender: UIButton) {
        if achievement_Year.text != "" && competition_Name.text != "" && aboutAchievement.text != "" && aboutAchievement.text != "Write about achievement"{
            if photosArray.count > 0{
                
                
                let refreshAlert = UIAlertController(title: "DBA Fitness", message: "Please do not close or minimize your app until the upload is complete", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                    self.addAchievement(year:self.achievement_Year.text ?? "", event:self.competition_Name.text ?? "", image:self.photosArray, junior_absolute:self.aboutAchievement.text ?? "", men_up_to_90_kg: self.weight_Position.text ?? "", apiUrl:ApiURLs.add_achievement,achievement_id:"")
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
                
                //addAchievement(year:achievement_Year.text ?? "", event:competition_Name.text ?? "", image:photosArray, junior_absolute:juniors_Position.text ?? "", men_up_to_90_kg: weight_Position.text ?? "", apiUrl:"http://techwinlabs.in/dba/api/add_achievement",achievement_id:"")
            }else{
                UniversalMethod.universalManager.alertMessage("Please upload the certificate", self.navigationController)
            }
        }else{
            UniversalMethod.universalManager.alertMessage("All fields are required", self.navigationController)
            // All fields required except certificate
        }
    }
    
    @IBAction func skip(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func add_Certificate(_ sender: UIButton) {
        //UniversalMethod.universalManager.pushVC("Load_Certificates", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePickers.sourceType = .photoLibrary
            self.imagePickers.mediaTypes = ["public.image"]
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
    //MARK: Helper's Method
    
}

extension Trainer_Add_Achievement: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photosArray.count > 0{
            emptyGallery.isHidden = true
            return photosArray.count
        }else{
            emptyGallery.isHidden = false
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let modelName = UIDevice.modelName
        if (modelName == "iPhone X" || modelName == "iPhone XS" || modelName == "iPhone XS Max" || modelName == "iPhone XR") {
            return CGSize(width: 125.0, height: 130.0)
        }else {
            return CGSize(width: 125.0, height: 130.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Photos_Cell", for: indexPath) as? Trainer_Photos_Cell {
            cell.photos_View_Height.constant = 120.0
            cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.trainer_Photos.sd_setImage(with: photosArray[indexPath.row], placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            cell.deleteIcon.isHidden = false
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(didTapDelete(_ :)), for: .touchUpInside)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = photosArray[indexPath.item]
        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        vc.isShowingLocalImage = true
        vc.localImageURL = photo
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapDelete(_ sender: UIButton) {
        photosArray.remove(at: sender.tag)
        certificate_Collectionview.reloadData()
    }
}

extension Trainer_Add_Achievement: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    //MARK: - CameraPicker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaType  == "public.image" {

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
                _ = photosArray.count
                let timestamp = NSDate().timeIntervalSince1970
                let stringStamp = "\(timestamp)"
                let arrayStamp = stringStamp.split(separator: ".")
                
                reducedUploadingImage = image.compressedImages()
                
                photoURL = Trainer_Add_Achievement.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: "\(arrayStamp[1])aa.jpg")
                if let photoURL {
                    photosArray.append(photoURL)
                    self.certificate_Collectionview.reloadData()
                    
                    if photosArray.count < 2{
                        numberOf_Certificate.text = "\(photosArray.count) certificate"
                    }else{
                        numberOf_Certificate.text = "\(photosArray.count) certificates"
                    }
                }

                
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

extension Trainer_Add_Achievement: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about achievement"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
