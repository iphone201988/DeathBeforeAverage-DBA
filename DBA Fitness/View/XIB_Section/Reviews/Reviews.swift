
import UIKit

class Reviews: UITableViewCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var review_View: UIView!
    @IBOutlet weak var image_View: UIView!
    @IBOutlet weak var user_Pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var rating_View: UIView!
    @IBOutlet weak var ratingIcon: UIImageView!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image_View.setViewCircle()
        
         image_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.53, radius: 6.5)
        
        user_Pic.setRoundImage()
        review_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        rating_View.customView(borderWidth:1, cornerRadius:4.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        rating_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        ratingIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.3, radius: 5.5)
        name.text = ""
        reviews.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() { }
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

