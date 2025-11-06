/*
 import UIKit
 import MGSwipeTableCell
 
 class Trainer_Post_Details: UIViewController {
 
 //MARK : Outlets and Variables
 
 @IBOutlet weak var mainView: UIView!
 @IBOutlet weak var interface_Title: UILabel!
 
 //MARK : Controller Lifecycle
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
 }
 
 //MARK : IB's Action
 
 @IBAction func back(_ sender: UIButton) {
 self.navigationController?.popViewController(animated: true)
 }
 
 @IBAction func add_Goals(_ sender: UIButton) {
 Universal_Method.universalManager.pushVC("Trainer_Add_Posts", self.navigationController)
 }
 
 //MARK: Helper's Method
 
 }
 */



import UIKit
import MGSwipeTableCell
import SDWebImage
import AVKit
import AVFoundation

class Trainer_Post_Details: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var trainer_Post_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    
    @IBOutlet weak var actionSheet_View: UIView!
    @IBOutlet weak var edit_View: UIView!
    @IBOutlet weak var cancel_View: UIView!
    @IBOutlet weak var delete_View: UIView!
    
    @IBOutlet weak var moreIcon: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    var dateFormatter = DateFormatter()

    fileprivate var selectedPostId = String()
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheet_View.isHidden = true
        edit_View.layoutIfNeeded()
        delete_View.layoutIfNeeded()
        
        cancel_View.layer.cornerRadius = 12.0
        delete_View.roundCorners(topLeft: 0.0, topRight: 0.0, bottomLeft: 12.0, bottomRight: 12.0)
        edit_View.roundCorners(topLeft: 12.0, topRight: 12.0, bottomLeft: 0.0, bottomRight: 0.0)
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(self, selector: #selector(updatedPost(_:)),
                                               name: NSNotification.Name(rawValue: Constants.isUpdatedPosts), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trainer_Post_Tableview.delegate = self
        trainer_Post_Tableview.dataSource = self
        trainer_Post_Tableview.register(UINib(nibName: "Trainer_Post_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Post_Cell")
        trainer_Post_Tableview.reloadData()
        
        let userRole =  DataSaver.dataSaverManager.fetchData(key: "userType") as? String
        let postUserId = particularPostInfo?.userid
        selectedPostId = particularPostInfo?.postID ?? ""
        let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String
        
        if userRole == "1" || userRole == "2"{
            if postUserId == userid{
                moreIcon.isHidden = false
                moreButton.isUserInteractionEnabled = true
            }else{
                moreIcon.isHidden = true
                moreButton.isUserInteractionEnabled = false
            }
        }else{
            moreIcon.isHidden = true
            moreButton.isUserInteractionEnabled = false
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        let postUserId = particularPostInfo?.userid
        let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String
        if postUserId == userid{
            //self.tabBarController?.tabBar.isHidden = true
            actionSheet_View.isHidden = false
        }else{
            UniversalMethod.universalManager.alertMessage("You can edit or delete only your post", self.navigationController)
        }
    }
    
    @IBAction func edit_Post(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        actionSheet_View.isHidden = true
        UniversalMethod.universalManager.pushVC("Trainer_Edit_Post", self.navigationController, storyBoard: AppStoryboard.Trainer_Post_Section.rawValue)
    }
    
    @IBAction func delete_Post(_ sender: UIButton) {
        // actionSheet_View.isHidden = true
        removePost(parameters:["post_id" :particularPostInfo?.postID ?? "0"] )
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        actionSheet_View.isHidden = true
    }

    //MARK: Helper's Method
    @objc func updatedPost(_ notify:NSNotification) {
        getAllPosts(selectedPostId)
    }
    
    @objc func playVideo(from videoURL: URL) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: videoURL)
        
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    private func addPlayButton(to imageView: UIImageView, for videoURL: URL) {
        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playButton.layer.cornerRadius = 40
        playButton.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        imageView.addSubview(playButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        playButton.addAction(UIAction(handler: { _ in
            self.playVideo(from: videoURL)
        }), for: .touchUpInside)
        
        imageView.layoutIfNeeded()
    }
}

extension Trainer_Post_Details: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Trainer_Post_Cell", for: indexPath) as? Trainer_Post_Cell {
            cell.post_View.backgroundColor = UIColor.clear
            cell.post_Desc.numberOfLines = 0

            //cell.name.text = particularPostInfo?.name
            cell.name.text = "\(particularPostInfo?.firstname ?? "") \(particularPostInfo?.lastname ?? "")"

            //cell.post_Date.text = particularPostInfo?.postDate
            cell.total_Likes.text = particularPostInfo?.totalLike
            cell.total_Comment.text = particularPostInfo?.totalComments
            cell.post_Desc.text = particularPostInfo?.datumDescription

            //cell.moveOnUserProfile.tag = indexPath.row
            //cell.moveOnPostContent.tag = indexPath.row

            //        if let photo = particularPostInfo?.image{
            //            if photo != ""{
            //                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
            //                cell.post_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //                cell.post_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "PlaceholderIcon"), options: .highPriority)
            //            }else{
            //                cell.post_Pic.image = #imageLiteral(resourceName: "PlaceholderIcon")
            //            }
            //        }

            if let photo = particularPostInfo?.image {
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.post_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.post_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)

                    cell.post_Pic.sd_setImage(with: URL(string: completePicUrl),
                                              placeholderImage: UIImage(named: "waitPostImage"),
                                              options: SDWebImageOptions(rawValue: 0),
                                              completed: { (img, err, cacheType, imgURL) in
                        cell.post_Pic.contentMode = .scaleAspectFit
                        cell.bgImage.image = cell.post_Pic.image
                        blurEffect(cell.bgImage)
                    })

                }else{
                    cell.post_Pic.image = #imageLiteral(resourceName: "2020-12-10 (1)")
                }
            }
            if let videoUrlString = particularPostInfo?.video, !videoUrlString.isEmpty {
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(videoUrlString)"
                let videoUrl = URL(string: completePicUrl)
              
                // Add a play button overlay to the image view
                addPlayButton(to: cell.post_Pic, for: videoUrl!)
                cell.post_Pic.contentMode = .scaleAspectFill
                cell.bgImage.image = cell.post_Pic.image
                blurEffect(cell.bgImage)
                
                // Optionally, hide the image once the play button is added (optional, if you don't want image visible)
               
            } else {
                cell.post_Pic.isHidden = false // Show image if no video
                // Set the image (same as before)
            }


            if let photo = particularPostInfo?.userImage{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.user_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.user_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.post_Pic.image = #imageLiteral(resourceName: "user")
                }
            }

            if particularPostInfo?.postDate != "" || particularPostInfo?.postDate != "0000-00-00 00:00:00"{
                /*dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 let commentTime = dateFormatter.date(from: particularPostInfo?.postDate ?? "1999-12-01 00:00:00" )
                 dateFormatter.dateFormat = "MMM d, h:mm a"
                 let commentTimes = dateFormatter.string(from: commentTime)
                 cell.post_Date.text = commentTimes*/
                cell.post_Date.text = particularPostInfo?.postDate?.UTCToLocal(withFormat: "yyyy-MM-dd HH:mm:ss", convertedFormat: "MMM d, yyyy, h:mm a")
            }

            if particularPostInfo?.islike == "0" || particularPostInfo?.islike == nil{
                cell.likeIcon.image = #imageLiteral(resourceName: "Shape (3)")
            }else{
                cell.likeIcon.image = #imageLiteral(resourceName: "like (1)")
            }

            cell.likePostAction.addTarget(self, action: #selector(likePost(_:)), for: .touchUpInside)
            cell.commentPostAction.addTarget(self, action: #selector(commentPost(_:)), for: .touchUpInside)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func likePost(_ sender:UIButton){
        if particularPostInfo?.islike == "0"{
            likeDislike(parameters:["post_id":particularPostInfo?.postID ?? "0", "status":"1"] )
        }else{
            likeDislike(parameters:["post_id":particularPostInfo?.postID ?? "0", "status":"0"] )
        }
    }
    
    @objc func commentPost(_ sender:UIButton){
        UniversalMethod.universalManager.pushVC("PostComments", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
}

extension Trainer_Post_Details {
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
                                self.trainer_Post_Tableview.reloadData()
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
