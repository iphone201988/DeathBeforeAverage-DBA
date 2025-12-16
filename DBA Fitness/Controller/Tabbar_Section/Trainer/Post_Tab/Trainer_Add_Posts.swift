
import UIKit
import AVFoundation
import AVKit

class Trainer_Add_Posts: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var about_TV: UITextView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var post_Pic: UIImageView!
    @IBOutlet weak var publishButton: GradientButton!
    
    var imagePickers:UIImagePickerController = UIImagePickerController()
    var photoURL:URL?
    var videoURL:URL?
    var videoThumbnailURL:URL?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        about_TV.delegate = self
        about_TV.text = "Write about your post"
        about_TV.textColor = UIColor.lightGray
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        post_Pic.layer.cornerRadius = 7.0
        publishButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        imagePickers.delegate = self
        about_TV.addDoneButtonOnKeyboard()
        post_Pic.contentMode = .scaleAspectFit
        imagePickers.allowsEditing = false
        imagePickers.mediaTypes = ["public.image", "public.movie"]

    }
    
    
    //MARK : IB's Action
    
    @IBAction func next(_ sender: UIButton) {
        
        if about_TV.text == "" || about_TV.text == "Write about your post"{
            UniversalMethod.universalManager.alertMessage("Post Description is required", self.navigationController)
        }else{
            let refreshAlert = UIAlertController(title: "DBA Fitness", message: "Please do not close or minimize your app until the upload is complete", preferredStyle: .alert)
            // If photoURL is not nil, upload the photo
            if let _ = photoURL {
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                    self.postUpdation(description: self.about_TV.text, image: self.photoURL, video: nil, postID: "", Url: ApiURLs.add_post, type: "1")
                }))
            }
            // If videoURL is not nil, upload the video
            else if let _ = videoURL {
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                    self.postUpdation(description: self.about_TV.text, image: self.videoThumbnailURL, video: self.videoURL, postID: "", Url: ApiURLs.add_post, type: "2")
                }))
            }
            else {
                UniversalMethod.universalManager.alertMessage("Either Post Photo or Video is required", self.navigationController)
            }
            
            // Cancel action
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                // Handle cancel
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
            
//            if photoURL?.absoluteString == nil || videoURL?.absoluteString == nil {
//                UniversalMethod.universalManager.alertMessage("Either Post Photo or Video is required", self.navigationController)
//            } else {
//                let refreshAlert = UIAlertController(title: "DBA Fitness", message: "Please do not close or minimize your app until the upload is complete", preferredStyle: .alert)
//
//                // If photoURL is not nil, upload the photo
//                if let _ = photoURL {
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
//                        self.postUpdation(description: self.about_TV.text, image: self.photoURL, video: nil, postID: "", Url: ApiURLs.add_post, type: 1)
//                    }))
//                }
//                // If videoURL is not nil, upload the video
//                if let _ = videoURL {
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
//                        self.postUpdation(description: self.about_TV.text, image: nil, video: self.videoURL, postID: "", Url: ApiURLs.add_post, type: 2)
//                    }))
//                }
//
//                // Cancel action
//                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
//                    // Handle cancel
//                }))
//
//                self.present(refreshAlert, animated: true, completion: nil)
//            }

//            if photoURL?.absoluteString == nil{
//                UniversalMethod.universalManager.alertMessage("Post Photo is required", self.navigationController)
//            }else{
//
//                let refreshAlert = UIAlertController(title: "DBA Fitness", message: "Please do not close or minimize your app until the upload is complete", preferredStyle: UIAlertController.Style.alert)
//
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
//
//                    self.postUpdation(description:self.about_TV.text,image:self.photoURL,video: self.videoURL , postID: "", Url: ApiURLs.add_post, type: 1)
//                }))
//
//                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
//
//                }))
//
//                self.present(refreshAlert, animated: true, completion: nil)
//
//
//                //postUpdation(description:about_TV.text,image:photoURL, postID: "", Url: "http://techwinlabs.in/dba/api/add_post")
//            }
//
//            if videoURL?.absoluteString == nil{
//                UniversalMethod.universalManager.alertMessage("Video Photo is required", self.navigationController)
//            }else{
//
//                let refreshAlert = UIAlertController(title: "DBA Fitness", message: "Please do not close or minimize your app until the upload is complete", preferredStyle: UIAlertController.Style.alert)
//
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
//
//                    self.postUpdation(description:self.about_TV.text,image:self.photoURL,video: self.videoURL , postID: "", Url: ApiURLs.add_post, type: 2)
//                }))
//
//                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
//
//                }))
//
//                self.present(refreshAlert, animated: true, completion: nil)
//
//
//                //postUpdation(description:about_TV.text,image:photoURL, postID: "", Url: "http://techwinlabs.in/dba/api/add_post")
//            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func camera(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Media", message: nil, preferredStyle: .actionSheet)
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

