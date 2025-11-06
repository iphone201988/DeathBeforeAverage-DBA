

import UIKit

class Comment_Cell: UITableViewCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var image_View: UIView!
    @IBOutlet weak var user_Pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var comment_Date: UILabel!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image_View.setViewCircle()
        image_View.viewUpdatedShadow(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        user_Pic.setRoundImage()
        name.text = ""
        comment.text = ""
        comment_Date.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

