
import UIKit
import SDWebImage

class Trainer_Detail_View: UIViewController {
    
    //MARK : Outlets and Variables
    
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
    @IBOutlet weak var anthropometric_View: UIView!
    @IBOutlet weak var achievement_View: UIView!
    @IBOutlet weak var becomeClientORTrainerView: UIView!
    
    @IBOutlet weak var acceptRequestView: UIView!
    @IBOutlet weak var rejectRequestView: UIView!
    
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var followers_View: UIView!
    @IBOutlet weak var following_View: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var followingAction_View: UIView!
    @IBOutlet weak var ratingIcon: UIImageView!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var trainer_About: UILabel!
    @IBOutlet weak var isFollowTitle: UILabel!
    @IBOutlet weak var userInterests: UILabel!
    @IBOutlet weak var becomeClientORTrainerButton: UIButton!
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet weak var myProgress_View: UIView!
    @IBOutlet weak var myGoals_View: UIView!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var goalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressViewTop: NSLayoutConstraint!
    @IBOutlet weak var progressViewBottom: NSLayoutConstraint!
    @IBOutlet weak var achievementsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var achievementsViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var actionSheet_View: UIView!
    @IBOutlet weak var report_View: UIView!
    @IBOutlet weak var cancel_View: UIView!
    @IBOutlet weak var moreIcon: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var becomeClientORTrainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var acceptRequestViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rejectRequestViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var joinedDate: UILabel!
    @IBOutlet var userTypeLbl: UILabel!
    
    @IBOutlet weak var interests_collectionview: UICollectionView!
    @IBOutlet weak var interests_collectionview_height_constraint: NSLayoutConstraint!
    
    var interest_collection_height_observer: NSKeyValueObservation?
    var interests_dataSource: User_Interest_CollectionView_DataSource?
    
    var certificateArray = [String]()
    var isFollowUnfollow = Int()
    var userRole = ""
    
    var isComingFromTrainerProfileMyClients = false
    var isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo = false
    var selectedClientID = ""
    var searchedClientUserID = String()
    var isComingFromInboxSection = false
    
