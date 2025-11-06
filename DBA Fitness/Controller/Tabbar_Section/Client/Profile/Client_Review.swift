
import UIKit
import MGSwipeTableCell
import SDWebImage

class Client_Review: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var review_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    var pageNo = 1
    var ratingAndCommentsFetchingType: RatingAndCommentsFetchingType = .ratingCommentGivenByLoggedUser
    var isComingFromSettingMyReviews = false
    var userID: String = ""

    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clientAllReviews(parameters:[:], anotherUserID: userID )
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  let remainingPagesCount = DataSaver.dataSaverManager.fetchData(key: "remainingPages") as? Int{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if scrollView == review_Tableview{
                if (scrollView.contentOffset.y == /*0*/ maximumOffset) {
                    if remainingPagesCount < 1{
                        // UniversalMethod.universalManager.alertMessage("No Product left", self.navigationController)
                    }else{
                        pageNo = pageNo + 1
                        clientAllReviews(parameters:[:], anotherUserID: userID )
                    }
                }
            }
        }
    }
}

extension Client_Review: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = clientReviewsInfo?.data?.count else{
            empty_View.isHidden = false
            review_Tableview.isHidden = true
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            review_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            review_Tableview.isHidden = false
        }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reviews", for: indexPath) as? Reviews {
            let reviewDict = clientReviewsInfo?.data?[indexPath.row]
            cell.reviews.text = reviewDict?.comment
            cell.name.text = reviewDict?.name
            cell.rating.text = reviewDict?.rating
            cell.ratingIcon.isHidden = false
            cell.ratingIcon.image = #imageLiteral(resourceName: "StarIcon")
            if let photo = reviewDict?.image{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    
                    cell.user_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.user_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.user_Pic.image = #imageLiteral(resourceName: "user")
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var paramsUserID: String?
        let loggedUserID = DataSaver.dataSaverManager.fetchData(key: "userid") as? String
        let trainerID = clientReviewsInfo?.data?[indexPath.row].trainerID
        let userid = clientReviewsInfo?.data?[indexPath.row].userid

        if isComingFromSettingMyReviews {
            if loggedUserID == trainerID {
                paramsUserID = userid
            } else {
                paramsUserID = trainerID
            }

        } else {
            if loggedUserID == userid {
                paramsUserID = trainerID
            } else {
                paramsUserID = userid
            }
        }

        guard let paramsUserID else { return }
        let storyBoard = AppStoryboard.Client_Search.instance
        let destVC = storyBoard.instantiateViewController(withIdentifier: "Client_Comment") as! Client_Comment
        destVC.userID = paramsUserID
        // self.navigationController?.pushViewController(destVC, animated: true)

//        UniversalMethod.universalManager.pushVC("Client_Comment", self.navigationController,
//                                                storyBoard: AppStoryboard.Client_Search.rawValue)
    }
}
