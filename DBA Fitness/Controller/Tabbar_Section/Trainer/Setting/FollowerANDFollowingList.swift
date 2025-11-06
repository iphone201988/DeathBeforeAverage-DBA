
import UIKit
import MGSwipeTableCell
import AVKit
import SDWebImage

class FollowerANDFollowingList: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var followersANDFollowingListTableView: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    
    var type = String()
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // showAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
        if type == "1"{
            interface_Title.text = "Following Users"
        }else{
            interface_Title.text = "Follower Users"
        }
        
        getFollowersANDFollowingList(parameters: [:], type: type)
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        //removeAnimate()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}

extension FollowerANDFollowingList: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = followerANDFollowingUserInfo?.data?.count else{
            empty_View.isHidden = false
            return 0
        }
        if count  > 0{
            empty_View.isHidden = true
        }else{
            empty_View.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Clients_Info", for: indexPath) as? Clients_Info {
            let clientDict = followerANDFollowingUserInfo?.data?[indexPath.row]
            if let photo = clientDict?.image {
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    
                    cell.client_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.client_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.client_Pic.image = #imageLiteral(resourceName: "user")
                }
            }
            cell.client_Name.text = clientDict?.firstname
            cell.client_Age.text = clientDict?.age
            cell.client_Loc.text = clientDict?.location

            if let createdDate = clientDict?.createdon, !createdDate.isEmpty {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                if let startDateTime = dateFormatter.date(from: createdDate){
                    if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                        cell.joinedDate.text = "Joined \(joinedDate)"
                        
                    }
                }
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let clientDict = followerANDFollowingUserInfo?.data?[indexPath.row], let userID = clientDict.userid {
            let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
            vc.isComingFromTrainerProfileMyClients = true
            vc.selectedClientID = userID
            vc.userID = userID
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
