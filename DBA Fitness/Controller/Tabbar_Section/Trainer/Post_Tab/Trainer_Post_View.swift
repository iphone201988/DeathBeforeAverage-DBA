
import UIKit
import MGSwipeTableCell
import SDWebImage
import AVKit
import AVFoundation
class Trainer_Post_View: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var trainer_Post_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    
    @IBOutlet weak var exercise_View: UIView!
    @IBOutlet weak var programs_View: UIView!
    
    @IBOutlet weak var globalFeeds: UIButton!
    @IBOutlet weak var personalFeeds: UIButton!
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    var userid = ""
    var pageNo = 1
    var dateFormatter = DateFormatter()
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getAllPosts(parameters:[:] )
        NotificationCenter.default.addObserver(self, selector: #selector(updatedPost(_:)), name: NSNotification.Name(rawValue: Constants.isUpdatedPosts), object: nil)
        
        exercise_View.layer.cornerRadius = 4.0
        programs_View.layer.cornerRadius = 4.0
        
        self.exercise_View.layoutIfNeeded()
        exercise_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        programs_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        Constants.currentTab = "1"
        Constants.selectedCurrentFeedTab = "1"
        
        NotificationCenter.default.addObserver(self, selector: #selector(backFromLoggedUserGallerySelection(_:)), name: NSNotification.Name(rawValue: Constants.backFromLoggedUserGallerySelection), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(performActionAccordingToPushNotificationType(_:)),
                                               name: NSNotification.Name(rawValue: Constants.performActionAccordingToPushNotificationTypeWhenAppIsKill),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllPosts(parameters:[:], isScrollToBottom: true )
    }
    
    @objc func updatedPost(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            getAllPosts(parameters:[:] )
        }
    }
    
    @objc func backFromLoggedUserGallerySelection(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            self.programs_View.removeGradient()
            self.exercise_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
            self.exercise_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
            self.programs_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        }
    }
    
    @objc func performActionAccordingToPushNotificationType(_ notify: NSNotification){
        if let payloadInfo = notify.object as? [AnyHashable : Any] {
            DispatchQueue.main.async {
                let section = payloadInfo["section"]
                let userID = payloadInfo["userid"]
                let postID = payloadInfo["post_id"]
                var strRepPostID = ""
                if let postID = payloadInfo["post_id"] as? String, !postID.isEmpty {
                    strRepPostID = "\(postID)"
                }
                let strRepUserID = "\(userID ?? "")"
                let strRepSection = "\(section ?? "")"
                if let topVc = UIApplication.shared.keyWindow?.topViewController() {
                    PushNotificationType.performActionAccordingToType(type: strRepSection,
                                                                      vc: topVc,
                                                                      senderID: Constants.strRepSenderID,
                                                                      senderName: Constants.strRepSenderName,
                                                                      userID: strRepUserID,
                                                                      postID: strRepPostID)
                }
            }
        } else {
            Toast.show(message: "Notification payload's section not found", controller: self)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  let remainingPagesCount = DataSaver.dataSaverManager.fetchData(key: "remainingPages") as? Int{
            
            
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            if scrollView == trainer_Post_Tableview{
                
                if (scrollView.contentOffset.y == /*0*/ maximumOffset) {
                    
                    if remainingPagesCount < 1{
                        // UniversalMethod.universalManager.alertMessage("No Product left", self.navigationController)
                    }else{
                        pageNo = pageNo + 1
                        //getAllPosts(parameters:[:] )
                    }
                }
            }
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        let storyboard = AppStoryboard.Trainer_Post_Section.instance
        let loginScene = storyboard.instantiateViewController(withIdentifier: Trainer_Post_Section.Trainer_Add_Posts.rawValue)
        loginScene.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginScene, animated: true)
    }
    
    @IBAction func myExercise_Action(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.programs_View.removeGradient()
            self.exercise_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
            self.exercise_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
            self.programs_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
            self.view.layoutIfNeeded()
            Constants.currentTab = "1"
            Constants.selectedCurrentFeedTab = "1"
            self.getAllPosts(parameters:[:] )
        }
    }
    
    @IBAction func myPrograms_Action(_ sender: UIButton) {
        self.exercise_View.removeGradient()
        programs_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        programs_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
        exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        Constants.currentTab = "2"
        Constants.selectedCurrentFeedTab = "2"
        getAllPosts(parameters:[:] )
    }
    
    //MARK: Helper's Method
    @objc func playVideo(from videoURL: URL) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: videoURL)
        
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    
    private func addPlayButton(to imageView: UIImageView, for videoURL: URL) {
        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playButton.layer.cornerRadius = 40
        playButton.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        imageView.addSubview(playButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        playButton.addAction(UIAction(handler: { _ in
            self.playVideo(from: videoURL)
        }), for: .touchUpInside)
        
        imageView.layoutIfNeeded()
    }

    
}

extension Trainer_Post_View: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = allPosts?.data?.count else{
            empty_View.isHidden = false
            trainer_Post_Tableview.isHidden = true
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            trainer_Post_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            trainer_Post_Tableview.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Trainer_Post_Cell", for: indexPath) as? Trainer_Post_Cell {
            
            let postDict = allPosts?.data?[indexPath.row]
            //cell.name.text = postDict?.name
            cell.name.text = "\(postDict?.firstname ?? "") \(postDict?.lastname ?? "")"
            