extension Trainer_Add_Posts: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about your post"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension Trainer_Add_Posts: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark: Helper/Calling Function
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            imagePickers.mediaTypes = ["public.image", "public.movie"]
            //imagePickers.allowsEditing = false
            self.present(imagePickers, animated: true, completion: nil)
        }else    {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePickers.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickers.mediaTypes = ["public.image", "public.movie"]
        //imagePickers.allowsEditing = false
        self.present(imagePickers, animated: true, completion: nil)
    }
    
    //MARK: - CameraPicker delegate
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
//        let filename = "\(currentTimeStamp)_img.jpg"
//
//        var mediaContentImage: UIImage?
//
//        if let imageEdited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            mediaContentImage = imageEdited
//        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            mediaContentImage = image
//        }else{
//            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
//        }
//
//        guard let image = mediaContentImage else { return }
//
//        data = image.pngData()
//        post_Pic.image = image//resizeImg(345, 200)
//        bgImage.image = image
//        blurEffect(bgImage)
//        reducedUploadingImage = image.compressedImages()
//        photoURL = Trainer_Add_Posts.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
//        self.dismiss(animated: true, completion: nil);
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let mediaType = info[.mediaType] as? String {
            if mediaType == "public.image" {
                // Handle image selection
                handleSelectedImage(info: info)
            } else if mediaType == "public.movie" {
                // Handle video selection
                handleSelectedVideo(info: info)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    private func handleSelectedImage(info: [UIImagePickerController.InfoKey: Any]) {
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        } else {
            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
            return
        }
        
        guard let image = selectedImage else { return }
        
        post_Pic.image = image
        bgImage.image = image
        blurEffect(bgImage)
        removePlayButton()
        reducedUploadingImage = image.compressedImages()
        photoURL = Trainer_Add_Posts.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
    }

//    private func handleSelectedVideo(info: [UIImagePickerController.InfoKey: Any]) {
//        guard let videoURL = info[.mediaURL] as? URL else {
//            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
//            return
//        }
//
//        self.videoURL = videoURL // Store the video URL for uploading
//        debugLog("Selected video URL: \(videoURL)")
//
//        // Generate Thumbnail
//        if let thumbnail = generateThumbnail(from: videoURL) {
//            post_Pic.image = thumbnail
//        }
//    }
    
    
    private func addPlayButton(to imageView: UIImageView, for videoURL: URL) {
        // Remove existing button if any
        imageView.subviews.forEach { $0.removeFromSuperview() }

        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal) // SF Symbol Play Icon
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playButton.layer.cornerRadius = 25
        playButton.clipsToBounds = true

        // Set button size and position (center of imageView)
        playButton.frame = CGRect(x: (imageView.frame.width - 50) / 2,
                                  y: (imageView.frame.height - 50) / 2,
                                  width: 50, height: 50)

        // Add tap action
        playButton.addAction(UIAction(handler: { _ in
            self.playVideo(from: videoURL)
        }), for: .touchUpInside)

        imageView.isUserInteractionEnabled = true // Enable interactions
        imageView.addSubview(playButton) // Add button to imageView
    }

    private func handleSelectedVideo(info: [UIImagePickerController.InfoKey: Any]) {
        guard let videoURL = info[.mediaURL] as? URL else {
            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
            return
        }
        
        if let savedVideoURL = saveVideoToDocumentDirectory(videoURL) {
            self.videoURL = savedVideoURL
            debugLog("Stored video URL: \(savedVideoURL.absoluteString)")
            
            // Generate Thumbnail
            let thumbnailData = generateThumbnail(from: savedVideoURL)
            if let thumbnail = thumbnailData.0, let thumbnailURL = thumbnailData.1  {
                post_Pic.image = thumbnail
                bgImage.image = thumbnail
                self.videoThumbnailURL = thumbnailURL
                addPlayButton(to: post_Pic, for: savedVideoURL)
            }
        } else {
            debugLog("Failed to save video.")
        }
    }
    
    
    
    private func playVideo(from url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            player.play()
        }
    }

    private func removePlayButton() {
        // Iterate through all subviews of post_Pic and remove any UIButton (play button)
        post_Pic.subviews.forEach { subview in
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
    }



    private func saveVideoToDocumentDirectory(_ videoURL: URL) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let newURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).mp4")

        do {
            if fileManager.fileExists(atPath: newURL.path) {
                try fileManager.removeItem(at: newURL)  // Remove if it already exists
            }
            try fileManager.copyItem(at: videoURL, to: newURL)
            debugLog("Video successfully saved at: \(newURL)")
            return newURL
        } catch {
            debugLog("Error saving video: \(error.localizedDescription)")
            return nil
        }
    }


    /// Generate Thumbnail from Video URL
    private func generateThumbnail(from url: URL) -> (UIImage?, URL?) {
        let asset = AVAsset(url: url)
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        assetGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1, preferredTimescale: 600) // Get thumbnail at 1 second
        do {
            let cgImage = try assetGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
            let filename = "\(currentTimeStamp)_img.jpg"
            if let thumbnailURL = Trainer_Add_Posts.saveImageInDocumentDirectory(image: thumbnail, fileName: filename) {
                return (thumbnail, thumbnailURL)
            } else {
                return (nil, nil)
            }
            
        } catch {
            debugLog("Failed to generate thumbnail: \(error.localizedDescription)")
            return (nil, nil)
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

func blurEffect(_ bgImageView:UIImageView){
    if
        let cgImage = bgImageView.image?.cgImage,
        let bgImageViewSize = bgImageView.image?.size {
        let inputImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(10, forKey: "inputRadius")
        let blurred = filter?.outputImage
        if let blurredExtent = blurred?.extent {
            var newImageSize: CGRect = blurredExtent
            newImageSize.origin.x += (newImageSize.size.width - (bgImageView.image?.size.width ?? 0.0)) / 2
            newImageSize.origin.y += (newImageSize.size.height - (bgImageView.image?.size.height ?? 0.0)) / 2
            newImageSize.size = bgImageViewSize
            
            if let resultImage: CIImage = filter?.value(forKey: "outputImage") as? CIImage {
                let context: CIContext = CIContext.init(options: nil)
                if
                    let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize) {
                    let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
                    bgImageView.image = blurredImage
                }
            }
        }
    }
}
