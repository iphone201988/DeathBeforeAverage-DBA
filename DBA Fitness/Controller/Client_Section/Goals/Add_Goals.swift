import UIKit
import SDWebImage

class Add_Goals: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    @IBOutlet weak var goals_TV: UITextView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var interface_Title: UILabel!
    
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var picsUploadBtn: UIButton!
    
    var status_Title = String()
    var top_Title = String()
    var saveGoals = [String]()
    let defaults = UserDefaults.standard
    
    var photosArray = [URL]()
    var imageArray = [URL]()
    var videosArray = [URL]()
    var videoThumbnailArray = [URL]()
    var photoURL:URL?
    var imagePickers: UIImagePickerController = UIImagePickerController()
    var videoURL:URL?
    var thumbnil:URL?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showAnimate()
        status.text = status_Title
        interface_Title.text = top_Title
        goals_TV.delegate = self
        goals_TV.addDoneButtonOnKeyboard()
        goals_TV.text = "Write about Goal"
        goals_TV.textColor = UIColor.lightGray
        mainView.customView(borderWidth:0.0, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        secondaryView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(isAddGoals(_:)), name: NSNotification.Name(rawValue: Constants.addGoals), object: nil)
        
        imagePickers.delegate = self

        
        photos_Collectionview.delegate = self
        photos_Collectionview.dataSource = self
        photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        
        
        photosArray.removeAll()
        imageArray.removeAll()
        videosArray.removeAll()
        videoThumbnailArray.removeAll()
        totalPhotos.text = "Photos 0"
        
        if Constants.isEditGoal == "1" || Constants.isEditGoal == "2"{
            
            //            photosArray.removeAll()
            //            imageArray.removeAll()
            //            videosArray.removeAll()
            //            videoThumbnailArray.removeAll()
            
            goals_TV.text = particularGoalInfo?.goalDescription
            goals_TV.textColor = .white
            
            if let imageArray = particularGoalInfo?.image{
                for imageURL in imageArray{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(imageURL)"
                    if let url = URL(string: completePicUrl) {
                        photosArray.append(url)
                    }
                    
                }
                
                //self.imageArray = photosArray
            }
            
            if let thumbnailArray = particularGoalInfo?.thumbnil{
                for thumbnailURL in thumbnailArray{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(thumbnailURL)"
                    if let url = URL(string: completePicUrl) {
                        photosArray.append(url)
                    }
                    
                }
                
                //self.imageArray = photosArray
            }
            totalPhotos.text = "Photos \(photosArray.count)"
            photos_Collectionview.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEditGoals(_:)),
                                               name: NSNotification.Name(rawValue: Constants.updateEditGoals),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Constants.isEditGoal == "1"{
            
            //            photosArray.removeAll()
            //            imageArray.removeAll()
            //            videosArray.removeAll()
            //            videoThumbnailArray.removeAll()
            //
            //            goals_TV.text = particularGoalInfo?.goalDescription
            //
            //            if let imageArray = particularGoalInfo?.image{
            //                for imageURL in imageArray{
            //                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(imageURL)"
            //                    photosArray.append(URL(string: completePicUrl))
            //                }
            //            }
            //
            //            if let thumbnailArray = particularGoalInfo?.thumbnil{
            //                for thumbnailURL in thumbnailArray{
            //                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(thumbnailURL)"
            //                    photosArray.append(URL(string: completePicUrl))
            //                }
            //            }
            photos_Collectionview.reloadData()
            totalPhotos.text = "Photos \(photosArray.count)"

        }else{
            //            photosArray.removeAll()
            //            imageArray.removeAll()
            //            videosArray.removeAll()
            //            videoThumbnailArray.removeAll()
            //            totalPhotos.text = "Photos 0"
            photos_Collectionview.reloadData()
            totalPhotos.text = "Photos \(photosArray.count)"
        }
        
        if Constants.isEditGoal == "2"{
            saveView.alpha = 0.0
            picsUploadBtn.isUserInteractionEnabled = false
            goals_TV.isUserInteractionEnabled = false
        } else {
            saveView.alpha = 1.0
            picsUploadBtn.isUserInteractionEnabled = true
            goals_TV.isUserInteractionEnabled = true
        }
    }
    
    @objc func isAddGoals(_ notify:NSNotification){
        let isAddGoals = notify.object as? Bool
        if isAddGoals == true{
            self.removeAnimate()
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func cancel(_ sender: UIButton) {
        removeAnimate()
    }
    
    @IBAction func save(_ sender: UIButton) {
        if goals_TV.text != "" && goals_TV.text != "Write about Goal"{
            if Constants.isEditGoal == "1"{
                //                addGoal(parameters:["title":"Goal",
                //                                    "description":goals_TV.text ?? "",
                //                                    "goal_id":particularGoalInfo?.id ?? "0"] )
                
                //                if let goalImages = particularGoalInfo?.image{
                //                    _ = goalImages.map({ imageURL in
                //                        let completePicUrl = URL(string: "\(ApiURLs.GET_MEDIA_BASE_URL)\(imageURL)")
                //                        if let picURL = completePicUrl{
                //                            if photosArray.contains(picURL){
                //                                let indexVal = photosArray.firstIndex(of: picURL)
                //                                if let index = indexVal{
                //                                    photosArray.remove(at: index)
                //                                }
                //                            }
                //                        }
                //                    })
                //                }

// crashes here  Thread 1: Fatal error: Index out of range
//                var imagesArray = photosArray
//                _ = imagesArray.enumerated().map({ index, imgURL in
//                    if imgURL.absoluteString.contains(ApiURLs.GET_MEDIA_BASE_URL) {
//                        imagesArray.remove(at: index)
//                    }
//                })
                
                let imagesArray = photosArray.filter { imgURL in
                    !imgURL.absoluteString.contains(ApiURLs.GET_MEDIA_BASE_URL)
                }
                
                addGoalAPI(description:goals_TV.text ?? "",
                           image: imagesArray,
                           apiUrl:ApiURLs.add_goal,
                           goal_id:particularGoalInfo?.id ?? "0",
                           video:videosArray,
                           thumbnil:videoThumbnailArray,
                           title:"Goal")
                
                
            }else{
                //addGoal(parameters:["title":"Goal", "description":goals_TV.text ?? ""] )
                addGoalAPI(description:goals_TV.text ?? "",
                           image: imageArray,
                           apiUrl:ApiURLs.add_goal,
                           goal_id:"",
                           video:videosArray,
                           thumbnil:videoThumbnailArray, title:"Goal")
            }
        }
        else {
            UniversalMethod.universalManager.alertMessage("Seem goals is empty", self.navigationController)
        }
    }
    
    @IBAction func pics(_ sender: UIButton) {
//        MediaTypePicker.shared.present(from: self, sourceView: view) { [weak self] media in
//            switch media {
//            case .image(let image):
//                break
//                
//            case .video(let url):
//                break
//                
//            case .none:
//                break
//            }
//        }
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePickers.sourceType = .photoLibrary
            self.imagePickers.mediaTypes = ["public.image","public.movie"]
            //self.imagePickers.allowsEditing = false
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
    
    func showAnimate(){
//        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//        self.view.alpha = 0.0;
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.alpha = 1.0
//            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        });
    }
    
    func removeAnimate(){
        navigationController?.popViewController(animated: true)
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.view.alpha = 0.0;
//        }, completion:{(finished : Bool)  in
//            if (finished)
//            {
//                self.view.removeFromSuperview()
//            }
//        });
    }

    @objc func updateEditGoals(_ notify:NSNotification){
        photosArray.removeAll()
        if let imageArray = particularGoalInfo?.image{
            for imageURL in imageArray{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(imageURL)"
                if let url = URL(string: completePicUrl) {
                    photosArray.append(url)
                }
                
            }
        }

        photos_Collectionview.reloadData()
        if photosArray.count < 2{
            totalPhotos.text = "Photos \(photosArray.count)"
        }else{
            totalPhotos.text = "Photos \(photosArray.count)"
        }
    }
}


extension Add_Goals: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            
            if goals_TV.text == "" || goals_TV.text == "Write about Goal"{
                textView.text = ""
            }
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about Goal"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension Add_Goals: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark: Helper/Calling Function
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            //imagePickers.allowsEditing = false
            self.imagePickers.mediaTypes = ["public.image","public.movie"]
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
                photoURL = Client_Edit_Progress.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
                //photoURL = Client_Edit_Progress.saveImageInDocumentDirectory(image: image, fileName: "\(val)aa.jpg")
                if let photoURL {
                    photosArray.append(photoURL)
                    self.photos_Collectionview.reloadData()
                    if photosArray.count < 2{
                        totalPhotos.text = "Photos \(photosArray.count)"
                    }else{
                        totalPhotos.text = "Photos \(photosArray.count)"
                    }
                    imageArray.append(photoURL)
                }

                self.dismiss(animated: true, completion: nil);
            }
            
            if mediaType == "public.movie" {
                videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                guard let videoURL = videoURL else{
                    return
                }
                reducedUploadingImage = generateThumbnail(url: videoURL)?.compressedImages()
                thumbnil = Add_Goals.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName:filename)
                if let thumbnil {
                    photosArray.append(thumbnil)
                    self.photos_Collectionview.reloadData()
                    if photosArray.count < 2{
                        totalPhotos.text = "Photos \(photosArray.count)"
                    }else{
                        totalPhotos.text = "Photos \(photosArray.count)"
                    }
                    videoThumbnailArray.append(thumbnil)
                }
                videosArray.append(videoURL)
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

extension Add_Goals: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
            cell.deleteIcon.isHidden = true
            cell.deleteBtn.isHidden = true
            if Constants.isEditGoal == "0"  || Constants.isEditGoal == "1" {
                cell.deleteIcon.isHidden = false
                cell.deleteBtn.isHidden = false
                cell.deleteBtn.tag = indexPath.item
                cell.deleteBtn.addTarget(self, action: #selector(didTapDelete(_ :)), for: .touchUpInside)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = photosArray[indexPath.row]
        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        vc.isShowingLocalImage = true
        vc.localImageURL = photo
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapDelete(_ sender: UIButton) {
        if Constants.isEditGoal == "1" {
            var imagesArray = photosArray
            imagesArray.remove(at: sender.tag)
            
            var strImagesArray = [String]()
            _ = imagesArray.map { imgURL in
                let newString = imgURL.absoluteString.replacingOccurrences(of: ApiURLs.GET_MEDIA_BASE_URL, with: "")
                strImagesArray.append(newString)
            }
            let strRep = strImagesArray.joined(separator: ",")
            
            
            if goals_TV.text != "" && goals_TV.text != "Write about Goal"{
                addGoalAPI(description: nil,
                           image: nil,
                           apiUrl:ApiURLs.add_goal,
                           goal_id:particularGoalInfo?.id ?? "0",
                           video:nil,
                           thumbnil:nil,
                           title: nil,
                           type: "5",
                           update_image: strRep)
            }
        }
        else {
            let index = sender.tag
            if photosArray.indices.contains(index) {
                photosArray.remove(at: index)
                photos_Collectionview.reloadData()
                
                totalPhotos.text = "Photos \(photosArray.count)"
            } else {
                debugLog("Invalid index: \(index). Unable to remove item from photosArray.")
            }
        }
        
        
        
//        Mark Old Code......
//        var imagesArray = photosArray
//        imagesArray.remove(at: sender.tag)
//        
//        var strImagesArray = [String]()
//        _ = imagesArray.map { imgURL in
//            let newString = imgURL.absoluteString.replacingOccurrences(of: ApiURLs.GET_MEDIA_BASE_URL, with: "")
//            strImagesArray.append(newString)
//        }
//        let strRep = strImagesArray.joined(separator: ",")
//
//
//        if goals_TV.text != "" && goals_TV.text != "Write about Goal"{
//            addGoalAPI(description: nil,
//                       image: nil,
//                       apiUrl:ApiURLs.add_goal,
//                       goal_id:particularGoalInfo?.id ?? "0",
//                       video:nil,
//                       thumbnil:nil,
//                       title: nil,
//                       type: "5",
//                       update_image: strRep)
//        }
    }
}
