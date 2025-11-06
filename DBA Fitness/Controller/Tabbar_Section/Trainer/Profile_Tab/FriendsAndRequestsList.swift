
import UIKit
import MGSwipeTableCell
import SDWebImage

class FriendsAndRequestsList: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var trainer_Post_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    
    @IBOutlet weak var exercise_View: UIView!
    @IBOutlet weak var programs_View: UIView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    var userid = ""
    var pageNo = 1
    var dateFormatter = DateFormatter()
    var searchedString = String()
    var replaced = String()
    var stringRep = String()
    var selectedTabType = String()
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getAllPosts(parameters:[:] )
        exercise_View.layer.cornerRadius = 4.0
        programs_View.layer.cornerRadius = 4.0
        self.exercise_View.layoutIfNeeded()
        exercise_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        programs_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        
        searchView.layer.cornerRadius = 20.0
        searchView.layer.borderWidth = 1.0
        searchView.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        searchView.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.72, radius: 10.5)
        searchTF.delegate = self
        searchTF.addDoneButtonOnKeyboard()
        searchTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
        selectedTabType = "2"
        getFriendsOrRequestsListAPI(parameters:[:],type:selectedTabType )
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myExercise_Action(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.programs_View.removeGradient()
            self.exercise_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
            self.exercise_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
            self.programs_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
            self.view.layoutIfNeeded()
            self.selectedTabType = "1"
            self.getFriendsOrRequestsListAPI(parameters:[:],type:self.selectedTabType)
        }
    }
    
    @IBAction func myPrograms_Action(_ sender: UIButton) {
        self.exercise_View.removeGradient()
        programs_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        programs_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
        exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        self.selectedTabType = "2"
        self.getFriendsOrRequestsListAPI(parameters:[:],type:selectedTabType)
    }
    
    //MARK: Helper's Method
    
}

extension FriendsAndRequestsList: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = friendsOrRequestsList?.data?.count else{
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
            let clientDict = friendsOrRequestsList?.data?[indexPath.row]
            if let photo = clientDict?.image{
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

            if self.selectedTabType == "2"{
                let rejectButton = RowActionButton(title: "", icon:#imageLiteral(resourceName: "fired"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.rejectRequest(at: indexPath.row)
                    return true
                }
                let acceptButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "accepted"), backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.acceptRequest(at: indexPath.row)
                    return true
                }
                cell.rightButtons = [rejectButton, acceptButton]
                cell.configure()
            }else{
                cell.rightButtons = []
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //UniversalMethod.universalManager.pushVC("User_Profile", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
        
        //        let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "User_Profile") as! User_Profile
        //        vc.selectedFriendsOrRequesterProfileID = friendsOrRequestsList?.data?[indexPath.row].userid ?? ""
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
        let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
        vc.selectedClientID = friendsOrRequestsList?.data?[indexPath.row].userid ?? ""
        vc.isComingFromInboxSection = true
        vc.userID = friendsOrRequestsList?.data?[indexPath.row].userid ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func acceptRequest(at index: Int) {
        let clientDict = friendsOrRequestsList?.data?[index]
        callAcceptORRejectRequest(parameters:["request" :"3", "userid2":clientDict?.userid ?? ""] )
    }
    
    private func rejectRequest(at index: Int) {
        let clientDict = friendsOrRequestsList?.data?[index]
        callAcceptORRejectRequest(parameters:["request" :"4", "userid2":clientDict?.userid ?? ""] )
    }
}

extension FriendsAndRequestsList: UITextFieldDelegate{
    @objc func textIsChanging(_ textField:UITextField){
        searchedString = textField.text!
    }
}
