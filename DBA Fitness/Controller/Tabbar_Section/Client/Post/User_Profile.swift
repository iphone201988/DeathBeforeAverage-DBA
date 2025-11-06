
import UIKit
import SDWebImage

class User_Profile: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var upload_View: UIView!
    @IBOutlet weak var trainer_Image: UIImageView!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var trainer_Name: UILabel!
    @IBOutlet weak var trainer_Age: UILabel!
    @IBOutlet weak var trainer_Loc: UILabel!
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var about_View: UIView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var followers_View: UIView!
    @IBOutlet weak var following_View: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var followingAction_View: UIView!
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    @IBOutlet weak var actionSheet_View: UIView!
    @IBOutlet weak var report_View: UIView!
    @IBOutlet weak var cancel_View: UIView!
    @IBOutlet weak var aboutLable: UILabel!
    @IBOutlet weak var isFollowTitle: UILabel!
    @IBOutlet weak var userInterests: UILabel!
    
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var joinedDate: UILabel!
    @IBOutlet var userTypeLbl: UILabel!

    var certificateArray = [String]()
    var isFollowUnfollow = Int()
    var userRole = ""
    var selectedFriendsOrRequesterProfileID = ""
    var notificationListUserID = ""
    
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cancel_View.layoutIfNeeded()
        report_View.layoutIfNeeded()
        
        actionSheet_View.isHidden = true
        report_View.roundCorners(topLeft: 12.0, topRight: 12.0, bottomLeft: 0.0, bottomRight: 0.0)
        cancel_View.roundCorners(topLeft: 0.0, topRight: 0.0, bottomLeft: 12.0, bottomRight: 12.0)
        
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
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
        
        trainer_Image.setRoundImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(profileData(_:)), name: NSNotification.Name(rawValue: Constants.profileData), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.navigateToSetting = "0"
        getUserDetails(parameters:[:],
                       selectedFriendsOrRequesterProfileID: selectedFriendsOrRequesterProfileID,
                       notificationListUserID: notificationListUserID )
    }
    
    @objc func profileData(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            
            if let photo = userInfo?.data?.image{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    
                    self.trainer_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    trainer_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    trainer_Image.image = #imageLiteral(resourceName: "user")
                }
            }
            
            followers.text = userInfo?.data?.follower
            following.text = userInfo?.data?.following
            trainer_Name.text = userInfo?.data?.firstname
            // trainer_Age.text = (userInfo?.data?.age ?? "N/A") + " years"
//            trainer_Age.text = (userInfo?.data?.age ?? "N/A")
            if let age = userInfo?.data?.age, !age.isEmpty{
                self.trainer_Age.text = "\(age) years"
            }
            trainer_Loc.text = userInfo?.data?.location
            aboutLable.text = userInfo?.data?.about
            profileUsername.text = userInfo?.data?.username
            
            
            if let createdDate = userInfo?.data?.createdon, !createdDate.isEmpty {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                if let startDateTime = dateFormatter.date(from: createdDate){
                    if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                    self.joinedDate.text = "Joined \(joinedDate)"
                      
                    }
                }
            }
            
            
            if userInfo?.data?.username != ""{
                self.profileUsername.text = userInfo?.data?.username
            }else{
                self.profileUsername.text = "User Profile"
            }
            
            certificateArray.removeAll()
            let achievements = userInfo?.achievement ?? []
            if let count = userInfo?.achievement?.count{
                if count > 0{
                    for acheivementDict in achievements {
                        if let certificateCount = acheivementDict.image?.count{
                            if certificateCount > 0{
                                if let acheivementImage = acheivementDict.image {
                                    for certificateLink in acheivementImage {
                                        certificateArray.append(certificateLink)
                                    }
                                }

                            }
                        }
                    }
                    
                }else{
                    certificateArray.removeAll()
                }
                photos_Collectionview.reloadData()
            }
            
            if userInfo?.data?.isfollow == 1{
                /* if let existingLayer = (self.messageView.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
                 existingLayer.removeFromSuperlayer()
                 }*/
                self.followingAction_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
                self.messageView.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
                self.followingAction_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
                isFollowTitle.text = "Following"
                isFollowUnfollow = 1
            }else{
                followingAction_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
                isFollowTitle.text = "Follow"
                isFollowUnfollow = 0
            }
            
            if userInfo?.data?.specialist != ""{
                self.userInterests.text = userInfo?.data?.specialist ?? ""
            }else{
                self.userInterests.text = "NA"
            }
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    @IBAction func message_Action(_ sender: UIButton) {
        
        /* if let existingLayer = (followingAction_View.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
         existingLayer.removeFromSuperlayer()
         }*/
        /* messageView.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
         messageView.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
         followingAction_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)*/
        //self.tabBarController?.tabBar.isHidden = true
        Constants.isMessageTab = "2"
        
        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Chat_VC") as! Chat_VC
        if selectedFriendsOrRequesterProfileID.isEmpty {
            vc.reciver_id = notificationListUserID
        } else {
            vc.reciver_id = selectedFriendsOrRequesterProfileID
        }
        // vc.reciver_id = selectedFriendsOrRequesterProfileID
        vc.selectedReceiverName = trainer_Name.text ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //UniversalMethod.universalManager.pushVC("Chat_VC", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
    @IBAction func following_Action(_ sender: UIButton) {
        userFollow(parameters:["follower" :userInfo?.data?.userid ?? "0"] )
    }
    
    
    //MARK: Helper's Method
}

extension User_Profile: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if certificateArray.count > 0{
            return certificateArray.count
        }else{
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

            let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(certificateArray[indexPath.row])"

            cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray

            cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        vc.imageURL = certificateArray[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
