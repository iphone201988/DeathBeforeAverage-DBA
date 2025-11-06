
import UIKit
import Photos
import SDWebImage

class Load_Certificates: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var certificates_Collectionview: UICollectionView!
    @IBOutlet weak var gallery_Collectionview: UICollectionView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var emptyCertificateView: UIView!
    
    var yourHeight = CGFloat()
    var photoURL:URL?
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var arr_img = NSMutableArray()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //  main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        certificates_Collectionview.delegate = self
        certificates_Collectionview.dataSource = self
        certificates_Collectionview.register(UINib(nibName: "Certificates_Photos", bundle: nil), forCellWithReuseIdentifier: "Certificates_Photos")
        
        gallery_Collectionview.delegate = self
        gallery_Collectionview.dataSource = self
        gallery_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        imagePickers.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let allPhotosOptions : PHFetchOptions = PHFetchOptions.init()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let allPhotosResult = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        allPhotosResult.enumerateObjects({ (asset, idx, stop) in
            self.arr_img.add(asset)
        })
        self.gallery_Collectionview.reloadData()
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadCertificate(_ sender: UIButton) {
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
    
    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)//CGSizeMake(size * retinaScale, size * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x: 0, y: 0, width: cropSizeLength, height: cropSizeLength)//CGRectMake(0, 0, CGFloat(cropSizeLength), CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))

        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()

        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect

        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}

extension Load_Certificates: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == certificates_Collectionview{
            guard let count = particularAcheivementInfo?.image?.count else{
                emptyCertificateView.isHidden = false
                return 0
            }
            if count > 0{
                emptyCertificateView.isHidden = true
            }else{
                emptyCertificateView.isHidden = false
            }
            return count
        }else{
            return arr_img.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == certificates_Collectionview{
            let yourWidth = collectionView.bounds.width/3.0 - 10
            yourHeight = yourWidth
            return CGSize(width: yourWidth, height: yourHeight)
        }else{
            return CGSize(width: 95.0, height: 90.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == certificates_Collectionview{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Certificates_Photos", for: indexPath) as? Certificates_Photos {

                cell.deleteIcon.isHidden = true
                cell.deleteBtn.isHidden = true

                if let photoss = particularAcheivementInfo?.image?[indexPath.row] {
                    if photoss != "" {
                        let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                        
                        cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                        cell.deleteIcon.isHidden = false
                        cell.deleteBtn.isHidden = false
                        cell.deleteBtn.tag = indexPath.item
                        cell.deleteBtn.addTarget(self, action: #selector(didTapDelete(_ :)), for: .touchUpInside)
                    } else {
                        cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
                    }
                }
                return cell
            } else {
                return UICollectionViewCell()
            }
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Photos_Cell", for: indexPath) as? Trainer_Photos_Cell {
                cell.photos_View_Height.constant = 85.0
                if let phAsset = self.arr_img.object(at: indexPath.row) as? PHAsset {
                    cell.trainer_Photos.image = self.getAssetThumbnail(asset: phAsset, size: 150.0)
                }
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == certificates_Collectionview {
            Constants.isCertificatePic = "1"
            particularCertificateInfo = particularAcheivementInfo?.image?[indexPath.row]
            //           UniversalMethod.universalManager.pushVC("Trainer_Selected_AchievementCertificate", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
        }else{
            if let phAsset = self.arr_img.object(at: indexPath.row) as? PHAsset {
                let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
                let filename = "\(currentTimeStamp)_img.jpg"
                let imgview = UIImageView()
                imgview.image = self.getAssetThumbnail(asset: phAsset, size: 150.0)
                if imgview.image != nil {
                    if let imgViewImage = imgview.image {
                        photoURL = Load_Certificates.saveImageInDocumentDirectory(image: imgViewImage, fileName: filename)
                        updateGallery(image:photoURL, achievement_id:particularAcheivementInfo?.id ?? "0")
                    }
                }
            }
        }
    }

    @objc func didTapDelete(_ sender: UIButton) {
        if var images = particularAcheivementInfo?.image,
           let achievementId = particularAcheivementInfo?.id, !achievementId.isEmpty {
            images.remove(at: sender.tag)
            let strRep = images.joined(separator: ",")
            updateGallery(image: nil, achievement_id: achievementId, type: "1", update_image: strRep)
        }
    }
}

extension Load_Certificates: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
                
                reducedUploadingImage = image.compressedImages()
                
                let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
                let filename = "\(currentTimeStamp)_img.jpg"
                
                photoURL = Load_Certificates.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
                updateGallery(image:photoURL, achievement_id:particularAcheivementInfo?.id ?? "0")
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
