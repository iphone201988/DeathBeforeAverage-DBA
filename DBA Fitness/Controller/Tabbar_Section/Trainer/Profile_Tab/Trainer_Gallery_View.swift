
import UIKit
import MGSwipeTableCell
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import SDWebImage
import PinterestLayout

class Trainer_Gallery_View: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var plusIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var interfaceHeaderTitle: UILabel!
    @IBOutlet weak var gallerySegmentControl: UISegmentedControl!
    @IBOutlet weak var emptyHeader: UILabel!
    @IBOutlet weak var emptyDesc: UILabel!
    @IBOutlet weak var gallery_Collectionview: UICollectionView! {
        didSet {
            gallery_Collectionview.register(UINib(nibName: "Gallery_Cell", bundle: nil),
                                            forCellWithReuseIdentifier: "Gallery_Cell")
        }
    }

    var imagePickers:UIImagePickerController = UIImagePickerController()
    var photoURL:URL?
    var isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo = false
    var particularUserID = String()

    var feedData = [M_UserMyGallery]()
    var mediaData = [M_UserMyGallery]()

    fileprivate var isAlreadyLoaded = false
    fileprivate var isUploadMediaViaCamera = false

    var images: [UIImage] = [#imageLiteral(resourceName: "food"), #imageLiteral(resourceName: "food1"), #imageLiteral(resourceName: "food2"), #imageLiteral(resourceName: "food3"), #imageLiteral(resourceName: "food4"), #imageLiteral(resourceName: "food"), #imageLiteral(resourceName: "food1"), #imageLiteral(resourceName: "food4")]

    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickers.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(modifyGallery(_:)), name: NSNotification.Name(rawValue: Constants.updateGallery), object: nil)

        if let layout = gallery_Collectionview?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.cellPadding = 5
            layout.numberOfColumns = 2
        }
        
        gallerySegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.isSelectedPhotos = "0"
        photoURL = nil
        isAlreadyLoaded = false
        if isUploadMediaViaCamera {
            isUploadMediaViaCamera = false
        } else {
            if isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo {
                plusIcon.isHidden = true
                addButton.isEnabled = false
                interfaceHeaderTitle.text = "Gallery"
                userGallery(image:photoURL, gallery_id:"", user_id: particularUserID)
            }else{
                plusIcon.isHidden = false
                addButton.isEnabled = true
                interfaceHeaderTitle.text = "My Gallery"
                userGallery(image:photoURL, gallery_id:"")
            }
        }
        
        // self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func modifyGallery(_ notify:NSNotification) {
        DispatchQueue.main.async {
            let isUpdated = notify.object as? Bool
            if !self.isAlreadyLoaded {
                self.isAlreadyLoaded = true
                if isUpdated == true {
                    guard let galleryData = userInfo?.myGallery, galleryData.count > 0 else {
                        self.feedData.removeAll()
                        self.mediaData.removeAll()
                        self.gallery_Collectionview.reloadData()
                        return
                    }
                    self.feedData.removeAll()
                    self.mediaData.removeAll()

                    let workGroup = DispatchGroup()
                    workGroup.enter()

                    for data in galleryData {
                        if let feedId = data.post_id, !feedId.isEmpty {
                            if feedId != "0" {
                                self.feedData.append(data)
                            } else {
                                self.mediaData.append(data)
                            }
                        } else {
                            self.mediaData.append(data)
                        }
                    }
                    self.feedData.reverse()
                    self.mediaData.reverse()
                    workGroup.leave()
                    workGroup.notify(queue: .main) {
                        self.gallery_Collectionview.reloadData()
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
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

    @IBAction func didTapGallerySegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo {
                plusIcon.isHidden = true
                addButton.isEnabled = false
            }else{
                plusIcon.isHidden = false
                addButton.isEnabled = true
            }
        } else {
            plusIcon.isHidden = true
            addButton.isEnabled = false
        }

        DispatchQueue.main.async {
            self.gallery_Collectionview.reloadData()
        }
    }

    //MARK: Helper's Method
    
}

extension Trainer_Gallery_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if gallerySegmentControl.selectedSegmentIndex == 0 {
            count = mediaData.count
            emptyHeader.text = "No Photos"
            emptyDesc.text = "Looks like you haven't added any photos yet. Tap the plus icon in the top right corner to get started!"
        } else {
            count = feedData.count
            emptyHeader.text = "No Posts"
            emptyDesc.text = "Looks like you haven't made any posts yet. Navigate to the global feed tab and tap the plus icon in the top right to make your first post!"
        }

        //        guard let count = userInfo?.myGallery?.count else {
        //            empty_View.isHidden = false
        //            return 0
        //        }
        
        if count > 0 {
            empty_View.isHidden = true
        }else {
            empty_View.isHidden = false
        }


        return count
        //return userInfo?.myGallery?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let yourWidth = collectionView.bounds.width/2.0 - 10
        //        let yourHeight = yourWidth
        //        return CGSize(width: yourWidth, height: yourHeight)
        
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallery_Cell", for: indexPath) as? Gallery_Cell {
            removePlayButton(from: cell.trainer_Photos)

            if gallerySegmentControl.selectedSegmentIndex == 0 {
                cell.photos_View.backgroundColor = .clear
                particularGalleryDict = mediaData[indexPath.row]
                if let photoss = particularGalleryDict?.image, !photoss.isEmpty {
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                    cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"))
                }else {
                    cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
                }
       

                cell.photoDescription.lineBreakMode = .byTruncatingTail
                
                cell.photoDescription.numberOfLines = 1
                if let description = particularGalleryDict?.myGalleryDescription, !description.isEmpty {
                    cell.photoDescription.text = description
                }else{
                    cell.photoDescription.text = ""
                }
                
                DispatchQueue.main.async {
                    cell.trainer_Photos.cornerRadius = 0
                }

            } else {
                particularGalleryDict = feedData[indexPath.row]
                cell.photos_View.backgroundColor = UIColor(named: "Gradient_View_End_Color")
                if let video = particularGalleryDict?.video, let completeVideoUrl = URL(string: "\(ApiURLs.GET_MEDIA_BASE_URL)\(video)") {
                    self.addPlayButton(to: cell.trainer_Photos, for: completeVideoUrl)
                } else {
                    self.removePlayButton(from: cell.trainer_Photos)
                }
                
                if let photoss = particularGalleryDict?.image, !photoss.isEmpty{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                    
                    cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"))
                }else {
                    cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
                }
                cell.photoDescription.lineBreakMode = .byTruncatingTail

                cell.photoDescription.numberOfLines = 1
                if let description = particularGalleryDict?.myGalleryDescription, !description.isEmpty {
                    cell.photoDescription.text = description
                }else{
                    cell.photoDescription.text = ""
                }
                
                DispatchQueue.main.async {
                    cell.trainer_Photos.cornerRadius = 0
                }

            }

            //particularGalleryDict = userInfo?.myGallery?[indexPath.row]


            //cell.trainer_Photos.layer.cornerRadius = 10.0

            //        if let selectedPostId = particularGalleryDict?.post_id, !selectedPostId.isEmpty {
            //            if selectedPostId != "0" {
            //                cell.postView.isHidden = false
            //                cell.postViewBtn.tag = indexPath.item
            //                cell.postViewBtn.addTarget(self, action: #selector(didTapPostView(_ :)), for: .touchUpInside)
            //            } else {
            //                cell.postView.isHidden = true
            //            }
            //        } else {
            //            cell.postView.isHidden = true
            //        }
            //
            //        cell.postView.isHidden = true

            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        if gallerySegmentControl.selectedSegmentIndex == 0 {
            Constants.isCertificatePic = "0"
            particularGalleryDict = mediaData[indexPath.row]

            let vc = AppStoryboard.Gallery_Section.instance.instantiateViewController(withIdentifier: "Trainer_Selected_Photo") as! Trainer_Selected_Photo
            vc.isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo = self.isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)

            // UniversalMethod.universalManager.pushVC("Trainer_Selected_Photo", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
        } else {
            particularGalleryDict = feedData[indexPath.row]
            if let selectedPostId = particularGalleryDict?.post_id, !selectedPostId.isEmpty {
                if selectedPostId != "0" {
                    NVActivityIndicator.managerHandler.showIndicator()
                    self.getAllPosts(selectedPostId )
                } else {
                    Toast.show(message: "Post Id is not valid", controller: self)
                }
            } else {
                Toast.show(message: "Post Id is not valid", controller: self)
            }
        }
    }

    @objc func didTapPostView(_ sender: UIButton) {
        let particularGalleryDict = userInfo?.myGallery?[sender.tag]
        if let selectedPostId = particularGalleryDict?.post_id, !selectedPostId.isEmpty {
            guard let posts = allPosts?.data else { return }
            for postData in posts {
                if postData.postID == selectedPostId {
                    particularPostInfo = postData
                    UniversalMethod.universalManager.pushVC("Trainer_Post_Details", self.navigationController, storyBoard: AppStoryboard.Trainer_Post_Section.rawValue)
                    break
                }
            }
        } else {
            Toast.show(message: "Post-Id is not valid", controller: self)
        }
    }
    
    private func addPlayButton(to imageView: UIImageView, for videoURL: URL) {
        // Remove existing button if any
        imageView.subviews.forEach { $0.removeFromSuperview() }

        let playButton = UIButton(type: .custom)
        playButton.isUserInteractionEnabled = false
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal) // SF Symbol Play Icon
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playButton.layer.cornerRadius = 25
        playButton.clipsToBounds = true

        // Disable autoresizing mask and use Auto Layout
        playButton.translatesAutoresizingMaskIntoConstraints = false

        // Add tap action
        playButton.addAction(UIAction(handler: { _ in
    //        self.playVideo(from: videoURL)
        }), for: .touchUpInside)

        imageView.isUserInteractionEnabled = true // Enable interactions
        imageView.addSubview(playButton) // Add button to imageView

        // Set Auto Layout constraints
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func removePlayButton(from imageView: UIImageView) {
        // Iterate through all subviews of post_Pic and remove any UIButton (play button)
        imageView.subviews.forEach { subview in
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
    }
}

