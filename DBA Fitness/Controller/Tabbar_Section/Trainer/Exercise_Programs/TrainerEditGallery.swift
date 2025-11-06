
import UIKit
import MGSwipeTableCell
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import SDWebImage
import PinterestLayout

class TrainerEditGallery: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var gallery_Collectionview: UICollectionView!
    @IBOutlet weak var empty_View: UIView!
    
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var photoURL:URL?
    var userRole = ""
    var galleryArray = [String]()
    var images: [UIImage] = [#imageLiteral(resourceName: "food"), #imageLiteral(resourceName: "food1"), #imageLiteral(resourceName: "food2"), #imageLiteral(resourceName: "food3"), #imageLiteral(resourceName: "food4"), #imageLiteral(resourceName: "food"), #imageLiteral(resourceName: "food1"), #imageLiteral(resourceName: "food4")]
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickers.delegate = self
        userRole = DataSaver.dataSaverManager.fetchData(key: "Role") as? String ?? ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(modifyGallery(_:)), name: NSNotification.Name(rawValue: Constants.updateGallery), object: nil)
        
        let excerciseImages = particularExercise?.excerciseImage ?? []
        
        if let count  = particularExercise?.excerciseImage?.count{
            if count > 0{
                galleryArray.removeAll()
                for link in excerciseImages {
                    galleryArray.append(link)
                }
            }else{
                galleryArray.removeAll()
            }
        }
        
        //  initialSetUp()
    }
    
    /* func initialSetUp(){

     let layout: BaseLayout = PinterestLayout()
     layout.delegate = self
     layout.contentPadding = ItemsPadding(horizontal: 0, vertical: 0)
     layout.cellsPadding = ItemsPadding(horizontal: 0, vertical: 0)
     gallery_Collectionview.collectionViewLayout = layout

     self.gallery_Collectionview.delegate = self
     self.gallery_Collectionview.dataSource = self
     self.gallery_Collectionview.register(UINib(nibName: "Gallery_Cell", bundle: nil), forCellWithReuseIdentifier: "Gallery_Cell")
     self.gallery_Collectionview.reloadData()
     }*/
    
    @objc func modifyGallery(_ notify:NSNotification){
        let isUpdated = notify.object as? Bool
        if isUpdated == true{
            // self.getTrainerEx(parameters:[:] )
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Photos(_ sender: UIButton) {
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
    
    //MARK: Helper's Method
    
}

extension TrainerEditGallery: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if galleryArray.count > 0{
            return galleryArray.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallery_Cell", for: indexPath) as? Gallery_Cell {
            let link = galleryArray[indexPath.row]

            if link.contains("file"){
                cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.trainer_Photos.sd_setImage(with: URL(string: link), placeholderImage: #imageLiteral(resourceName: "PlaceholderIcon"), options: .highPriority)
            }else{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(link)"
                cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "PlaceholderIcon"), options: .highPriority)
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = AppStoryboard.Gallery_Section.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "TrainerEditSelectedPhoto") as! TrainerEditSelectedPhoto
        // vc.selectedMediaID = entityDict?.files?[indexPath.row].id ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //UniversalMethod.universalManager.pushVC("Trainer_Selected_Photo", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
    }
}

extension TrainerEditGallery: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let image = images[indexPath.row%7]
        return image.height(forWidth: withWidth)
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        var text = ""
        let textFont = UIFont(name: "Noto Sans SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        return text.heightForWidth(width: withWidth, font: textFont) + 10
    }
}

extension TrainerEditGallery: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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

        reducedUploadingImage = image.compressedImages()
        photoURL = TrainerEditGallery.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)

        //photoURL = TrainerEditGallery.saveImageInDocumentDirectory(image: image, fileName: "aa.jpg")
        if let photoURL {
            galleryArray.append("\(photoURL)")
            self.gallery_Collectionview.reloadData()
        }

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
