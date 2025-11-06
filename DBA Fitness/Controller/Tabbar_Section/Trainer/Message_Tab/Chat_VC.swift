
import UIKit
import MGSwipeTableCell
import AVFoundation
import AVKit
import IQKeyboardManagerSwift
import SDWebImage

class Chat_VC: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var chat_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var messageTypeView: UIView!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var messageTypeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var sendView: GradientView_Send!
    @IBOutlet weak var receiverName: UILabel!
    
    var refreshControl = UIRefreshControl()
    var defaultMessgagVeiwHeight = CGFloat()
    var messageText = String()
    var chatMessagesArray = [M_SendMessagesData]()
    var dateFormatter = DateFormatter()
    var photoURL:URL?
    var videoURL:URL?
    var imagePickers:UIImagePickerController = UIImagePickerController()
    let playerViewController = AVPlayerViewController()
    var apiCallTimer: Timer?
    var reciver_id: String? = nil
    var selectedReceiverName: String = ""

    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sendView.layer.cornerRadius = 3.0
        chat_Tableview.scrollsToTop = false
        chat_Tableview.allowsSelection = true
        messageTV.delegate = self
        messageTV.addDoneButtonOnKeyboard()
        //chat_Tableview.addSubview(refreshControl)
        messageTV.textColor = UIColor.gray
        messageTV.text = "Write Message..."
        
        defaultMessgagVeiwHeight = messageTypeViewHeight.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(endEditing)))
        sendView.customViewsShadow(red: 253/255, green: 96/255, blue: 55/255, alpha: 1.0, width: 0, height: 2, opacity: 0.42, radius: 1.5)
        
        imagePickers.delegate = self
        
        photoURL = nil
        videoURL = nil

        if Constants.isMessageTab == "0"{
            
            if let reciver_id = reciver_id {
                self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
            }else{
                if let reciver_id = searchedTrainerInfo?.userid {
                    self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                }

            }
            
            //self.sendChatMessage(image:self.photoURL,reciver_id:searchedTrainerInfo?.userid ?? "0", message:"", video:self.videoURL)
            
        }else if (Constants.isMessageTab == "2"){
            
            if let reciver_id = reciver_id {
                self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
            }else{
                if let reciver_id = userInfo?.data?.userid {
                    self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                }

            }
            
            //self.sendChatMessage(image:self.photoURL,reciver_id:userInfo?.data?.userid ?? "0", message:"", video:self.videoURL)
        }else{
            if let reciver_id = reciver_id {
                self.sendChatMessage(image:self.photoURL,reciver_id: reciver_id, message:"", video:self.videoURL)
            } else {
                if let reciver_id = particularMessage?.senderID {
                    self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(programsInfo(_:)),
                                               name: NSNotification.Name(rawValue: Constants.getProgramsDetails),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(callApiRequest(_:)),
                                               name: NSNotification.Name(rawValue: "callApiRequest"),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        receiverName.text = selectedReceiverName
        
        //sendMessage(parameters:[:] )
        
        //photoURL = nil
        //videoURL = nil
        
        /* if Constants.isMessageTab == "0"{
         self.sendChatMessage(image:self.photoURL,reciver_id:searchedTrainerInfo?.userid ?? "0", message:"", video:self.videoURL)
         }else if (Constants.isMessageTab == "2"){
         self.sendChatMessage(image:self.photoURL,reciver_id:userInfo?.data?.userid ?? "0", message:"", video:self.videoURL)
         }else{
         self.sendChatMessage(image:self.photoURL,reciver_id:particularMessage?.senderID ?? "0", message:"", video:self.videoURL)
         }*/
        
        //sendMessage(image:photoURL,reciver_id:"", message:"")
        
        //IQKeyboardManager.shared.enable = true
        
        
        let tabBarItem = self.tabBarController?.tabBar.items?[3]
        tabBarItem?.badgeValue = ""
        tabBarItem?.badgeColor = .clear
        
        //        apiCallTimer = Timer.scheduledTimer(timeInterval: 2.0,
        //                                            target: self,
        //                                            selector: #selector(callApiRequest),
        //                                            userInfo: nil,
        //                                            repeats: true)
    }
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //        apiCallTimer?.invalidate()
    //    }
    
    @objc func programsInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            if Constants.isMessageTab == "0"{
                
                if let reciver_id = reciver_id {
                    self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                }else{
                    if let reciver_id = searchedTrainerInfo?.userid {
                        self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                    }

                }
                
            }else if (Constants.isMessageTab == "2"){
                
                if let reciver_id = reciver_id {
                    self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                }else{
                    if let reciver_id = userInfo?.data?.userid {
                        self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                    }
                }
                
            }else{
                if let reciver_id = reciver_id {
                    self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                } else {
                    if let reciver_id = particularMessage?.senderID {
                        self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                    }
                }


            }
        }
    }
    
    /*
     @objc func callApiRequest(){

     photoURL = nil
     videoURL = nil

     if Constants.isMessageTab == "0"{
     self.sendChatMessage(image:self.photoURL,
     reciver_id:searchedTrainerInfo?.userid ?? "0",
     message:"",
     video:self.videoURL,
     isHideLoader: true)
     }else if (Constants.isMessageTab == "2"){
     self.sendChatMessage(image:self.photoURL,
     reciver_id:userInfo?.data?.userid ?? "0",
     message:"",
     video:self.videoURL,
     isHideLoader: true)
     }else{
     self.sendChatMessage(image:self.photoURL,
     reciver_id:particularMessage?.senderID ?? "0",
     message:"",
     video:self.videoURL,
     isHideLoader: true)
     }
     }*/
    
    @objc func callApiRequest(_ notify:NSNotification){
        photoURL = nil
        videoURL = nil

        if Constants.isMessageTab == "0"{
            
            if let reciver_id = reciver_id {
                self.sendChatMessage(image:self.photoURL,
                                     reciver_id:reciver_id,
                                     message:"",
                                     video:self.videoURL,
                                     isHideLoader: true)
            }else{
                if let reciver_id = searchedTrainerInfo?.userid, !reciver_id.isEmpty  {
                    self.sendChatMessage(image:self.photoURL,
                                         reciver_id:reciver_id,
                                         message:"",
                                         video:self.videoURL,
                                         isHideLoader: true)
                }

            }
            

            
        }else if (Constants.isMessageTab == "2"){
            
            if let reciver_id = reciver_id {
                self.sendChatMessage(image:self.photoURL,
                                     reciver_id:reciver_id,
                                     message:"",
                                     video:self.videoURL,
                                     isHideLoader: true)
            }else{
                if let reciver_id = userInfo?.data?.userid, !reciver_id.isEmpty {
                    self.sendChatMessage(image:self.photoURL,
                                         reciver_id:reciver_id,
                                         message:"",
                                         video:self.videoURL,
                                         isHideLoader: true)
                }

            }
        }else{
            if let reciver_id = reciver_id {
                self.sendChatMessage(image:self.photoURL,
                                     reciver_id:reciver_id,
                                     message:"",
                                     video:self.videoURL,
                                     isHideLoader: true)
            } else {
                if let senderID = particularMessage?.senderID, !senderID.isEmpty {
                    self.sendChatMessage(image:self.photoURL,
                                         reciver_id:senderID,
                                         message:"",
                                         video:self.videoURL,
                                         isHideLoader: true)
                }
            }
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        Constants.isMessageTab = "1"
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
                
                //messageTV.resignFirstResponder()
                //                NotificationCenter.default.post(name:NSNotification.Name(UIResponder.keyboardWillHideNotification.rawValue), object:nil)
                
                if Constants.isMessageTab == "0"{
                    //sendMessage(parameters:["reciver_id":searchedTrainerInfo?.userid ?? "0","message":messageText] )
                    
                    if let reciver_id = reciver_id {
                        sendChatMessage(image:photoURL,reciver_id:reciver_id, message:messageText, video:self.videoURL)
                    }else{
                        if let reciver_id = searchedTrainerInfo?.userid {
                            sendChatMessage(image:photoURL,reciver_id:reciver_id, message:messageText, video:self.videoURL)
                        }

                    }
                    

                }else if (Constants.isMessageTab == "2"){
                    //sendMessage(parameters:["reciver_id":userInfo?.data?.userid ?? "0","message":messageText] )
                    
                    if let reciver_id = reciver_id {
                        sendChatMessage(image:photoURL,reciver_id:reciver_id, message:messageText, video:self.videoURL)
                    }else{
                        if let reciver_id = userInfo?.data?.userid {
                            sendChatMessage(image:photoURL,reciver_id:reciver_id, message:messageText, video:self.videoURL)
                        }

                    }

                }else{
                    //sendMessage(parameters:["reciver_id":particularMessage?.senderID ?? "0","message":messageText] )
                    if let reciver_id = reciver_id {
                        sendChatMessage(image:photoURL,reciver_id:reciver_id, message:messageText, video:self.videoURL)
                    } else {
                        if let reciver_id = particularMessage?.senderID {
                            sendChatMessage(image:photoURL,reciver_id:reciver_id, message:messageText, video:self.videoURL)
                        }
                    }

                }
                //self.scrollToBottom()
                //messageTV.handleKeyboardActivity()
            }
        }
    }
    
    @IBAction func attachmentAction(_ sender: UIButton) {
        mediaHandler()
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
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.messageViewBottom.constant = keyboardHeight - 10
            self.loadViewIfNeeded()
            self.scrollToBottom()
        })
    }
    
    //MARK: - Keyboard Hide
    @objc func keyboardWillHide(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.messageViewBottom.constant = 0.0
            self.loadViewIfNeeded()
            self.scrollToBottom()
        })
    }
    
    @objc func scrollToBottom(){
        DispatchQueue.main.async {
            self.chat_Tableview.reloadData {
                if self.chatMessagesArray.count > 2 {
                    self.chat_Tableview.scrollToRow(at: IndexPath(row: self.chatMessagesArray.count - 1, section: 0), at: .none, animated: false)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func mediaHandler(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Mark: Helper/Calling Function
    func openGallary(){
        imagePickers.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePickers.mediaTypes = ["public.movie","public.image"]
        imagePickers.allowsEditing = false
        self.present(imagePickers, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            imagePickers.mediaTypes = ["public.movie","public.image"]
            imagePickers.allowsEditing = false
            self.present(imagePickers, animated: true, completion: nil)
        }else    {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension Chat_VC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // empty_View.isHidden = true
        
        if chatMessagesArray.count > 0{
            empty_View.isHidden = true
        }else{
            empty_View.isHidden = false
        }
        
        return chatMessagesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatDict = chatMessagesArray[indexPath.row]
        
        let userID = DataSaver.dataSaverManager.fetchData(key: "userid") as? String
        
        if userID == chatDict.senderID{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Sender_Chat_Cell", for: indexPath) as? Sender_Chat_Cell {

                if chatDict.message != ""{
                    cell.message_Text.text = chatDict.message
                    cell.message_View.isHidden = false
                    cell.messageTop.constant = 15.0
                    cell.messageBottom.constant = 15.0
                }else{
                    cell.message_Text.text = ""
                    cell.message_View.isHidden = true
                    cell.messageTop.constant = 0.0
                    cell.messageBottom.constant = 0.0
                }

                if chatDict.createdOn != "" || chatDict.createdOn != "0000-00-00 00:00:00"{
                    /*dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                     let commentTime = dateFormatter.date(from: chatDict.createdOn ?? "1999-12-01 00:00:00" )
                     dateFormatter.dateFormat = "MMM d, h:mm a"
                     let commentTimes = dateFormatter.string(from: commentTime)
                     cell.message_Time.text = commentTimes*/
                    cell.message_Time.text = chatDict.createdOn?.UTCToLocal(withFormat: "yyyy-MM-dd HH:mm:ss", convertedFormat: "MMM d, yyyy, h:mm a")
                }

                /*if let photos = chatDict.image{
                 if photos != ""{
                 let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photos)"
                 
                 cell.attachmentImage.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                 cell.attachmentImage.layer.cornerRadius = 10.0
                 cell.attachmentImageHeight.constant = 100.0
                 }else{
                 cell.attachmentImageHeight.constant = 0.0
                 }
                 }else{
                 cell.attachmentImageHeight.constant = 0.0
                 }*/

                if chatDict.image != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(chatDict.image ?? "")"
                    
                    cell.attachmentImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.attachmentImage.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                    cell.attachmentImage.layer.cornerRadius = 10.0
                    cell.attachmentImageHeight.constant = 100.0
                    cell.attachmentImage.isHidden = false
                }
                if (chatDict.video != ""){
                    cell.attachmentImage.image = #imageLiteral(resourceName: "LaunchBackground")
                    cell.attachmentImage.layer.cornerRadius = 10.0
                    cell.attachmentImageHeight.constant = 100.0
                    cell.attachmentImage.isHidden = false
                }

                if (chatDict.image == "" && chatDict.video == ""){
                    cell.attachmentImage.layer.cornerRadius = 0.0
                    cell.attachmentImageHeight.constant = 0.0
                    cell.attachmentImage.isHidden = true
                }

                if chatDict.video != ""{
                    cell.playIcon.isHidden = false
                }else{
                    cell.playIcon.isHidden = true
                }
                cell.attachedButton.tag = indexPath.row
                cell.attachedButton.addTarget(self, action: #selector(seeAttachmentContent(_:)), for: .touchUpInside)
                return cell
            } else {
                return UITableViewCell()
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver_Chat_Cell", for: indexPath) as? Receiver_Chat_Cell {

                if chatDict.message != ""{
                    cell.message_Text.text = chatDict.message
                    cell.message_View.isHidden = false
                    cell.messageTop.constant = 15.0
                    cell.messageBottom.constant = 15.0
                }else{
                    cell.message_Text.text = ""
                    cell.message_View.isHidden = true
                    cell.messageTop.constant = 0.0
                    cell.messageBottom.constant = 0.0
                }
                if chatDict.createdOn != "" || chatDict.createdOn != "0000-00-00 00:00:00"{
                    /*dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                     let commentTime = dateFormatter.date(from: chatDict.createdOn ?? "1999-12-01 00:00:00" )
                     dateFormatter.dateFormat = "MMM d, h:mm a"
                     let commentTimes = dateFormatter.string(from: commentTime)
                     cell.message_Time.text = commentTimes*/
                    cell.message_Time.text = chatDict.createdOn?.UTCToLocal(withFormat: "yyyy-MM-dd HH:mm:ss", convertedFormat: "MMM d, yyyy, h:mm a")
                }

                /*if let photos = chatDict.image{
                 if photos != ""{
                 let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photos)"
                 
                 cell.attachmentImage.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                 cell.attachmentImage.layer.cornerRadius = 10.0
                 cell.attachmentImageHeight.constant = 100.0
                 }else{
                 cell.attachmentImageHeight.constant = 0.0
                 }
                 }else if (chatDict.video != ""){
                 cell.attachmentImageHeight.constant = 100.0
                 }else{
                 cell.attachmentImageHeight.constant = 0.0
                 }*/

                if chatDict.image != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(chatDict.image ?? "")"
                    
                    cell.attachmentImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.attachmentImage.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                    cell.attachmentImage.layer.cornerRadius = 10.0
                    cell.attachmentImageHeight.constant = 100.0
                    cell.attachmentImage.isHidden = false
                }
                if (chatDict.video != ""){
                    cell.attachmentImage.image = #imageLiteral(resourceName: "LaunchBackground")
                    cell.attachmentImage.layer.cornerRadius = 10.0
                    cell.attachmentImageHeight.constant = 100.0
                    cell.attachmentImage.backgroundColor = UIColor(named: "Sub_Interface_BG_CC")
                    cell.attachmentImage.isHidden = false
                }

                if (chatDict.image == "" && chatDict.video == ""){
                    cell.attachmentImage.layer.cornerRadius = 0.0
                    cell.attachmentImageHeight.constant = 0.0
                    cell.attachmentImage.isHidden = true
                }

                if chatDict.video != ""{
                    cell.playIcon.isHidden = false
                }else{
                    cell.playIcon.isHidden = true
                }
                cell.attachedButton.tag = indexPath.row
                cell.attachedButton.addTarget(self, action: #selector(seeAttachmentContent(_:)), for: .touchUpInside)
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    @objc func seeAttachmentContent(_ sender: UIButton){
        
        let chatDict = chatMessagesArray[sender.tag]
        if chatDict.video != ""{
            let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(chatDict.video ?? "")"
            if let videoURL = URL(string: completePicUrl) {
                let player = AVPlayer(url: videoURL)
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
            }

        }else{
            let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
            vc.imageURL = chatDict.image
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension Chat_VC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write Message..."
            textView.textColor = UIColor.gray
        }
    }
}

extension Chat_VC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: - CameraPicker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaType  == "public.image" {
                
                var mediaContentImage: UIImage?
                
                if let imageEdited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    mediaContentImage = imageEdited
                } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    mediaContentImage = image
                }else{
                    UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
                }
                
                guard let image = mediaContentImage else { return }
                
                
                // if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                reducedUploadingImage = image.compressedImages()
                self.photoURL = Chat_VC.saveImageInDocumentDirectory(image: reducedUploadingImage ?? #imageLiteral(resourceName: "2020-12-10 (1)"), fileName: filename)
                let alertController = UIAlertController(title: "DBA Fitness", message: "During send message, don't close or minimize your app", preferredStyle: .alert)
                alertController.addTextField { (textField : UITextField) -> Void in
                    textField.placeholder = "Type something ... (optional)"
                }
                let saveAction = UIAlertAction(title: "Send", style: .default, handler: { alert -> Void in
                    let inputFieldContent = alertController.textFields?.first?.text ?? ""
                    NotificationCenter.default.post(name:NSNotification.Name(UIResponder.keyboardWillHideNotification.rawValue), object:nil)
                    if Constants.isMessageTab == "0"{

                        if let reciver_id = self.reciver_id{
                            self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:inputFieldContent, video:self.videoURL)
                        }else{
                            if let reciver_id = searchedTrainerInfo?.userid {
                                self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:inputFieldContent, video:self.videoURL)
                            }

                        }

                    }else if (Constants.isMessageTab == "2"){

                        if let reciver_id = self.reciver_id{
                            self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:inputFieldContent, video:self.videoURL)
                        }else{
                            if let reciver_id = userInfo?.data?.userid {
                                self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:inputFieldContent, video:self.videoURL)
                            }

                        }


                    }else{
                        if let reciver_id = self.reciver_id {
                            self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:inputFieldContent, video:self.videoURL)
                        } else {
                            if let reciver_id = particularMessage?.senderID {
                                self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:inputFieldContent, video:self.videoURL)
                            }
                        }


                    }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { alert -> Void in
                    self.photoURL = nil
                    self.videoURL = nil
                    NotificationCenter.default.post(name:NSNotification.Name(UIResponder.keyboardWillHideNotification.rawValue), object:nil)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(saveAction)
                self.dismiss(animated: true, completion: nil);
                self.present(alertController, animated: true, completion: nil)
                //                }else{
                //                    UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
                //                }
            }
            
            if mediaType == "public.movie" {
                videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                
                if Constants.isMessageTab == "0"{
                    
                    if let reciver_id = self.reciver_id{
                        self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                    }else{
                        if let reciver_id = searchedTrainerInfo?.userid {
                            self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                        }

                    }
                    
                }else if (Constants.isMessageTab == "2"){
                    
                    if let reciver_id = self.reciver_id{
                        self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                    }else{
                        if let reciver_id = userInfo?.data?.userid {
                            self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                        }

                    }
                    
                }else{
                    if let reciver_id = self.reciver_id {
                        self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                    } else {
                        if let reciver_id = particularMessage?.senderID {
                            self.sendChatMessage(image:self.photoURL,reciver_id:reciver_id, message:"", video:self.videoURL)
                        }
                    }

                }
                
                self.dismiss(animated: true, completion: nil);
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry.", self.navigationController)
        }
    }
    public static func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL?{
        guard
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData(){
            try? imageData.write(to: fileURL, options: .atomic)
            return fileURL
        }
        return nil
    }
}

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion()}
    }
}