extension Trainer_Gallery_View: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let image = images[indexPath.row%7]
        debugLog(" image.height(forWidth: withWidth) \( image.height(forWidth: withWidth)) withWidth \(withWidth)")
        return image.height(forWidth: withWidth)
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {

        var post: M_UserMyGallery?

        if gallerySegmentControl.selectedSegmentIndex == 0 {
            post = mediaData[indexPath.row]
        } else {
            post = feedData[indexPath.row]
        }

        var text = String()
        if let description = post?.myGalleryDescription, !description.isEmpty {
            text = "test"//description
        }else{
            text = ""
        }

        let textFont = UIFont(name: "Noto Sans SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        return text.heightForWidth(width: withWidth, font: textFont) + 10
    }
}

extension UILabel {
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth,
                                              height: UIView.layoutFittingCompressedSize.height),
                                       withHorizontalFittingPriority: .required,
                                       verticalFittingPriority: .fittingSizeLevel)
    }
}

extension Trainer_Gallery_View: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark: Helper/Calling Function
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            imagePickers.mediaTypes = ["public.image"]
            imagePickers.allowsEditing = false
            isUploadMediaViaCamera = true
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
        photoURL = Trainer_Gallery_View.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
        //photoURL = Trainer_Gallery_View.saveImageInDocumentDirectory(image: image, fileName: "aa.jpg")
        Constants.isSelectedPhotos = "0"
        isAlreadyLoaded = false
        userGallery(image:photoURL, gallery_id:"", isBackAfterReload: true)
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