    var selectedUserID = String()
    var userID = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myProgress_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        myGoals_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        achievement_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        becomeClientORTrainerView.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        acceptRequestView.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        rejectRequestView.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        anthropometric_View.customView(borderWidth:0.5, cornerRadius:4.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        about_View.customView(borderWidth:0.5, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        followers_View.customView(borderWidth:0.5, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        following_View.customView(borderWidth:0.5, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        messageView.layer.cornerRadius = 4.0
        followingAction_View.layer.cornerRadius = 4.0
        
        photos_Collectionview.delegate = self
        photos_Collectionview.dataSource = self
        photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        
        upload_View.setViewCircle()
        
        upload_View.viewUpdatedShadow(red: 45/255, green: 38/255, blue: 63/255, alpha: 1.0)
        followers_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        following_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        messageView.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        followingAction_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        ratingIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.3, radius: 5.5)
        trainer_Image.setRoundImage()
        
        
        cancel_View.layoutIfNeeded()
        report_View.layoutIfNeeded()
        
        actionSheet_View.isHidden = true
        report_View.roundCorners(topLeft: 12.0, topRight: 12.0, bottomLeft: 0.0, bottomRight: 0.0)
        cancel_View.roundCorners(topLeft: 0.0, topRight: 0.0, bottomLeft: 12.0, bottomRight: 12.0)
        
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
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        certificateArray.removeAll()
        
        if isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo {
            moreIcon.isHidden = false
            moreButton.isEnabled = true
        }else{
            moreIcon.isHidden = true
            moreButton.isEnabled = false
        }
        
        userProfileInfo(parameters:[:] )
    }
    
    //MARK : IB's Action
    @IBAction func reportAction(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        //actionSheet_View.isHidden = true
        reportUser(parameters:["report_userid":userInfo?.data?.userid ?? "0","report_content":"Abusive"])
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        actionSheet_View.isHidden = true
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = true
        actionSheet_View.isHidden = false
    }
    
    
    @IBAction func myProgress(_ sender: UIButton) {
        //UniversalMethod.universalManager.pushVC("Client_Progress_View", self.navigationController, storyBoard: AppStoryboard.Client_Progress.rawValue)
        let vc = AppStoryboard.Client_Progress.instance.instantiateViewController(withIdentifier: "Client_Progress_View") as! Client_Progress_View
        vc.searchedClientUserID = self.searchedClientUserID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func myGoals(_ sender: UIButton) {
        
        let storyBoard = AppStoryboard.Onboarding.instance
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "Client_Goals") as! Client_Goals
        //let vc = storyBoard.instantiateViewController(identifier: "Client_Goals") as! Client_Goals
        vc.isComing_From_Tab = true
        vc.searchedClientUserID = self.searchedClientUserID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        // Universal_Method.universalManager.pushVC("Client_Goals", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func anthropometric(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Searched_Trainer_Anthropometric", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
    
    @IBAction func achievements(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Searched_Trainer_Achievement", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
    
    @IBAction func gallery_View(_ sender: UIButton) {
        //UniversalMethod.universalManager.pushVC("Trainer_Gallery_View", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
    }
    
    @IBAction func message_Action(_ sender: UIButton) {
        
        /* if let existingLayer = (followingAction_View.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
         existingLayer.removeFromSuperlayer()
         }
         messageView.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
         messageView.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
         followingAction_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)*/
        //self.tabBarController?.tabBar.isHidden = true
        Constants.isMessageTab = "0"
        
        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Chat_VC") as! Chat_VC
        vc.reciver_id = selectedUserID
        vc.selectedReceiverName = trainer_Name.text ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //
        //        UniversalMethod.universalManager.pushVC("Chat_VC", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
    
    @IBAction func following_Action(_ sender: UIButton) {
        
        /*  if let existingLayer = (messageView.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
         existingLayer.removeFromSuperlayer()
         }
         followingAction_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
         messageView.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
         followingAction_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
         */
        //userFollow(parameters:["follower" :searchedTrainerInfo?.userid ?? "0"] )
        userFollow(parameters:["follower" :userID] )
    }
    
    @IBAction func tappedBecomeClientORTrainer(_ sender: UIButton) {
        callBecomeClientORTrainer(parameters:["userid2":userInfo?.data?.userid ?? ""] )
    }
    
    @IBAction func tappedAcceptRequest(_ sender: UIButton) {
        callAcceptORRejectRequest(parameters:["request" :"3", "userid2":userInfo?.data?.userid ?? ""] )
    }
    
    @IBAction func tappedRejectRequest(_ sender: UIButton) {
        callAcceptORRejectRequest(parameters:["request" :"4", "userid2":userInfo?.data?.userid ?? ""] )
    }
    
    @IBAction func tappedRatingAndReviews(_ sender: UIButton) {
        if userInfo?.data?.is_purchased == "1"{
            if userInfo?.data?.is_rating_enable == "1"  {
                let storyBoard = AppStoryboard.Client_Search.instance
                let destVC = storyBoard.instantiateViewController(withIdentifier: "Rate_Trainer") as! Rate_Trainer
                let userInfo = ParticularUserInfoForRatingView(userid: userInfo?.data?.userid,
                                                               firstname: userInfo?.data?.firstname,
                                                               lastname: userInfo?.data?.lastname,
                                                               image: userInfo?.data?.image,
                                                               rating: userInfo?.data?.rating)
                destVC.particularUserInfoForRatingView = userInfo
                destVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                guard
                    let userID = userInfo?.data?.userid
                else {
                    Toast.show(message: "User ID not found", controller: self)
                    return
                }
                let storyBoard = AppStoryboard.Trainer_Setting.instance
                let destVC = storyBoard.instantiateViewController(withIdentifier: "Client_Review") as! Client_Review
                destVC.ratingAndCommentsFetchingType = .ratingCommentGivenByMeIncludedAnotherToParticularUser
                destVC.userID = userID
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }else{
            if (userRole == Role.client.rawValue){

                UniversalMethod.universalManager.alertMessage("Please purchase program first to rate the trainer.", self)

            }else if (userRole == Role.trainer.rawValue){
                if userInfo?.data?.is_rating_enable == "0"  {
                    UniversalMethod.universalManager.alertMessage("Program not purchased by client.", self)
                }else{
                    let storyBoard = AppStoryboard.Client_Search.instance
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "Rate_Trainer") as! Rate_Trainer
                    let userInfo = ParticularUserInfoForRatingView(userid: userInfo?.data?.userid,
                                                                   firstname: userInfo?.data?.firstname,
                                                                   lastname: userInfo?.data?.lastname,
                                                                   image: userInfo?.data?.image,
                                                                   rating: userInfo?.data?.rating)
                    destVC.particularUserInfoForRatingView = userInfo
                    destVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(destVC, animated: true)
                }

            }
        }
    }
    
    @IBAction func tappedReviews(_ sender: UIButton) {
        guard
            let userID = userInfo?.data?.userid
        else {
            Toast.show(message: "User ID not found", controller: self)
            return
        }
        let storyBoard = AppStoryboard.Trainer_Setting.instance
        let destVC = storyBoard.instantiateViewController(withIdentifier: "Client_Review") as! Client_Review
        destVC.ratingAndCommentsFetchingType = .ratingCommentGivenByMeIncludedAnotherToParticularUser
        destVC.userID = userID
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    //MARK: Helper's Method
}

extension Trainer_Detail_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if certificateArray.count > 0{
        //            emptyGallery.isHidden = true
        //            return certificateArray.count
        //        }else{
        //            emptyGallery.isHidden = false
        //            return 0
        //        }
        //
        
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
            //        let photo = certificateArray[indexPath.row]
            //        if photo != ""{
            //            let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
            //
            //            cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //            cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            //        }else{
            //            cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
            //        }
            
            
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
            
            cell.trainer_Photos.layer.cornerRadius = 20.0
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        Constants.currentTab = "1"
        //        Constants.selectedGalleryPhotoAssociatedPostID = userInfo?.myGallery?[indexPath.row].post_id ?? ""
        //        self.tabBarController?.selectedIndex = 0
        //        NotificationCenter.default.post(name:NSNotification.Name(Constants.backFromLoggedUserGallerySelection), object:true)
        
        let vc = AppStoryboard.Gallery_Section.instance.instantiateViewController(withIdentifier: "Trainer_Gallery_View") as! Trainer_Gallery_View
        vc.isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo = true
        vc.particularUserID = selectedUserID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
