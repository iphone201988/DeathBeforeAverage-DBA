
import UIKit
import MGSwipeTableCell
import SDWebImage

class Incoming_Messages: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var incoming_Message_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    var refreshControl = UIRefreshControl()
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(programsInfo(_:)), name: NSNotification.Name(rawValue: Constants.getProgramsDetails), object: nil)
        
        self.refreshControl.tintColor = .white
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.incoming_Message_Tableview.refreshControl = refreshControl

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(callApiRequest(_:)),
                                               name: NSNotification.Name(rawValue: "callApiRequest"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMessages(parameters:[:] )
        let tabBarItem = self.tabBarController?.tabBar.items?[3]
        tabBarItem?.badgeValue = ""
        tabBarItem?.badgeColor = .clear
    }
    
    @objc func programsInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            self.refreshControl.endRefreshing()
            incoming_Message_Tableview.delegate = self
            incoming_Message_Tableview.dataSource = self
            incoming_Message_Tableview.register(UINib(nibName: "Incoming_Message_Cell", bundle: nil), forCellReuseIdentifier: "Incoming_Message_Cell")
            incoming_Message_Tableview.reloadData()
        }
    }
    
    @objc func refresh(){
        // Code to refresh view
        getMessages(parameters:[:] )
    }

    @objc func callApiRequest(_ notify:NSNotification) {
        getMessages(parameters:[:] )
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
}

extension Incoming_Messages: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = getMessageInfo?.data?.count else{
            empty_View.isHidden = false
            incoming_Message_Tableview.isHidden = true
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            incoming_Message_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            incoming_Message_Tableview.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Incoming_Message_Cell", for: indexPath) as? Incoming_Message_Cell {

            let messageDict = getMessageInfo?.data?[indexPath.row]
            cell.message_Text.text = messageDict?.message

            if messageDict?.messageCount ?? 0 > 0{
                cell.message_badge.text = "\(messageDict?.messageCount ?? 0)"
                cell.counter_View.isHidden = false
            }else{
                cell.message_badge.text = ""
                cell.counter_View.isHidden = true
            }

            cell.sender_Name.text = messageDict?.senderName

            if let photo = messageDict?.image{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.sender_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.sender_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.sender_Pic.image = #imageLiteral(resourceName: "user")
                }
            }

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.sender_Pic.tag = indexPath.row
            cell.sender_Pic.isUserInteractionEnabled = true
            cell.sender_Pic.addGestureRecognizer(tapGestureRecognizer)

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        particularMessage = getMessageInfo?.data?[indexPath.row]
        readInboxMessages(parameters:["sender_id":particularMessage?.senderID ?? "0"] )
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        // Your action
        let particularMessage = getMessageInfo?.data?[tappedImage.tag]
        
        let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
        vc.selectedClientID = particularMessage?.senderID ?? ""
        vc.isComingFromInboxSection = true
        vc.userID = particularMessage?.senderID ?? "0"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