//extension Trainer_Gallery_View: PinterestLayoutDelegate {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
//
//
//
//            if indexPath.row % 2 == 0{
//                return 300
//            }else{
//                return 250
//            }
//
//            //        if indexPath.row == 0{
//            //            return 300
//            //        }else{
//            //            return 200
//            //        }
//
//            //return photos[indexPath.item].image.size.height
//        }
//}



/*
 import UIKit
 import MGSwipeTableCell
 import AVKit
 import MediaPlayer
 import MobileCoreServices
 import AVFoundation
 import SDWebImage
 
 class Trainer_Gallery_View: UIViewController {
 
 //MARK : Outlets and Variables
 
 @IBOutlet weak var gallery_Collectionview: UICollectionView!
 @IBOutlet weak var empty_View: UIView!
 
 var imagePickers:UIImagePickerController = UIImagePickerController()
 var counter = 1
 var diagonalArray0 = [Int]()
 var diagonalArray1 = [Int]()
 var photos = Photo.allPhotos()
 var photosArray = [URL]()
 var photoURL:URL?
 var clientInfo = [String:Any]()
 var files = [Int]()
 var goalsArray = [String]()
 var userRole = ""
 var photosCount = Int()
 var galleryId = String()
 
 //MARK : Controller Lifecycle
 
 override func viewDidLoad() {
 super.viewDidLoad()
 imagePickers.delegate = self
 userRole = DataSaver.dataSaverManager.fetchData(key: "Role") as? String ?? ""
 
 // initialSetUp()
 NotificationCenter.default.addObserver(self, selector: #selector(modifyGallery(_:)), name: NSNotification.Name(rawValue: Constants.updateGallery), object: nil)
 }
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 userGallery(image:photoURL, gallery_id:"")
 }
 
 
 func initialSetUp(){
 
 //Assign the delegate
 if let layout = self.gallery_Collectionview.collectionViewLayout as? CustomLayout{
 layout.layoutDelegate = self
 }
 
 /*if let layout = self.gallery_Collectionview?.collectionViewLayout as? PinterestLayout {
  layout.delegate = self
  }*/
 
 self.photosArray.removeAll()
 self.diagonalArray0.removeAll()
 self.diagonalArray1.removeAll()
 
 guard let count = userInfo?.myGallery?.count else{
 return
 }
 if count > 0{
 for i in 0..<count{
 if self.counter == 1 || self.counter == 4{
 self.diagonalArray0.append(i)
 }else{
 self.diagonalArray1.append(i)
 }
 if self.counter == 4{
 self.counter = 1
 }else{
 self.counter =  self.counter + 1
 }
 }
 }
 self.gallery_Collectionview.delegate = self
 self.gallery_Collectionview.dataSource = self
 self.gallery_Collectionview.register(UINib(nibName: "Gallery_Cell", bundle: nil), forCellWithReuseIdentifier: "Gallery_Cell")
 self.gallery_Collectionview.reloadData()
 
 /* for i in 0..<self.photos.count{
  if self.counter == 1 || self.counter == 4{
  self.diagonalArray0.append(i)
  }else{
  self.diagonalArray1.append(i)
  }
  if self.counter == 4{
  self.counter = 1
  }else{
  self.counter =  self.counter + 1
  }
  }*/
 
 }
 
 @objc func modifyGallery(_ notify:NSNotification){
 let isUpdated = notify.object as? Bool
 if isUpdated == true{
 
 self.gallery_Collectionview.delegate = self
 self.gallery_Collectionview.dataSource = self
 self.gallery_Collectionview.register(UINib(nibName: "Gallery_Cell", bundle: nil), forCellWithReuseIdentifier: "Gallery_Cell")
 DispatchQueue.main.async {
 self.gallery_Collectionview.reloadData()
 }
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
 
 extension Trainer_Gallery_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,CustomLayoutDelegate{
 
 //MARK: CollectionView's Delegates
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 //return photos.count
 //return loginInfo?.files?.count ?? 0
 
 
 return userInfo?.myGallery?.count ?? 0
 
 }
 
 func heightFor(index: Int) -> CGFloat {
 //Implement your own logic to return the height for specific cell
 return CGFloat(max(1, index) * 40)
 }
 
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallery_Cell", for: indexPath) as! Gallery_Cell
 //let filesDict = loginInfo?.files?[indexPath.row]
 //cell.photo = photos.first
 
 let galleryDict = userInfo?.myGallery?[indexPath.row]
 
 if let photoss = galleryDict?.image{
 if photoss != ""{
 let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
 
 cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
 }else{
 cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
 }
 }
 
 return cell
 }
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
 let storyBoard = AppStoryboard.Gallery_Section.instance
 let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Selected_Photo") as! Trainer_Selected_Photo
 // vc.selectedMediaID = loginInfo?.files?[indexPath.row].id ?? 0
 self.navigationController?.pushViewController(vc, animated: true)
 
 //UniversalMethod.universalManager.pushVC("Trainer_Selected_Photo", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
 }
 
 /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  return CGSize(width: 200, height: 200)
  }*/
 }
 /*
  extension Trainer_Gallery_View: PinterestLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView,heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {

  if diagonalArray0.contains(indexPath.item){
  return 240.0
  }else{
  return 165.0
  }

  // return photos[indexPath.item].image.size.height
  }
  }*/
 
 extension Trainer_Gallery_View: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
 // Mark: Helper/Calling Function
 func openCamera() {
 if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
 imagePickers.sourceType = UIImagePickerController.SourceType.camera
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
 imagePickers.allowsEditing = false
 self.present(imagePickers, animated: true, completion: nil)
 }
 
 //MARK: - CameraPicker delegate
 
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
 data = image.pngData()
 photoURL = Trainer_Gallery_View.saveImageInDocumentDirectory(image: image, fileName: "aa.jpg")
 //photosArray.append(photoURL)
 
 
 userGallery(image:photoURL, gallery_id:"")
 self.dismiss(animated: true, completion: nil);
 }else{
 UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
 }
 }
 public static func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL?{
 let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first;
 let fileURL = documentsUrl.appendingPathComponent(fileName)
 if let imageData = image.pngData(){
 try? imageData.write(to: fileURL, options: .atomic)
 return fileURL
 }
 return nil
 }
 
 
 
 }
 
 */

extension Trainer_Gallery_View{
    func getAllPosts(_ selectedPostId: String) {
        if Connectivity.isConnectedToInternet {
            let newURL = ApiURLs.get_global_and_personal_feed + "3" + "&post_id=\(selectedPostId)"
            apimethod.commonMethod(url: newURL, parameters: [:], method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        let allPosts = try? JSONDecoder().decode(M_AllPosts.self, from: responseData)
                        let dataStatus = allPosts?.status
                        if (dataStatus == 200 && allPosts?.data != nil) {
                            if let postData = allPosts?.data?.first {
                                particularPostInfo = postData
                                UniversalMethod.universalManager.pushVC("Trainer_Post_Details", self.navigationController, storyBoard: AppStoryboard.Trainer_Post_Section.rawValue)
                            }
                        } else {
                            Toast.show(message: "Something went wrong, please try again.", controller: self)
                        }
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}
