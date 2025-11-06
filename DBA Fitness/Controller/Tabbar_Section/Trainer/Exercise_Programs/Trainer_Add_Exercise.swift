
import UIKit
import AVFoundation
import SDWebImage

class Trainer_Add_Exercise: UIViewController, UITextFieldDelegate {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var thumbnail_Image: UIImageView!
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var thumbnail_View: GradientView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var exercise_Name: UITextField!
    @IBOutlet weak var about_TV: UITextView!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var exerciseNameTV: UITextView!
    @IBOutlet weak var aboutSetsRepsTime: UITextView!
    
    @IBOutlet weak var setsTF: UITextField!
    @IBOutlet weak var repsTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    
    var name = String()
    var desc = String()
    var exercise_info = String()
    var photosID = [Int]()
    var trainerID = Int()
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var photosArray = [URL]()
    var photoURL:URL?
    var videoURL:URL?
    var userRole = ""
    var thumbnil:URL?
    var training_id = String()
    var program_id = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //exercise_Name.placeholderColor(color: UIColor.white)
        
        setsTF.placeholderColor(color: UIColor.white)
        repsTF.placeholderColor(color: UIColor.white)
        timeTF.placeholderColor(color: UIColor.white)
        
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        thumbnail_View.layer.cornerRadius = 4.0
        thumbnail_Image.layer.cornerRadius = 4.0
        
        if name != ""{
            //exercise_Name.text = name
            exerciseNameTV.text = name
        }else{
            exerciseNameTV.text = "Exercise Name"
            exerciseNameTV.textColor = UIColor.lightGray
        }
        
        if desc != ""{
            about_TV.text = desc
        }else{
            about_TV.text = "Write About Exercise"
            about_TV.textColor = UIColor.lightGray
        }
        
        if exercise_info != ""{
            //aboutSetsRepsTime.text = exercise_info
        }else{
            aboutSetsRepsTime.text = "Write about exercise's Sets/Reps/Time"
            aboutSetsRepsTime.textColor = UIColor.lightGray
        }
        
        imagePickers.delegate = self
        photosArray.removeAll()
        
        //exercise_Name.delegate = self
        about_TV.delegate = self
        about_TV.addDoneButtonOnKeyboard()
        
        aboutSetsRepsTime.delegate = self
        aboutSetsRepsTime.addDoneButtonOnKeyboard()
        
        exerciseNameTV.delegate = self
        exerciseNameTV.addDoneButtonOnKeyboard()
        
        
        //exercise_Name.addDoneButtonOnKeyboard()
        // totalPhotos.text = "Photos \(photosArray.count)"*/
        
