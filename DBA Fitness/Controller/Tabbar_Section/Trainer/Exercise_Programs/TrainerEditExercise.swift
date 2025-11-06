
import UIKit
import SDWebImage

class TrainerEditExercise: UIViewController, UITextFieldDelegate {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var thumbnail_Image: UIImageView!
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var thumbnail_View: GradientView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var exercise_Name: UITextField!
    @IBOutlet weak var about_TV: UITextView!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var camerIcon: UIImageView!
    @IBOutlet weak var exerciseNameTV: UITextView!
    @IBOutlet weak var aboutSetsRepsTime: UITextView!
    
    @IBOutlet weak var setsTF: UITextField!
    @IBOutlet weak var repsTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    
    //Name Exercise
    
    var name = String()
    var desc = String()
    var exercise_info = String()
    var photosID = [Int]()
    var trainerID = Int()
    var videoURL:URL?
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var photosArray = [URL]()
    var photoURL:URL?
    var userRole = ""
    var selecdtedIndex = Int()
    var thumbnil:URL?
    var training_id = String()
    var program_id = String()
    var databaseTblID: String = ""
    
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
        about_TV.delegate = self
        about_TV.addDoneButtonOnKeyboard()
        
        exerciseNameTV.delegate = self
        exerciseNameTV.addDoneButtonOnKeyboard()
        
        //exercise_Name.delegate = self
        //exercise_Name.addDoneButtonOnKeyboard()
        imagePickers.delegate = self
        //photosArray.removeAll()
        
