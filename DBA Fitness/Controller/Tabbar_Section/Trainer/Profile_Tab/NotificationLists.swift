import UIKit
import MGSwipeTableCell
import SDWebImage

class NotificationLists: UIViewController {

    //MARK : Outlets and Variables
    @IBOutlet weak var trainer_Post_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!

    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotificationLists(parameters:[:],type:"")
    }

    //MARK : IB's Action
    @IBAction func back(_ sender: UIButton) {
        //NotificationCenter.default.post(name:NSNotification.Name("isNewNotification"), object:true)
        DataSaver.dataSaverManager.saveData(key: "isNewNotification", data: false)
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: Helper's Method

}

extension NotificationLists: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = notificationListDetails?.data?.count else{
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Clients_Info", for: indexPath) as? Clients_Info {
            let clientDict = notificationListDetails?.data?[indexPath.row]
            if let photo = clientDict?.image{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    
                    cell.client_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.client_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.client_Pic.image = #imageLiteral(resourceName: "user")
                }
            }
            cell.client_Name.text = clientDict?.name
            cell.client_Age.text = clientDict?.title
            cell.client_Loc.text = ""
            cell.locationIconWidth.constant = 0.0

            cell.didTapProfileButton.tag = indexPath.row
            cell.didTapProfileButton.addTarget(self, action: #selector(moveOnSelectedUserProfile(_:)), for: .touchUpInside)
            cell.didTapProfileButton.isHidden = false


            if let createdDate = clientDict?.createdon, !createdDate.isEmpty {

                cell.joinedDate.text = createdDate.UTCToLocal(withFormat: "yyyy-MM-dd HH:mm:ss",
                                                              convertedFormat: "MMM d, yyyy, h:mm a")


                //            let dateFormatter = DateFormatter()
                //            dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                //            dateFormatter.timeZone = TimeZone(identifier: "UTC")
                //            if let startDateTime = dateFormatter.date(from: createdDate){
                //                if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                //                cell.joinedDate.text = "Joined \(joinedDate)"
                //                  
                //                }
                //            }
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clientDict = notificationListDetails?.data?[indexPath.row]
        let userID = clientDict?.fromUserid
        let loggedUserId = DataSaver.dataSaverManager.fetchData(key: "userid") as? String

        /*
        if userID == loggedUserId {
            self.tabBarController?.selectedIndex = 4
        } else {
            //            let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "User_Profile") as! User_Profile
            //            vc.notificationListUserID = userID ?? ""
            //            self.navigationController?.pushViewController(vc, animated: true)

            if let type = clientDict?.type, !type.isEmpty {
                let notificationType = NotificationListType(rawValue: type)

                if let specialID = clientDict?.specialID, !specialID.isEmpty {
                    if specialID != "0" {
                        switch notificationType {
                        case .sentMessage:
                            Constants.isMessageTab = "1"
                            let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Chat_VC") as! Chat_VC
                            vc.selectedReceiverName = clientDict?.name ?? ""
                            vc.reciver_id = userID
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)

                        case .sentProgram:
                            self.tabBarController?.selectedIndex = 2

                        case .trainerCommentedOnYourPost, .likedYourPost:
                            NVActivityIndicator.managerHandler.showIndicator()
                            self.getAllPosts(specialID)

                        case .wantsToTrainYou:
                            UniversalMethod.universalManager.pushVC(
                                "FriendsAndRequestsList",
                                self.navigationController,
                                storyBoard: AppStoryboard.Trainer_Tabbar.rawValue
                            )

                        case .startedFollowingYou:
                            let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FollowerANDFollowingList") as! FollowerANDFollowingList
                            ShareVC.type = "1"
                            ShareVC.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(ShareVC, animated: true)

                        case .followers:
                            let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FollowerANDFollowingList") as! FollowerANDFollowingList
                            ShareVC.type = "2"
                            ShareVC.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(ShareVC, animated: true)

                        default: navigateToTrainerDetailView(userID ?? "")

                        }
                    } else {
                        if notificationType == .sentProgram {
                            self.tabBarController?.selectedIndex = 2
                        } else {
                            navigateToTrainerDetailView(userID ?? "")
                        }
                    }
                } else {
                    navigateToTrainerDetailView(userID ?? "")
                }
            } else {
                navigateToTrainerDetailView(userID ?? "")
            }
        }
        */

        if let type = clientDict?.type, !type.isEmpty {

            let notificationType = NotificationListType(rawValue: type)

            switch notificationType {
            case .sentMessage:
                Constants.isMessageTab = "1"
                let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Chat_VC") as! Chat_VC
                vc.selectedReceiverName = clientDict?.name ?? ""
                vc.reciver_id = userID
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)

            case .sentProgram:
                self.tabBarController?.selectedIndex = 2

            case .trainerCommentedOnYourPost, .likedYourPost:
                if let specialID = clientDict?.specialID, !specialID.isEmpty {
                    NVActivityIndicator.managerHandler.showIndicator()
                    self.getAllPosts(specialID)
                }

            case .wantsToTrainYou:
                UniversalMethod.universalManager.pushVC(
                    "FriendsAndRequestsList",
                    self.navigationController,
                    storyBoard: AppStoryboard.Trainer_Tabbar.rawValue
                )

            case .startedFollowingYou:
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FollowerANDFollowingList") as! FollowerANDFollowingList
                ShareVC.type = "1"
                ShareVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ShareVC, animated: true)

            case .followers:
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FollowerANDFollowingList") as! FollowerANDFollowingList
                ShareVC.type = "2"
                ShareVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ShareVC, animated: true)

            default: navigateToTrainerDetailView(userID ?? "")

            }
        }
    }

    fileprivate func navigateToTrainerDetailView(_ userID: String) {
        let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
        vc.isComingFromTrainerProfileMyClients = true
        vc.selectedClientID = userID
        vc.userID = userID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func moveOnSelectedUserProfile(_ sender:UIButton) {
        let clientDict = notificationListDetails?.data?[sender.tag]
        let userID = clientDict?.fromUserid
        let loggedUserId = DataSaver.dataSaverManager.fetchData(key: "userid") as? String

        if userID == loggedUserId {
            self.tabBarController?.selectedIndex = 4
        } else {
            //            let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "User_Profile") as! User_Profile
            //            vc.notificationListUserID = userID ?? ""
            //            self.navigationController?.pushViewController(vc, animated: true)

            let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
            vc.isComingFromTrainerProfileMyClients = true
            vc.selectedClientID = userID ?? ""
            vc.userID = userID ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NotificationLists {
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

enum NotificationListType: String {
    case sentMessage = "1" // to chat
    case sentProgram = "2" // to program
    case trainerCommentedOnYourPost = "3" // particular feed
    case likedYourPost = "4" // particular feed
    case submittedARating = "5" // to user profile
    case wantsToTrainYou = "7" // to requests
    case rejectedYourTrainingRequest = "9" // to user profile
    case startedFollowingYou = "10" // to following list
    case acceptedYourTrainingRequest = "11" // to user profile
    case followers = "" // to followers list
}
