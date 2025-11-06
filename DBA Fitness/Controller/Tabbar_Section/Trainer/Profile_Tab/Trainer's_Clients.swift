
import UIKit
import MGSwipeTableCell
import SDWebImage

class Trainer_s_Clients: UIViewController {
    //1234
    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var interfaceHeaderTitle: UILabel!
    @IBOutlet weak var interfaceCenterTitle: UILabel!
    @IBOutlet weak var centerDiscryptionLabel: UILabel!
    
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    var newURL = String()
    var searchedString = String()
    var replaced = String()
    var stringRep = String()
    var pageNo = 1
    
    var dataID:String?
    var dataIDType:String?
    var isSend:String?
    var type:String? = nil
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.  Looks like you haven't added any client yet.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        searchView.layer.cornerRadius = 20.0
        searchView.layer.borderWidth = 1.0
        searchTF.placeholderColor(color: UIColor.white)
        searchView.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textIsChanging(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if type == "3"{
            interfaceCenterTitle.text = "My Trainers"
            interfaceHeaderTitle.text = "My Trainers"
            centerDiscryptionLabel.text = "Looks like you haven't added any trainer yet."
        }else{
            interfaceCenterTitle.text = "My Clients"
            interfaceHeaderTitle.text = "My Clients"
            centerDiscryptionLabel.text = "Looks like you haven't added any client yet."
        }
        
        clientList(parameters:[:] )
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
            if scrollView == goals_Tableview{
                if (scrollView.contentOffset.y == /*0*/ maximumOffset) {
                    if remainingPagesCount < 1{
                        // UniversalMethod.universalManager.alertMessage("No Product left", self.navigationController)
                    }else{
                        pageNo = pageNo + 1
                        clientList(parameters:[:] )
                    }
                }
            }
        }
    }
    
}

extension Trainer_s_Clients: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = trainerClientList?.data?.count else{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
        }else{
            empty_View.isHidden = true
            goals_Tableview.isHidden = false
            nextButton.isEnabled = true
        }
        return count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Clients_Info", for: indexPath) as? Clients_Info {
            let clientDict = trainerClientList?.data?[indexPath.row]
            
            if let photo = clientDict?.image{
                if photo != "" {
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
            
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(didTapDeleteUser(_:)), for: .touchUpInside)
            cell.deleteIconWidth.constant = 25.0
            cell.deleteIconTrailing.constant = 10.0
            cell.deleteBtn.isUserInteractionEnabled = true
            
            cell.viewSentProgramListMainView.isHidden = false
            cell.viewSentProgramListMainViewHeight.constant = 25.0
            cell.viewSentProgramList.isUserInteractionEnabled = true
            cell.viewSentProgramList.tag = indexPath.row
            cell.viewSentProgramList.addTarget(self, action: #selector(didTappedViewProgramList(_:)), for: .touchUpInside)
            
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
        if isSend == "1" {
            let clientDict = trainerClientList?.data?[indexPath.row]
            if let programsID = clientDict?.all_programs, let selectedProgamID = dataID {
                let arrProgramsID = programsID.components(separatedBy: ",")
                if arrProgramsID.contains(selectedProgamID){
                    Toast.show(message: "Already sent", controller: self)
                }else{
                    callSendExerciseProgram(parameters:["clientid":"\(clientDict?.userid ?? "")",
                                                        "type":dataIDType ?? "",
                                                        "dataid":dataID ?? ""], false )
                }
            } else {
                callSendExerciseProgram(parameters:["clientid":"\(clientDict?.userid ?? "")",
                                                    "type":dataIDType ?? "",
                                                    "dataid":dataID ?? ""], false )
            }
        } else if isSend == "2" {
            let clientDict = trainerClientList?.data?[indexPath.row]
            callSendExerciseProgram(parameters:["clientid":"\(clientDict?.userid ?? "")", "folder_id":dataID ?? ""], true )
        } else {
            let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
            vc.isComingFromTrainerProfileMyClients = true
            vc.selectedClientID = trainerClientList?.data?[indexPath.row].userid ?? ""
            vc.userID = trainerClientList?.data?[indexPath.row].userid ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    @objc func didTapDeleteUser(_ sender: UIButton){
        let dict = trainerClientList?.data?[sender.tag]
        if let userID = dict?.userid{
            removeParticularUser(parameters: ["user_id" : userID])
        }else{
            Toast.show(message: "User id not found", controller: self)
        }
    }
    
    @objc func didTappedViewProgramList(_ sender: UIButton){
        let dict = trainerClientList?.data?[sender.tag]
        if let userID = dict?.userid {
            let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "SentProgramsListVC") as! SentProgramsListVC
            vc.hidesBottomBarWhenPushed = true
            vc.clientID = userID
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            Toast.show(message: "User id not found", controller: self)
        }
    }
}

extension Trainer_s_Clients: UITextFieldDelegate {
    
    @objc func textIsChanging(_ textField:UITextField){
        searchedString = textField.text ?? ""
        clientList(parameters:[:] )
    }
}

extension Trainer_s_Clients{
    private func removeParticularUser(parameters: [String :Any]) {
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.delete_clienttrainer, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        DispatchQueue.main.async {
                            self.clientList(parameters:[:] )
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