        if let photo = particularExercise?.thumbnil{
            if photo != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                thumbnail_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                thumbnail_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)
            }else{
                thumbnail_Image.image = #imageLiteral(resourceName: "workoutSampleImage")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //exercise_Name.text = particularExercise?.excerciseName
        about_TV.text = particularExercise?.excerciseDescription
        if about_TV.text == ""{
            about_TV.text = "Write About Exercise"
            about_TV.textColor = UIColor.lightGray
        }
        
        if particularExercise?.excerciseName != ""{
            exerciseNameTV.text = particularExercise?.excerciseName
        }else{
            exerciseNameTV.text = "Exercise Name"
            exerciseNameTV.textColor = UIColor.lightGray
        }
        
        if particularExercise?.exercise_info != ""{
            //aboutSetsRepsTime.text = particularExercise?.exercise_info
        }else{
            aboutSetsRepsTime.text = "Write about exercise's Sets/Reps/Time"
            aboutSetsRepsTime.textColor = UIColor.lightGray
        }
        
        setsTF.text = particularExercise?.sets ?? ""
        repsTF.text = particularExercise?.reps ?? ""
        timeTF.text = particularExercise?.time ?? ""
        
        aboutSetsRepsTime.delegate = self
        aboutSetsRepsTime.addDoneButtonOnKeyboard()
        
        /*  if particularExercise?.excerciseImage?.count ?? 0 < 2{
         totalPhotos.text = "Photos \(particularExercise?.excerciseImage?.count ?? 0)"
         }else{
         totalPhotos.text = "Photos \(particularExercise?.excerciseImage?.count ?? 0)"
         }*/
        
        
        let certificateCount = particularExercise?.excerciseImage?.count
        
        photosArray.removeAll()
        
        if let excerciseImages = particularExercise?.excerciseImage{
            _ = excerciseImages.map({ imageURL in
                let completePicUrl = URL(string: "\(ApiURLs.GET_MEDIA_BASE_URL)\(imageURL)")
                if let picURL = completePicUrl{
                    photosArray.append(picURL)
                }
            })
        }
        
        if photosArray.count > 0{
            if photosArray.count < 2{
                totalPhotos.text = "Photos \(photosArray.count)"
            }else{
                totalPhotos.text = "Photos \(photosArray.count)"
            }
        }else{
            totalPhotos.text = ""
            camerIcon.isHidden = true
        }
        
        /*
         if certificateCount ?? 0 > 0{
         let firstIndex = particularExercise?.excerciseImage?.first
         if firstIndex == ""{
         totalPhotos.text = ""
         camerIcon.isHidden = true
         }else{
         if certificateCount ?? 0 < 2{
         totalPhotos.text = "Photos \(particularExercise?.excerciseImage?.count ?? 0)"
         }else{
         totalPhotos.text = "Photos \(particularExercise?.excerciseImage?.count ?? 0)"
         }
         }
         }else{
         totalPhotos.text = ""
         camerIcon.isHidden = true
         }
         */
        
        
        photos_Collectionview.delegate = self
        photos_Collectionview.dataSource = self
        photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        photos_Collectionview.reloadData()
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        let totalSets = setsTF.text ?? ""
        let totalReps = repsTF.text ?? ""
        // if totalSets.validateEnteredSetsAndResps() {
        //  if totalReps.validateEnteredSetsAndResps() {
        let desc = about_TV.text.trimmed()
        let name = exerciseNameTV.text.trimmed()
        let aboutSetsRepsTimeInfo = aboutSetsRepsTime.text.trimmed()

        if desc == "" || desc == "Write About Exercise" || name == "" || name == "Exercise Name"{

            /*
             || aboutSetsRepsTimeInfo == "" || aboutSetsRepsTimeInfo == "Write about exercise's Sets/Reps/Time"
             */

            UniversalMethod.universalManager.alertMessage("Exercise Name and Description are Required", self.navigationController)
        }else{

            if let excerciseImages = particularExercise?.excerciseImage{
                _ = excerciseImages.map({ imageURL in
                    let completePicUrl = URL(string: "\(ApiURLs.GET_MEDIA_BASE_URL)\(imageURL)")
                    if let picURL = completePicUrl{
                        if photosArray.contains(picURL){
                            let indexVal = photosArray.firstIndex(of: picURL)
                            if let index = indexVal{
                                photosArray.remove(at: index)
                            }
                        }
                    }
                })
            }

            addExercise(excercise_name:name,
                        excercise_description:desc,
                        excercise_image:photosArray,
                        excercise_video:videoURL,
                        excercise_id: particularExercise?.id ?? "0",
                        apiUrl:ApiURLs.update_excercise,
                        thumbnil: thumbnil,
                        training_id: training_id,
                        program_id: program_id,
                        exercise_info: aboutSetsRepsTimeInfo,
                        sets: setsTF.text ?? "",
                        reps: repsTF.text ?? "",
                        time: timeTF.text ?? "",
                        type: databaseTblID)
        }
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
    
    
    //    @IBAction func gallery_View(_ sender: UIButton) {
    //        /*  let storyboard = AppStoryboard.Gallery_Section.instance
    //         let loginScene = storyboard.instantiateViewController(withIdentifier: "TrainerEditGallery") as! TrainerEditGallery
    //         self.navigationController?.pushViewController(loginScene, animated: true)*/
    //
    //        //UniversalMethod.universalManager.pushVC("TrainerEditGallery", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
    //    }
    
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
            let maxLength = 15
            let currentString: NSString = (exercise_Name.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
}

extension TrainerEditExercise: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /*  guard let count = particularExercise?.excerciseImage?.count else{
         emptyGallery.isHidden = false
         return 0
         }
         
         if count > 0{
         emptyGallery.isHidden = true
         }else{
         emptyGallery.isHidden = false
         }
         
         return count*/
        
        emptyGallery.isHidden = true
        
        /*   guard var count = particularExercise?.excerciseImage?.count else{
         //emptyGallery.isHidden = false
         return 0
         }
         if count > 0{
         let firstIndex = particularExercise?.excerciseImage?.first
         if firstIndex == ""{
         count = 0
         //emptyGallery.isHidden = false
         }else{
         //emptyGallery.isHidden = true
         }
         }else{
         //emptyGallery.isHidden = false
         }

         return count*/
        
        
        if photosArray.count > 0{
            //emptyGallery.isHidden = true
            return photosArray.count
        }else{
            //emptyGallery.isHidden = false
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
        /*  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Photos_Cell", for: indexPath) as! Trainer_Photos_Cell
         if let photo = particularExercise?.excerciseImage?[indexPath.row]{
         if photo != ""{
         let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
         cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
         cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
         }else{
         cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
         }
         }
         return cell
         */
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Photos_Cell", for: indexPath) as? Trainer_Photos_Cell {
            cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.trainer_Photos.sd_setImage(with: photosArray[indexPath.row],
                                            placeholderImage: #imageLiteral(resourceName: "user"),
                                            options: .highPriority)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension TrainerEditExercise: UITextViewDelegate{
    
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

extension TrainerEditExercise: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: - CameraPicker delegate
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.movie" {
                videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                guard let videoURL = videoURL else{
                    return
                }
                thumbnail_Image.image = generateThumbnail(url: videoURL)
                reducedUploadingImage = thumbnail_Image.image?.compressedImages()
                thumbnil = TrainerEditExercise.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName:filename)
                self.dismiss(animated: true, completion: nil);
            }
            
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
                photoURL = TrainerEditExercise.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName:filename)


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
