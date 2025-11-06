
import UIKit
import MGSwipeTableCell
import SDWebImage

class Trainer_Selected_AchievementCertificate: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var actionSheet_View: UIView!
    @IBOutlet weak var cancel_View: UIView!
    @IBOutlet weak var delete_View: UIView!
    @IBOutlet weak var selectedPhots: UIImageView!
    
    var clientInfo = [String:Any]()
    var files = [Int]()
    var goalsArray = [String]()
    var selectedMediaID = Int()
    var photoURL:URL?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheet_View.isHidden = true
        delete_View.layoutIfNeeded()
        cancel_View.layer.cornerRadius = 12.0
        delete_View.roundCorners(topLeft: 0.0, topRight: 0.0, bottomLeft: 12.0, bottomRight: 12.0)
        // mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        selectedPhots.layer.cornerRadius = 4.0
         NotificationCenter.default.addObserver(self, selector: #selector(modifyGallery(_:)), name: NSNotification.Name(rawValue: Constants.updateGallery), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if let photoss = particularCertificateInfo{
            if photoss != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                
                selectedPhots.sd_imageIndicator = SDWebImageActivityIndicator.gray
                selectedPhots.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            }else{
                selectedPhots.image = #imageLiteral(resourceName: "user")
            }
        }
    }
    
    @objc func modifyGallery(_ notify:NSNotification){
        let isUpdated = notify.object as? Bool
        if isUpdated == true{
           
            DispatchQueue.main.async {
               //self.tabBarController?.tabBar.isHidden = false
                self.actionSheet_View.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = true
        actionSheet_View.isHidden = false
    }
    
    @IBAction func delete_Post(_ sender: UIButton) {

        
        //self.clientInfo["goals"] = self.goalsArray
      /*  p_ClientGallery["lastName"] = loginInfo?.lastName
        p_ClientGallery["firstName"] = loginInfo?.firstName
        p_ClientGallery["clientInfo"] = self.clientInfo
        
        guard let count = loginInfo?.files?.count else{
            return
        }
        if count > 0{
            for dict in (loginInfo?.files) {
                files.append(dict.id ?? 0)
            }
            let indexs = files.firstIndex(of: selectedMediaID)
            files.remove(at: indexs)
            p_ClientGallery["files"] = self.files
        }
        self.deleteGalleryMedia(parameters:p_ClientGallery)*/
        
         Constants.isSelectedPhotos = "1"
        
        if Constants.isCertificatePic == "1"{
            //userGallery(image: photoURL, gallery_id:particularGalleryDict?.id ?? "0")
        }else{
            userGallery(image: photoURL, gallery_id:particularGalleryDict?.id ?? "0")
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        actionSheet_View.isHidden = true
    }
    
    
    //MARK: Helper's Method
    
}


