
import UIKit
import MGSwipeTableCell
import SDWebImage

class PostComments: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var chat_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var messageTypeView: UIView!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var messageTypeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var image_View: UIView!
    @IBOutlet weak var user_Pic: UIImageView!
    
    var refreshControl = UIRefreshControl()
    var isSender = false
    var defaultMessgagVeiwHeight = CGFloat()
    var messageText = String()
    var chatMessagesArray = [M_GetPostCommentsData]()
    var isCommented = Bool()
    var dateFormatter = DateFormatter()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBarController?.tabBar.isHidden = true
        
        image_View.setViewCircle()
        image_View.viewUpdatedShadow(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        user_Pic.setRoundImage()
        
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        chat_Tableview.delegate = self
        chat_Tableview.dataSource = self
        chat_Tableview.register(UINib(nibName: "Comment_Cell", bundle: nil), forCellReuseIdentifier: "Comment_Cell")
        chat_Tableview.reloadData()
        
        chat_Tableview.scrollsToTop = false
        messageTV.delegate = self
        messageTV.addDoneButtonOnKeyboard()
        //  chat_Tableview.addSubview(refreshControl)
        messageTV.textColor = UIColor.gray
        messageTV.text = "Add Comment..."
        defaultMessgagVeiwHeight = messageTypeViewHeight.constant
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(endEditing)))
        isCommented = false
        
        
        let picUrl = DataSaver.dataSaverManager.fetchData(key: "profilePic") as? String
        
        if let photo = picUrl{
            if photo != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                user_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                user_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            }else{
                user_Pic.image = #imageLiteral(resourceName: "user")
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            self.messageTypeView.roundCorners(topLeft: 35.0, topRight: 35.0, bottomLeft: 0.0, bottomRight: 35.0)
            self.messageTypeView.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postComments(parameters:[:] )
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        NotificationCenter.default.post(name:NSNotification.Name(Constants.isUpdatedPosts), object:true)
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if NVActivityIndicator.managerHandler.isIndicatorVisible(){
            //Task is in progress.
            
        } else if messageTV.textColor != UIColor.gray && messageTV.text! != ""{
            let text = messageTV.text
            messageText = (text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)) ?? ""
            if messageText == ""{
                //Empty message.
            }
            else if messageText.isEmptyOrWhitespace(){
                messageTV.text = ""
            }else{
                messageTV.text = ""
                messageTypeViewHeight.constant = defaultMessgagVeiwHeight
                isCommented = true
                postComments(parameters:["post_id":particularPostInfo?.postID ?? "0","comment":messageText] )
                //self.scrollToBottom()
                //messageTV.handleKeyboardActivity()
            }
        }
    }
    
    
    //MARK: Helper's Method
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        
    }
    
    @objc func endEditing(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardCancel(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    //MARK: - Keyboard Show
    @objc func keyboardWillShow(notification: Notification) {
        guard let notificationUserInfo = notification.userInfo else { return }
        let userInfo:NSDictionary = notificationUserInfo as NSDictionary
        if let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.messageViewBottom.constant = keyboardHeight - 10
                self.loadViewIfNeeded()
                self.scrollToBottom()
            })
        }
    }
    
    //MARK: - Keyboard Hide
    @objc func keyboardWillHide(notification: Notification) {
        DispatchQueue.main.async {
            self.messageViewBottom.constant = 0
            self.loadViewIfNeeded()
            self.scrollToBottom()
        }
    }
    
    @objc func scrollToBottom(){
        DispatchQueue.main.async {
            self.chat_Tableview.reloadData()
            
            if self.chatMessagesArray.count > 2 {
                self.chat_Tableview.scrollToRow(at: IndexPath(row: self.chatMessagesArray.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
}

extension PostComments: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let count = chatMessagesArray.count
        if count == 0{
            empty_View.isHidden = false
            chat_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            chat_Tableview.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Comment_Cell", for: indexPath) as? Comment_Cell {
            let chatDict = chatMessagesArray[indexPath.row]
            cell.comment.text = chatDict.comment
            cell.name.text = chatDict.name

            if let photo = chatDict.userImage{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.user_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.user_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.user_Pic.image = #imageLiteral(resourceName: "user")
                }
            }

            if chatDict.createdon != "" || chatDict.createdon != "0000-00-00 00:00:00"{
                /*dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 let commentTime = dateFormatter.date(from: chatDict.createdon ?? "1999-12-01 00:00:00" )
                 dateFormatter.dateFormat = "MMM d, h:mm a"
                 let commentTimes = dateFormatter.string(from: commentTime)
                 cell.comment_Date.text = commentTimes*/

                cell.comment_Date.text = chatDict.createdon?.UTCToLocal(withFormat: "yyyy-MM-dd HH:mm:ss", convertedFormat: "MMM d, yyyy, h:mm a")
            }

            //cell.comment_Date.text = "11:50 PM"

            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension PostComments: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Add Comment..."
            textView.textColor = UIColor.gray
        }
    }
    
}
