import UIKit
import SDWebImage

class Client_Profile_View: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var setting: UIButton!
    @IBOutlet weak var upload_View: UIView!
    @IBOutlet weak var trainer_Image: UIImageView!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var trainer_Name: UILabel!
    @IBOutlet weak var trainer_Age: UILabel!
    @IBOutlet weak var trainer_Loc: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var about_View: UIView!
    @IBOutlet weak var myProgress_View: UIView!
    @IBOutlet weak var nutrition_View: UIView!
    @IBOutlet weak var myGoals_View: UIView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var followers_View: UIView!
    @IBOutlet weak var following_View: UIView!
    @IBOutlet weak var trainer_About: UILabel!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var userInterests: UILabel!
    @IBOutlet weak var friends_View: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var newRequestsView: UIView!
    @IBOutlet weak var newRequestCount: UILabel!
    @IBOutlet weak var myTrainerView: UIView!
    @IBOutlet weak var joinedDate: UILabel!
    @IBOutlet var userTypeLbl: UILabel!
    @IBOutlet weak var interests_collectionview: UICollectionView!
    @IBOutlet weak var interests_collectionview_height_constraint: NSLayoutConstraint!
    
    var interest_collection_height_observer: NSKeyValueObservation?
    var interests_dataSource: User_Interest_CollectionView_DataSource?
    var certificateArray = [String]()
    var apiCallTimer: Timer?
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        myProgress_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        friends_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        nutrition_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        myGoals_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        about_View.customView(borderWidth:0.5, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        followers_View.customView(borderWidth:0.5, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        following_View.customView(borderWidth:0.5, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        followers_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        following_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        upload_View.setViewCircle()
        upload_View.viewUpdatedShadow(red: 45/255, green: 38/255, blue: 63/255, alpha: 1.0)
        
        myTrainerView.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        trainer_Image.setRoundImage()
        
        notificationCountView.setViewCircle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isNewNotification(_:)),
                                               name: NSNotification.Name(rawValue: "isNewNotification"), object: nil)
        
        // setup user interests
        interests_dataSource = User_Interest_CollectionView_DataSource(interests_collectionview)
        interests_collectionview.dataSource = interests_dataSource
        interests_collectionview.delegate = interests_dataSource
        
        // Height observer
        interest_collection_height_observer = interests_collectionview.observe(\.contentSize, changeHandler: { [weak self] collectionView, _ in
            guard let self = self else { return }
            self.interests_collectionview.invalidateIntrinsicContentSize()
            self.interests_collectionview_height_constraint.constant = collectionView.contentSize.height
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        certificateArray.removeAll()
        userProfileInfo(parameters:[:] )
        
        let tabBarItem = self.tabBarController?.tabBar.items?[4]
        tabBarItem?.badgeValue = ""
        tabBarItem?.badgeColor = .clear
        if let isNewNotification = DataSaver.dataSaverManager.fetchData(key: "isNewNotification") as? Bool, isNewNotification {
            notificationCountView.isHidden = false
        } else {
            notificationCountView.isHidden = true
        }

        apiCallTimer = Timer.scheduledTimer(timeInterval: 60.0,
                                            target: self,
                                            selector: #selector(unreadNotificationCount),
                                            userInfo: nil,
                                            repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        apiCallTimer?.invalidate()
    }

    @objc func unreadNotificationCount() {
       // getUnreadNotificationCount()
    }
    
    @objc func isNewNotification(_ notify:NSNotification){
        notificationCountView.isHidden = false
    }
    
    //MARK : IB's Action
    
    @IBAction func tappedNotificationList(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC(Trainer_Tabbar.NotificationLists.rawValue, self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
    @IBAction func back(_ sender: UIButton) {}
    
    @IBAction func setting(_ sender: UIButton) {
        Constants.navigateToSetting = "1"
        getUserDetails(parameters:[:] )
        
        //UniversalMethod.universalManager.pushVC("Settings", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)
    }
    
    @IBAction func myProgress(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Client_Progress_View", self.navigationController, storyBoard: AppStoryboard.Client_Progress.rawValue)
    }
    
    @IBAction func myGoals(_ sender: UIButton) {
        
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
        
        let storyBoard = AppStoryboard.Onboarding.instance
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "Client_Goals") as! Client_Goals
        //let vc = storyBoard.instantiateViewController(identifier: "Client_Goals") as! Client_Goals
        vc.isComing_From_Tab = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        // Universal_Method.universalManager.pushVC("Client_Goals", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    @IBAction func nutritionDiary(_ sender: UIButton) {
        
    }
    
    @IBAction func gallery_View(_ sender: UIButton) {
        
        let vc = AppStoryboard.Gallery_Section.instance.instantiateViewController(withIdentifier: "Trainer_Gallery_View") as! Trainer_Gallery_View
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //UniversalMethod.universalManager.pushVC("Trainer_Gallery_View", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
    }
    
    @IBAction func tappedFollowers(_ sender: UIButton) {
        
        let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FollowerANDFollowingList") as! FollowerANDFollowingList
        ShareVC.type = "2"
        ShareVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ShareVC, animated: true)
        //        self.addChild(ShareVC)
        //        ShareVC.view.frame = self.view.frame
        //        self.view.addSubview(ShareVC.view)
        //        ShareVC.didMove(toParent: self)

    }
    
    @IBAction func tappedFollowing(_ sender: UIButton) {
        let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FollowerANDFollowingList") as! FollowerANDFollowingList
        ShareVC.type = "1"
        ShareVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ShareVC, animated: true)
        //        self.addChild(ShareVC)
        //        ShareVC.view.frame = self.view.frame
        //        self.view.addSubview(ShareVC.view)
        //        ShareVC.didMove(toParent: self)
    }
    
    @IBAction func tappedFriends(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("FriendsAndRequestsList", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
    @IBAction func didTapMyTrainer(_ sender: UIButton) {
        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Trainer_s_Clients") as! Trainer_s_Clients
        vc.isSend = "0"
        vc.type = "3"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func tappedRatingAndReviews(_ sender: UIButton) {
        let storyBoard = AppStoryboard.Trainer_Setting.instance
        let destVC = storyBoard.instantiateViewController(withIdentifier: "Client_Review") as! Client_Review
        destVC.ratingAndCommentsFetchingType = .ratingCommentGivenToLoggedUser
        self.navigationController?.pushViewController(destVC, animated: true)

//        UniversalMethod.universalManager.pushVC("Client_Review", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)
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
    
    //MARK: Helper's Method
}

extension Client_Profile_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /*  if let count = loginInfo?.files?.count{
         if count > 0{
         emptyGallery.isHidden = true
         return count
         }else{
         emptyGallery.isHidden = false
         return 0
         }
         }else{
         emptyGallery.isHidden = false
         return 0
         }*/
        
        guard let count = userInfo?.myGallery?.count else{
            emptyGallery.isHidden = false
            return 0
        }
        
        if count > 0{
            emptyGallery.isHidden = true
        }else{
            emptyGallery.isHidden = false
        }
        return count
        
        
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
            //cell.trainer_Photos.image = #imageLiteral(resourceName: "PlaceholderIcon")

            particularGalleryDict = userInfo?.myGallery?[indexPath.row]

            if let photoss = particularGalleryDict?.image{
                if photoss != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                    
                    cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
                }
            }
            
            if let video = particularGalleryDict?.video, !video.isEmpty,
                let completeVideoUrl = URL(string: "\(ApiURLs.GET_MEDIA_BASE_URL)\(video)") {
                self.addPlayButton(to: cell.trainer_Photos, for: completeVideoUrl)
            } else {
                self.removePlayButton(from: cell.trainer_Photos)
            }


            cell.trainer_Photos.layer.cornerRadius = 20.0

            //        if let selectedPostId = particularGalleryDict?.post_id, !selectedPostId.isEmpty {
            //            if selectedPostId != "0" {
            //                cell.feedView.isHidden = false
            //            } else {
            //                cell.feedView.isHidden = true
            //            }
            //        } else {
            //            cell.feedView.isHidden = true
            //        }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        particularGalleryDict = userInfo?.myGallery?[indexPath.row]
        //
        //        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        //        vc.imageURL = particularGalleryDict?.image
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
        //        Constants.currentTab = "1"
        //        Constants.selectedGalleryPhotoAssociatedPostID = userInfo?.myGallery?[indexPath.row].post_id ?? ""
        //        self.tabBarController?.selectedIndex = 0
        //        NotificationCenter.default.post(name:NSNotification.Name(Constants.backFromLoggedUserGallerySelection), object:true)
        
        //UniversalMethod.universalManager.pushVC("Trainer_Gallery_View", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
        
        
        let vc = AppStoryboard.Gallery_Section.instance.instantiateViewController(withIdentifier: "Trainer_Gallery_View") as! Trainer_Gallery_View
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Client_Profile_View {
    func getUnreadNotificationCount() {
        if Connectivity.isConnectedToInternet {
            apimethod.commonMethod(url: ApiURLs.get_notification_count, parameters: [:], method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400){
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        let resp = try? JSONDecoder().decode(UnreadNotificationCount.self, from: responseData)
                        if let count = resp?.data, count != "0" {
                            self.notificationCount.text = count
                            self.notificationCountView.isHidden = false
                        } else {
                            self.notificationCount.text = ""
                            self.notificationCountView.isHidden = true
                        }
                    } else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}

class User_Interest_CollectionView_DataSource: NSObject,
                                               UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UICollectionViewDelegateFlowLayout {
    weak var interest_Collectionview: UICollectionView?
    public var user_interests_data = [String]()
    
    init(_ interest_Collectionview: UICollectionView? = nil) {
        self.interest_Collectionview = interest_Collectionview
        super.init()
        
        self.interest_Collectionview?.delegate = self
        self.interest_Collectionview?.dataSource = self
        self.interest_Collectionview?.collectionViewLayout = CustomCollectionViewFlowLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        user_interests_data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "User_Interest_Cell", for: indexPath) as? User_Interest_Cell {
            
            cell.interestLabel.text = user_interests_data[indexPath.row]
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = user_interests_data[indexPath.row]
        let label = UILabel(frame: CGRect.zero)
        label.text =  text
        label.font = UIFont(name: "Nunito-Regular", size: 10.0)
        label.sizeToFit()
        return CGSize(width: label.frame.width+20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