            //cell.post_Date.text = postDict?.postDate
            cell.total_Likes.text = postDict?.totalLike
            cell.total_Comment.text = postDict?.totalComments
            cell.post_Desc.text = postDict?.datumDescription
            
            cell.post_Pic.image = nil
                cell.bgImage.image = nil
                cell.post_Pic.subviews.forEach { $0.removeFromSuperview() }
            
            if let photo = postDict?.image {
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    //cell.post_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.post_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)
                    
                    cell.post_Pic.sd_setImage(with: URL(string: completePicUrl),
                                              placeholderImage: UIImage(named: "waitPostImage"),
                                              options: SDWebImageOptions(rawValue: 0),
                                              completed: { (img, err, cacheType, imgURL) in
                        cell.post_Pic.contentMode = .scaleAspectFill
                        cell.bgImage.image = cell.post_Pic.image
                        blurEffect(cell.bgImage)
                     
                    })
                    
                }else{
                    cell.post_Pic.image = #imageLiteral(resourceName: "2020-12-10 (1)")
                }
            }
            
            
            if let videoUrlString = postDict?.video, !videoUrlString.isEmpty {
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(videoUrlString)"
                let videoUrl = URL(string: completePicUrl)
              
                // Add a play button overlay to the image view
                addPlayButton(to: cell.post_Pic, for: videoUrl!)
                cell.post_Pic.contentMode = .scaleAspectFill
                cell.bgImage.image = cell.post_Pic.image
                blurEffect(cell.bgImage)
                
                // Optionally, hide the image once the play button is added (optional, if you don't want image visible)
               
            } else {
                cell.post_Pic.isHidden = false // Show image if no video
                // Set the image (same as before)
            }
            
            
            if let photo = postDict?.userImage{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.user_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.user_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.post_Pic.image = #imageLiteral(resourceName: "user")
                }
            }
            
            if postDict?.islike == "0"{
                cell.likeIcon.image = #imageLiteral(resourceName: "Shape (3)")
            }else{
                cell.likeIcon.image = #imageLiteral(resourceName: "like (1)")
            }
            
            if postDict?.postDate != "" || postDict?.postDate != "0000-00-00 00:00:00"{
                
                cell.post_Date.text = postDict?.postDate?.UTCToLocal(withFormat: "yyyy-MM-dd HH:mm:ss", convertedFormat: "MMM d, yyyy, h:mm a")
            }
            
            cell.likePostAction.tag = indexPath.row
            cell.commentPostAction.tag = indexPath.row
            cell.moveOnUserProfile.tag = indexPath.row
            cell.moveOnPostContent.tag = indexPath.row
            
            cell.likePostAction.addTarget(self, action: #selector(likePost(_:)), for: .touchUpInside)
            cell.commentPostAction.addTarget(self, action: #selector(commentPost(_:)), for: .touchUpInside)
            
            cell.moveOnUserProfile.addTarget(self, action: #selector(moveOnSelectedUserProfile(_:)), for: .touchUpInside)
            cell.moveOnPostContent.addTarget(self, action: #selector(moveOnSelectedUserPost(_:)), for: .touchUpInside)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDict = allPosts?.data?[indexPath.row]
        
        guard postDict?.video == nil else { return }
        
        
        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        vc.imageURL = postDict?.image
        vc.interfaceTitle = "Posts"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func likePost(_ sender:UIButton){
        
        particularPostInfo = allPosts?.data?[sender.tag]
        if particularPostInfo?.islike == "0"{
            likeDislike(parameters:["post_id":particularPostInfo?.postID ?? "0", "status":"1"] )
        }else{
            likeDislike(parameters:["post_id":particularPostInfo?.postID ?? "0", "status":"0"] )
        }
    }
    
    
    @objc func commentPost(_ sender:UIButton){
        particularPostInfo = allPosts?.data?[sender.tag]
        UniversalMethod.universalManager.pushVC("PostComments", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
    
    
    @objc func moveOnSelectedUserProfile(_ sender:UIButton){
        let userRole =  DataSaver.dataSaverManager.fetchData(key: "userType") as? String
        let particularPostInfo1 = allPosts?.data?[sender.tag]
        let postUserId = particularPostInfo1?.userid
        let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String
        
        if postUserId == userid{
            self.tabBarController?.selectedIndex = 4
            if userRole == "1"{
                //self.tabBarController?.selectedIndex = 3
            }else{
                //self.tabBarController?.selectedIndex = 4
            }
        }else{
            particularPostInfo = particularPostInfo1
            
            let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
            vc.isComingFromTrainerProfileMyClients = true
            vc.selectedClientID = postUserId ?? ""
            vc.isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo = true
            vc.userID = particularPostInfo?.userid ?? "0"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            // UniversalMethod.universalManager.pushVC("User_Profile", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
        }
    }
    
    @objc func playVideo(_ sender: UIButton) {
        let postDict = allPosts?.data?[sender.tag]
        if let videoUrlString = postDict?.video, let videoUrl = URL(string: videoUrlString) {
            let playerViewController = AVPlayerViewController()
            playerViewController.player = AVPlayer(url: videoUrl)
            
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }
    
    @objc func moveOnSelectedUserPost(_ sender:UIButton){
        particularPostInfo = allPosts?.data?[sender.tag]
    
        UniversalMethod.universalManager.pushVC("Trainer_Post_Details",
                                                self.navigationController,
                                                storyBoard: AppStoryboard.Trainer_Post_Section.rawValue)
    }
}