        photos_Collectionview.delegate = self
        photos_Collectionview.dataSource = self
        photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {

        let totalSets = setsTF.text ?? ""
        let totalReps = repsTF.text ?? ""

        //        if totalSets.validateEnteredSetsAndResps() {
        //            if totalReps.validateEnteredSetsAndResps() {
        let desc = about_TV.text.trimmed()
        let name = exerciseNameTV.text.trimmed()
        let aboutSetsRepsTimeInfo = aboutSetsRepsTime.text.trimmed()

        if desc == "" || desc == "Write About Exercise" || name == "" || name == "Exercise Name"{

            /*
             if desc == "" || desc == "Write About Exercise" || name == "" || name == "Exercise Name" || aboutSetsRepsTimeInfo == "" || aboutSetsRepsTimeInfo == "Write about exercise's Sets/Reps/Time"{
             */

            UniversalMethod.universalManager.alertMessage("Exercise Name and Description are Required", self.navigationController)
        }else{
            if training_id != "" && program_id != ""{
                addExercise(excercise_name:name,
                            excercise_description:desc,
                            excercise_image:photosArray,
                            excercise_video:videoURL,
                            excercise_id: "",
                            apiUrl:ApiURLs.add_excercise_training,
                            thumbnil: thumbnil,
                            training_id: training_id,
                            program_id: program_id,
                            exercise_info: aboutSetsRepsTimeInfo,
                            sets: setsTF.text ?? "",
                            reps: repsTF.text ?? "",
                            time: timeTF.text ?? "")
            }else{
                addExercise(excercise_name:name,
                            excercise_description:desc,
                            excercise_image:photosArray,
                            excercise_video:videoURL,
                            excercise_id: "",
                            apiUrl:ApiURLs.add_excercise,
                            thumbnil: thumbnil,
                            training_id: "",
                            program_id: "",
                            exercise_info: aboutSetsRepsTimeInfo,
                            sets: setsTF.text ?? "",
                            reps: repsTF.text ?? "",
                            time: timeTF.text ?? "")
            }
        }

        //customModalPopUp(storyBoard: AppStoryboard.Trainer_Tabbar.instance, controllerIndentifier:"TrainerExerciseCatalogue")
        //            } else {
        //                UniversalMethod.universalManager.alertMessage("Reps value must be a valid number. Ex: 3-5",
        //                                                              self.navigationController)
        //            }
        //        } else {
        //            UniversalMethod.universalManager.alertMessage("Sets value must be a valid number. Ex: 3-5",
        //                                                          self.navigationController)
        //        }
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openVideoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePickers.sourceType = .photoLibrary
            self.imagePickers.allowsEditing = false
            self.imagePickers.mediaTypes = ["public.movie"]
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
    
    @IBAction func gallery_View(_ sender: UIButton) {
        //UniversalMethod.universalManager.pushVC("Trainer_Gallery_View", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
        
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == exercise_Name{
            let maxLength = 50
            let currentString: NSString = (exercise_Name.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    
}

extension Trainer_Add_Exercise: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
            return CGSize(width: 85.0, height: 90.0)
        }else {
            return CGSize(width: 85.0, height: 90.0)
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
            cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.trainer_Photos.sd_setImage(with: photosArray[indexPath.row], placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension Trainer_Add_Exercise: UITextViewDelegate{
    
    //"Write about exercise's Sets/Reps/Time"
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == about_TV{
            if textView.textColor == UIColor.lightGray{
                if about_TV.text == "" || about_TV.text == "Write About Exercise"{
                    textView.text = ""
                }
                textView.textColor = UIColor.white
            }
        }else if textView == exerciseNameTV{
            if textView.textColor == UIColor.lightGray{
                if exerciseNameTV.text == "" || exerciseNameTV.text == "Exercise Name"{
                    textView.text = ""
                }
                textView.textColor = UIColor.white
            }
        }else if textView == aboutSetsRepsTime{
            if textView.textColor == UIColor.lightGray{
                if aboutSetsRepsTime.text == "" || aboutSetsRepsTime.text == "Write about exercise's Sets/Reps/Time"{
                    textView.text = ""
                }
                textView.textColor = UIColor.white
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == about_TV{
            if textView.text == ""  {
                textView.text = "Write About Exercise"
                textView.textColor = UIColor.lightGray
            }
        }else if textView == exerciseNameTV{
            if textView.text == ""  {
                textView.text = "Exercise Name"
                textView.textColor = UIColor.lightGray
            }
        }else if textView == aboutSetsRepsTime{
            if textView.text == ""  {
                textView.text = "Write about exercise's Sets/Reps/Time"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == exerciseNameTV{
            let newText = (exerciseNameTV.text as NSString).replacingCharacters(in: range, with: text)
            return newText.count < 50
        }
        return true
    }
}

extension Trainer_Add_Exercise: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark: Helper/Calling Function
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            self.imagePickers.mediaTypes = ["public.image"]
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
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
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
                let val = photosArray.count

                reducedUploadingImage = image.compressedImages()
                photoURL = Trainer_Add_Exercise.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName:filename)


                //photoURL = Trainer_Add_Exercise.saveImageInDocumentDirectory(image: image, fileName: "\(val)aa.jpg")
                if let photoURL {
                    photosArray.append(photoURL)
                    self.photos_Collectionview.reloadData()

                    if photosArray.count < 2{
                        totalPhotos.text = "Photos \(photosArray.count)"
                    }else{
                        totalPhotos.text = "Photos \(photosArray.count)"
                    }
                }


                self.dismiss(animated: true, completion: nil);
            }
            
            if mediaType == "public.movie" {
                videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                
                guard let videoURL = videoURL else{
                    return
                }
                thumbnail_Image.image = generateThumbnail(url: videoURL)
                reducedUploadingImage = thumbnail_Image.image?.compressedImages()
                thumbnil = Trainer_Add_Exercise.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName:filename)
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

