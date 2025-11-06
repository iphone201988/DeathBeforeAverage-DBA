
import UIKit
import MGSwipeTableCell
import SDWebImage

class ShowingAttachment: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var actionSheet_View: UIView!
    @IBOutlet weak var cancel_View: UIView!
    @IBOutlet weak var delete_View: UIView!
    @IBOutlet weak var selectedPhots: UIImageView!
    
    var imageURL:String?
    var isShowingLocalImage = Bool()
    var localImageURL:URL?
    var interfaceTitle = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheet_View.isHidden = true
        delete_View.layoutIfNeeded()
        cancel_View.layer.cornerRadius = 12.0
        delete_View.roundCorners(topLeft: 0.0, topRight: 0.0, bottomLeft: 12.0, bottomRight: 12.0)
        // mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        selectedPhots.layer.cornerRadius = 4.0
        
        if interfaceTitle != ""{
            interface_Title.text = interfaceTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isShowingLocalImage == true{
            if let url = localImageURL{
                selectedPhots.sd_imageIndicator = SDWebImageActivityIndicator.gray
                selectedPhots.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            }else{
                selectedPhots.image = #imageLiteral(resourceName: "user")
            }
            
        }else{
            if let photoss = imageURL{
                if photoss != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                    
                    selectedPhots.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    selectedPhots.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    selectedPhots.image = #imageLiteral(resourceName: "user")
                }
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
    
    @IBAction func delete_Post(_ sender: UIButton) {}
    
    @IBAction func cancel(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        actionSheet_View.isHidden = true
    }
    
    //MARK: Helper's Method
    
}


