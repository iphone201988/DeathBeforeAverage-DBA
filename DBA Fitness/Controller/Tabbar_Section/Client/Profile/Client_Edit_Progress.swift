
import UIKit
import SDWebImage

class Client_Edit_Progress: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var time_View: UIView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var about_Progress: UITextView!
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var progressDate: UILabel!
    
    var name = String()
    var desc = String()
    var time = String()
    var photosArray = [URL]()
    var photoURL:URL?
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var currentDate = Date()
    var dateFormatter = DateFormatter()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        photos_Collectionview.delegate = self
        photos_Collectionview.dataSource = self
        photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        time_View.customView(borderWidth:1.0, cornerRadius:3.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        time_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        
        if desc != ""{
            about_Progress.text = desc
        }else{
            about_Progress.delegate = self
            about_Progress.text = "Write about your progress update"
            about_Progress.textColor = UIColor.lightGray
        }
        
        imagePickers.delegate = self
        photosArray.removeAll()
        totalPhotos.text = "Photos 0"
        dateFormatter.dateFormat = "EEE, MMM d"
        progressDate.text = dateFormatter.string(from: currentDate)
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if about_Progress.text == "Write about your progress update" || about_Progress.text == ""{
            UniversalMethod.universalManager.alertMessage("Description is requried", self.navigationController)
        }else{
            addProgress(description:about_Progress.text ?? "",image:photosArray, apiUrl:ApiURLs.add_myProgress, progress_id:"")
        }
    }
    
    @IBAction func pics(_ sender: UIButton) {
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

extension Client_Edit_Progress: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
        
        let photo = photosArray[indexPath.row]
        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        vc.isShowingLocalImage = true
        vc.localImageURL = photo
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapDelete(_ sender: UIButton) {
        photosArray.remove(at: sender.tag)
        photos_Collectionview.reloadData()
        if photosArray.count < 2{
            totalPhotos.text = "Photos \(photosArray.count)"
        }else{
            totalPhotos.text = "Photos \(photosArray.count)"
        }
    }
}

extension Client_Edit_Progress: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about your progress update"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension Client_Edit_Progress: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
