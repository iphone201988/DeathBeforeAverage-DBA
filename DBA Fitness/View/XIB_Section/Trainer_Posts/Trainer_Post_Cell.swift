
import UIKit

class Trainer_Post_Cell: UITableViewCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var post_View: UIView!
    @IBOutlet weak var gradient_View: UIView!
    @IBOutlet weak var image_View: UIView!
    @IBOutlet weak var post_Desc: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var post_Date: UILabel!
    @IBOutlet weak var total_Comment: UILabel!
    @IBOutlet weak var total_Likes: UILabel!
    @IBOutlet weak var post_Pic: UIImageView!
    @IBOutlet weak var comment_View: UIView!
    @IBOutlet weak var like_View: UIView!
    @IBOutlet weak var user_Pic: UIImageView!
    @IBOutlet weak var likePostAction: UIButton!
    @IBOutlet weak var commentPostAction: UIButton!
    
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var likeIcon: UIImageView!
    
    @IBOutlet weak var moveOnUserProfile: UIButton!
    @IBOutlet weak var moveOnPostContent: UIButton!
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    @IBOutlet weak var bgImage: UIImageView!
    
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        post_View.layer.cornerRadius = 7.0
        comment_View.layer.cornerRadius = 4.0
        like_View.layer.cornerRadius = 4.0
        
        image_View.setViewCircle()
        image_View.viewUpdatedShadow(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        user_Pic.setRoundImage()
        
        like_View.layer.borderWidth = 1.0
        like_View.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        comment_View.layer.borderWidth = 1.0
        comment_View.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        like_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        comment_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        
        messageIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.86, radius: 10.5)
        likeIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.86, radius: 10.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.gradient_View.layoutIfNeeded()
        var isTrainerSection = DataSaver.dataSaverManager.fetchData(key: "Trainer_Client") as? String ?? ""
        if isTrainerSection == "Trainer"{
            gradient_View.backgroundColor = UIColor.clear
        }else{
            gradient_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        }
        
        
    }
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

